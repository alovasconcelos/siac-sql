drop procedure CancelarVendaPDV;
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

drop procedure CancelarDetalheVendaPDV;
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

