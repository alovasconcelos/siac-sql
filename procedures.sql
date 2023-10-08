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


DELIMITER //

CREATE VIEW vMovimentoCaixa AS
SELECT
    m.DataHora,
    m.UsuarioId,
    m.Tipo,
    m.SaldoAnterior,
    m.Valor,
    m.Saldo,
    CASE 
		WHEN VendaPagamentoId IS NULL THEN FALSE
        ELSE TRUE
    END AS Venda,
    vp.FormaPagamentoId,
    CASE
		WHEN fp.Descricao IS NOT NULL THEN CONCAT('Venda em ', fp.Descricao)
        ELSE 
        CASE
			WHEN tipo = 'E' THEN 'Entrada'
            ELSE 'Sangria'
        END 
	END AS Descricao
FROM
	MovimentoCaixa m
    LEFT JOIN VendaPagamento vp ON m.VendaPagamentoId = vp.Id
    LEFT JOIN FormaPagamento fp ON vp.FormaPagamentoId = fp.Id
ORDER BY
	m.DataHora;

CREATE PROCEDURE Caixa (IN usuarioId INT, IN tipo VARCHAR(1), IN valor DECIMAL(12,2), IN vendaPagamentoId INT)
  BEGIN

    DECLARE saldoAnterior DECIMAL(12, 2);
    DECLARE saldoAtual DECIMAL(12, 2);    

    SELECT COALESCE(MAX(saldo),0) INTO saldoAnterior FROM MovimentoCaixa WHERE UsuarioId = usuarioId; 

    IF tipo = 'E' THEN
	    -- Entrada
	    SET saldoAtual = saldoAnterior + valor;
    ELSE
	    -- Saída
	    SET saldoAtual = saldoAnterior - valor;
    END IF;

    INSERT INTO MovimentoCaixa 
	    (UsuarioId, Tipo, SaldoAnterior, Valor, Saldo, VendaPagamentoId) 
	    VALUES
	    (usuarioId, tipo, saldoAnterior, valor, saldoAtual, vendaPagamentoId);

    
  END//

DELIMITER ;
