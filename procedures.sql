
 delimiter //
CREATE PROCEDURE CancelarVendaPDV (IN argVendaCanceladaId INT, 
        IN  argUsuarioId INT)
  BEGIN
         
    -- altera o status da venda para cancelado
    UPDATE 
      Venda 
    SET 
      Status = 'C',
      UsuarioCancelamentoId = argUsuarioId,
      DataHoraCancelamento = NOW()
    WHERE 
      Id = argVendaCanceladaId;

    -- cancela todos os itens da venda
    UPDATE
      VendaDetalhe 
    SET
      Cancelado = true,
      UsuarioCancelamentoId = argUsuarioId,
      DataHoraCancelamento = NOW()
    WHERE
      VendaId = argVendaCanceladaId;

  END//

delimiter ;


 delimiter //

CREATE PROCEDURE CancelarDetalheVendaPDV (
        IN argDetalheVendaCanceladoId INT, 
        IN argUsuarioId INT)
  BEGIN
         
    -- cancela item da venda
    UPDATE
      VendaDetalhe 
    SET
      Cancelado = true,
      UsuarioCancelamentoId = argUsuarioId,
      DataHoraCancelamento = NOW()
    WHERE
      Id = argDetalheVendaCanceladoId;

  END//

delimiter ;

delimiter //

CREATE PROCEDURE AtualizarEstoqueItem (
        IN argItemId INT, 
        IN argUsuarioId INT)
  BEGIN
         
    -- cancela item da venda
    UPDATE
      VendaDetalhe 
    SET
      Cancelado = true,
      UsuarioCancelamentoId = argUsuarioId,
      DataHoraCancelamento = NOW()
    WHERE
      Id = argDetalheVendaCanceladoId;

  END//

delimiter ;

delimiter //
CREATE FUNCTION VendaEmAberto(argVendaFinalizadaId INT)
  RETURNS int
  DETERMINISTIC
  BEGIN
    DECLARE vQtdVenda int;

    SELECT            
      COUNT(1)
    INTO
      vQtdVenda
    FROM
      Venda 
    WHERE
      Id = argVendaFinalizadaId AND
      Status = 'A' AND
      PDV;

    RETURN vQtdVenda;
    
  END//
delimiter ;

delimiter //
CREATE PROCEDURE FinalizarVendaPDV (
        IN argVendaFinalizadaId INT, 
        IN argUsuarioId INT)
  BEGIN
    DECLARE vQtdVenda int;
    DECLARE vOrcamento tinyint;
    DECLARE vItemId int;
    DECLARE vQuantidade decimal(11,4);
    DECLARE vConferido decimal(11,4);
    DECLARE vConferidoAnterior decimal(11,4);
    DECLARE vDisponivel decimal(11,4);
    DECLARE vPrecoCusto decimal(12,2); 
    DECLARE vSaldoAnteriorCaixa decimal(12,2);
    DECLARE vPago decimal(12,2);
    DECLARE vTroco decimal(12,2);
    
    DECLARE done int default 0;

    DECLARE cursorItens CURSOR FOR
      SELECT
        vd.ItemId,
        vd.Quantidade,
        it.Disponivel,
        it.Conferido,
        it.PrecoCusto
      FROM
        VendaDetalhe vd
        INNER JOIN Item it ON vd.ItemId = it.Id
      WHERE
        vd.VendaId = argVendaFinalizadaId AND
        NOT vd.Cancelado;    

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;


    IF VendaEmAberto(argVendaFinalizadaId) > 0 THEN

      SELECT
        Orcamento,
        Pago,
        Troco
      INTO
        vOrcamento,
        vPago,
        vTroco
      FROM
        Venda
      WHERE      
        Id = argVendaFinalizadaId;

      -- atualiza estoques dos itens
      OPEN cursorItens;
      cursorloop:loop
        SET vConferido = 0;

        FETCH cursorItens INTO 
              vItemId,
              vQuantidade,
              vDisponivel,
              vConferidoAnterior,
              vPrecoCusto;

        IF done = true then  
          leave cursorloop;
        END IF;

        IF NOT vOrcamento THEN
            SET vConferido = vQuantidade;
        END IF;

        INSERT INTO MovimentoItem
        (
          ItemId, 
          SaldoAnterior, 
          Quantidade, 
          Saldo, 
          Tipo, 
          CustoAnterior, 
          NovoCusto,
          ConferidoAnterior,
          SaldoConferido
        )
        VALUES
        (
          vItemId,
          vDisponivel,
          vQuantidade,
          vDisponivel - vQuantidade,
          'V',
          vPrecoCusto,
          vPrecoCusto,
          vConferidoAnterior,
          vConferidoAnterior - vConferido
        );

        UPDATE 
            Item 
        SET 
            Reservado = Reservado - vQuantidade,
            Disponivel = Disponivel - vQuantidade,
            Conferido = Conferido - vConferido
        WHERE 
            Id = vItemId;

      END LOOP cursorloop;
      CLOSE cursorItens;
      
      -- atualiza status na tabela Venda
      UPDATE 
        Venda
      SET
        Status = 'F',
        UsuarioAprovacaoId = argUsuarioId
      WHERE
        Id = argVendaFinalizadaId;

      -- atualiza movimento de caixa      
      UPDATE 
        MovimentoCaixa
      SET 
        Recebido = Recebido + vPago,
        Troco = Troco + vTroco,
        Saldo = Saldo + (vPago - vTroco)
      WHERE
        UsuarioId = argUsuarioId AND
        DataCaixa = CURRENT_DATE; 

      CALL GerarContasAReceberVenda(argVendaFinalizadaId, argUsuarioId);

    END IF; 

  END//
delimiter ;

delimiter //
CREATE PROCEDURE GerarContasAReceberVenda (
        IN argVendaFinalizadaId INT, 
        IN argUsuarioId INT)
  BEGIN
    DECLARE done int default 0;
    DECLARE vDataVenda Date;
    DECLARE vDataPrimeiraParcela Date;
    DECLARE vValorPago decimal(12,2);
    DECLARE vDiasEntreParcelas int;    
    DECLARE vDisponivelEm int;
    DECLARE vParcelas int;
    DECLARE vContaFinanceiraId int;
    DECLARE vVendaPagamentoId int;
    DECLARE vNumeroParcela int;

    DECLARE vSaldoAnteriorContaFinanceira decimal(12,2);

    DECLARE vValorParcela decimal(12,2);
    DECLARE vValorRecebido decimal(12,2);
    DECLARE vVencimento DATE;

    DECLARE vContasAReceberId int;
    DECLARE vSituacaoCR varchar(1);
 
    DECLARE cursorPagamento CURSOR FOR
      SELECT 
          vp.Id,
          CAST(ve.DataVenda AS DATE) AS DataVenda,
          vp.ValorPago,
          DATE_ADD(CAST(ve.DataVenda AS DATE), INTERVAL fp.DisponivelEm DAY) DataPrimeiraParcela,
          fp.ContaFinanceiraId,
          fp.Parcelas,
          fp.DiasEntreParcelas,
          fp.DisponivelEm
      FROM 
          VendaPagamento vp 
          INNER JOIN Venda ve ON vp.VendaId = ve.Id
          INNER JOIN FormaPagamento fp ON vp.FormaPagamentoId = fp.Id 
      WHERE
          vp.VendaId = argVendaFinalizadaId
      ORDER BY
          vp.Id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cursorPagamento;
      cursorloop:loop

        FETCH cursorPagamento INTO
          vVendaPagamentoId,
          vDataVenda,
          vValorPago,
          vDataPrimeiraParcela,
          vContaFinanceiraId,
          vParcelas,
          vDiasEntreParcelas,
          vDisponivelEm;

        IF done = true then  
          leave cursorloop;          
        END IF;
        -- Inserir conta a receber
        INSERT INTO ContasAReceber 
        (
          UsuarioId,
          DataCadastro,
          ValorAReceber,
          DiasEntreParcelas,
          DataPrimeiraParcela,
          VendaPagamentoId,
          Parcelas          
        )
        VALUES
        (
          argUsuarioId,
          vDataVenda,
          vValorPago,
          vDiasEntreParcelas,
          vDataPrimeiraParcela,
          vVendaPagamentoId,
          vParcelas
        );

        SELECT LAST_INSERT_ID() INTO vContasAReceberId;

        -- insere parcelas de contas a receber
        set vNumeroParcela = 1;
        WHILE vNumeroParcela <= vParcelas DO
          set vValorParcela = vValorPago / vParcelas;
          set vValorRecebido = 0;
          IF vDisponivelEm = 0 THEN
            set vValorRecebido = vValorParcela;
          END IF;
          set vVencimento = DATE_ADD(vDataPrimeiraParcela, INTERVAL vDiasEntreParcelas * vNumeroParcela DAY);
          
          set vSituacaoCR = 'A';
          IF vValorRecebido > 0 THEN
            set vSituacaoCR = 'P';
          END IF;

          INSERT INTO ParcelaContasAReceber
          (
            NumeroParcela,
            ContasAReceberId,
            ValorAReceber,
            ValorRecebido,
            Vencimento,
            Situacao
          )
          VALUES
          (
            vNumeroParcela,
            vContasAReceberId,
            vValorParcela,
            vValorRecebido,
            vVencimento,
            vSituacaoCR
          );

          set vNumeroParcela = vNumeroParcela + 1;
        END WHILE;

        -- insere movimento conta financeira
        SELECT
          COALESCE(SaldoContaFinanceira(argUsuarioId),0)
        INTO
          vSaldoAnteriorContaFinanceira;


        INSERT INTO MovimentoContaFinanceira
        (
          ContaFinanceiraId,
          SaldoAnterior,
          Entrada,
          Saldo,
          UsuarioId
        )
        VALUES
        (
          vContaFinanceiraId,
          vSaldoAnteriorContaFinanceira,
          vValorPago,
          vSaldoAnteriorContaFinanceira + vValorPago,
          argUsuarioId
        );

      END LOOP cursorloop;
      CLOSE cursorPagamento;

  END//

delimiter ;

delimiter //
CREATE FUNCTION SaldoCaixa (argUsuarioId INT)
  RETURNS DECIMAL
  DETERMINISTIC
BEGIN
  DECLARE vSaldo DECIMAL;
  
  SELECT 
    Saldo AS Saldo
  INTO
    vSaldo
  FROM
    MovimentoCaixa
  WHERE
    UsuarioId = argUsuarioId
  ORDER BY
    DataHora DESC
  LIMIT 1;

  RETURN vSaldo;

END //
delimiter ;

delimiter //
CREATE FUNCTION SaldoContaFinanceira (argContaFinanceiraId INT)
  RETURNS DECIMAL
  DETERMINISTIC
BEGIN
  DECLARE vSaldo DECIMAL;
  
  SELECT 
    Saldo AS Saldo
  INTO
    vSaldo
  FROM
    MovimentoContaFinanceira
  WHERE
    ContaFinanceiraId = argContaFinanceiraId
  ORDER BY
    DataHora DESC
  LIMIT 1;

  RETURN vSaldo;

END //
delimiter ;
