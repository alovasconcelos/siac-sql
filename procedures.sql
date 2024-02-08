
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
    
    DECLARE done int default 0;

    DECLARE cursorVenda CURSOR FOR
      SELECT            
        COUNT(1) AS qtd,
	      COALESCE(Orcamento,1) AS orcamento
      FROM
        Venda 
      WHERE
        Id = argVendaFinalizadaId AND
        Status = 'A' AND
        PDV;

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

    OPEN cursorVenda;
    FETCH cursorVenda INTO vQtdVenda, vOrcamento;

    IF vQtdVenda > 0 THEN
      -- atualiza estoques dos itens
      OPEN cursorItens;
      cursorloop:loop
        IF done = true then  
          leave cursorloop;
        END IF;
        SET vConferido = 0;

        FETCH cursorItens INTO 
              vItemId,
              vQuantidade,
              vDisponivel,
              vConferidoAnterior,
              vPrecoCusto;

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

    END IF; 

  END//

delimiter ;


