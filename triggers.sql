delimiter //
CREATE TRIGGER before_update_VendaDetalhe 
    BEFORE UPDATE ON VendaDetalhe
    FOR EACH ROW 
    BEGIN
        IF OLD.Subtotal <> NEW.Subtotal THEN
            UPDATE Venda v SET v.Subtotal = v.Subtotal - OLD.Subtotal + NEW.Subtotal WHERE Id = OLD.VendaId;
        END IF;

        IF NOT OLD.Cancelado AND NEW.Cancelado THEN
            -- detalhe sendo cancelado - retirar reserva do item e abater subtotal
            UPDATE Item SET Reservado = Reservado - OLD.Quantidade WHERE Id = OLD.ItemId AND ControlaEstoque;
            UPDATE Venda v SET v.Subtotal = v.Subtotal - OLD.Subtotal WHERE Id = OLD.VendaId;
        ELSE
            -- atualizar reserva apenas se a quantidade foi alterada
            IF OLD.Quantidade <> NEW.Quantidade OR OLD.ItemId <> NEW.ItemId THEN
                UPDATE Item SET Reservado = Reservado - OLD.Quantidade WHERE Id = OLD.ItemId AND ControlaEstoque;
                UPDATE Item SET Reservado = Reservado + NEW.Quantidade WHERE Id = NEW.ItemId AND ControlaEstoque;
            END IF;
        END IF;

    END //
delimiter ;

delimiter //
CREATE TRIGGER before_insert_VendaDetalhe 
    BEFORE INSERT ON VendaDetalhe
    FOR EACH ROW 
    BEGIN
        UPDATE Venda v SET v.Subtotal = v.Subtotal + NEW.Subtotal WHERE Id = NEW.VendaId;
        UPDATE Item SET Reservado = Reservado + NEW.Quantidade WHERE Id = NEW.ItemId AND ControlaEstoque;
    END //
delimiter ;

delimiter //
CREATE TRIGGER before_delete_VendaDetalhe 
    BEFORE DELETE ON VendaDetalhe
    FOR EACH ROW 
    BEGIN 
        UPDATE Venda v SET v.Subtotal = v.Subtotal - OLD.Subtotal WHERE Id = OLD.VendaId;
        UPDATE Item SET Reservado = Reservado - OLD.Quantidade WHERE Id = OLD.ItemId AND ControlaEstoque;
    END //
delimiter ;

delimiter //
CREATE TRIGGER before_update_Item BEFORE UPDATE
ON Item
FOR EACH ROW
    IF OLD.PrecoVenda <> NEW.PrecoVenda THEN
        INSERT INTO ReajustePrecos (ItemId, PrecoAnterior, PrecoNovo) VALUES (OLD.Id, OLD.PrecoVenda, NEW.PrecoVenda);
    END IF; //
delimiter ;

delimiter //
CREATE TRIGGER before_update_Venda BEFORE UPDATE
ON Venda
FOR EACH ROW
    IF OLD.Subtotal <> NEW.Subtotal OR OLD.Desconto <> NEW.Desconto OR OLD.Pago <> NEW.PAGO THEN
        SET NEW.Falta = 0;
        SET NEW.Troco = 0;
        SET NEW.APagar = NEW.Subtotal - NEW.Desconto;
        IF NEW.Pago < NEW.APagar THEN
            SET NEW.Falta = NEW.APagar - NEW.Pago;
        ELSEIF NEW.Pago > NEW.APagar THEN
            SET NEW.Troco = NEW.Pago - NEW.APagar;
        END IF;
    END IF; //
delimiter ;

delimiter //
CREATE TRIGGER after_insert_VendaPagamento AFTER INSERT
ON VendaPagamento
FOR EACH ROW
    BEGIN
        UPDATE Venda SET Pago = Pago + NEW.ValorPago WHERE Id = NEW.VendaId;
    END //
    
delimiter ;

delimiter //
CREATE TRIGGER after_delete_VendaPagamento AFTER DELETE
ON VendaPagamento
FOR EACH ROW
    BEGIN
        UPDATE Venda SET Pago = Pago - OLD.ValorPago WHERE Id = OLD.VendaId;
    END //
    
delimiter ;

delimiter //
CREATE TRIGGER before_delete_MovimentoCaixa BEFORE DELETE
ON MovimentoCaixa
FOR EACH ROW
    BEGIN
      SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Exclusão não permitida na tabela MovimentoCaixa.';
    END //
delimiter ;

delimiter //
CREATE TRIGGER before_update_MovimentoCaixa BEFORE UPDATE
ON MovimentoCaixa
FOR EACH ROW
    BEGIN
      SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Alteração não permitida na tabela MovimentoCaixa.';
    END //
delimiter ;

delimiter //
CREATE TRIGGER before_delete_MovimentoContaFinanceira BEFORE DELETE
ON MovimentoContaFinanceira
FOR EACH ROW
    BEGIN
      SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Exclusão não permitida na tabela MovimentoContaFinanceira.';
    END //
delimiter ;

delimiter //
CREATE TRIGGER before_update_MovimentoContaFinanceira BEFORE UPDATE
ON MovimentoContaFinanceira
FOR EACH ROW
    BEGIN
      SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Alteração não permitida na tabela MovimentoContaFinanceira.';
    END //
delimiter ;

