-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema qualia
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema qualia
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `qualia` DEFAULT CHARACTER SET utf8 ;
USE `qualia` ;

-- -----------------------------------------------------
-- Table `qualia`.`Estado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Estado` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Sigla` VARCHAR(2) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `CodigoIBGE` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `Sigla_UNIQUE` (`Sigla` ASC),
  UNIQUE INDEX `CodigoIBGE_UNIQUE` (`CodigoIBGE` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Cidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Cidade` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `EstadoId` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `CodigoIBGE` VARCHAR(7) NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `CodigoIBGE_UNIQUE` (`CodigoIBGE` ASC),
  INDEX `fk_Cidade_Estado_idx` (`EstadoId` ASC),
  CONSTRAINT `fk_Cidade_Estado`
    FOREIGN KEY (`EstadoId`)
    REFERENCES `qualia`.`Estado` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Bairro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Bairro` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `CidadeId` INT NOT NULL,
  `Nome` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `Id_UNIQUE` (`Id` ASC),
  INDEX `fk_Bairro_Cidade1_idx` (`CidadeId` ASC),
  CONSTRAINT `fk_Bairro_Cidade1`
    FOREIGN KEY (`CidadeId`)
    REFERENCES `qualia`.`Cidade` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Usuario` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Login` VARCHAR(16) NOT NULL,
  `Senha` VARCHAR(32) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Email` TEXT NULL,
  `Telefone` VARCHAR(20) NULL,
  `Ativo` TINYINT NOT NULL DEFAULT 1,
  `Adm` TINYINT NOT NULL DEFAULT 0,
  `MensagensFaladas` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `Login_UNIQUE` (`Login` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`UnidadeComercial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`UnidadeComercial` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Codigo` VARCHAR(6) NOT NULL,
  `Descricao` VARCHAR(30) NOT NULL,
  `FatorConversao` INT NOT NULL DEFAULT 1,
  `Pesagem` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `Codigo_UNIQUE` (`Codigo` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Categoria` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Tributo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Tributo` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(40) NOT NULL,
  `AliquotaICMSConsumidor` DECIMAL(5,2) NOT NULL DEFAULT 0,
  `AliquotaICMSContribuinte` DECIMAL(5,2) NOT NULL DEFAULT 0,
  `AliquotaICMSST` DECIMAL(5,2) NOT NULL DEFAULT 0,
  `CSTContribuinte` VARCHAR(2) NOT NULL,
  `CSTConsumidor` VARCHAR(2) NOT NULL,
  `CSTSubstituicaoTributaria` VARCHAR(2) NOT NULL,
  `CSOSNConsumidor` VARCHAR(3) NOT NULL,
  `CSOSNContribuinte` VARCHAR(3) NOT NULL,
  `OrigemMercadoria` VARCHAR(1) NOT NULL DEFAULT 0,
  `AliquotaPIS` DECIMAL(5,2) NOT NULL DEFAULT 0,
  `AliquotaCOFINS` DECIMAL(5,2) NOT NULL DEFAULT 0,
  `CSTPIS` VARCHAR(2) NOT NULL,
  `CSTCOFINS` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Cep`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Cep` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Codigo` VARCHAR(8) NOT NULL,
  `Logradouro` VARCHAR(60) NOT NULL,
  `Complemento` VARCHAR(40) NULL,
  `DDD` VARCHAR(2) NULL,
  `BairroId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `CEP_UNIQUE` (`Codigo` ASC),
  INDEX `fk_Cep_Bairro1_idx` (`BairroId` ASC),
  CONSTRAINT `fk_Cep_Bairro1`
    FOREIGN KEY (`BairroId`)
    REFERENCES `qualia`.`Bairro` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`DadosEmpresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`DadosEmpresa` (
  `Id` INT NOT NULL,
  `RazaoSocial` VARCHAR(60) NOT NULL,
  `CnpjCpf` VARCHAR(14) NULL,
  `InscricaoEstadual` VARCHAR(20) NULL,
  `RegimeTributario` VARCHAR(1) NOT NULL DEFAULT '1',
  `CepId` INT NOT NULL,
  `Complemento` VARCHAR(40) NULL,
  `Numero` VARCHAR(8) NULL,
  `Ativacao` VARCHAR(35) NULL,
  `ExpiraEm` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `APINFCe` TEXT NULL,
  `TokenAPINFCeHomolog` TEXT NULL,
  `TokenAPINFCeProd` TEXT NULL,
  `URLNFCeHomolog` TEXT NULL,
  `URLNFCeProd` TEXT NULL,
  `AmbienteNFCe` VARCHAR(1) NOT NULL DEFAULT 'H',
  `Logo` LONGTEXT NULL,
  `CategoriaPadraoId` INT NOT NULL DEFAULT 1,
  `TributoPadraoId` INT NOT NULL DEFAULT 1,
  `UnidadeComercialPadraoId` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`Id`),
  INDEX `fk_DadosEmpresa_Cep1_idx` (`CepId` ASC),
  UNIQUE INDEX `CnpjCpf_UNIQUE` (`CnpjCpf` ASC),
  INDEX `fk_DadosEmpresa_Categoria1_idx` (`CategoriaPadraoId` ASC),
  INDEX `fk_DadosEmpresa_Tributo1_idx` (`TributoPadraoId` ASC),
  INDEX `fk_DadosEmpresa_UnidadeComercial1_idx` (`UnidadeComercialPadraoId` ASC),
  CONSTRAINT `fk_DadosEmpresa_Cep1`
    FOREIGN KEY (`CepId`)
    REFERENCES `qualia`.`Cep` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DadosEmpresa_Categoria1`
    FOREIGN KEY (`CategoriaPadraoId`)
    REFERENCES `qualia`.`Categoria` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DadosEmpresa_Tributo1`
    FOREIGN KEY (`TributoPadraoId`)
    REFERENCES `qualia`.`Tributo` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DadosEmpresa_UnidadeComercial1`
    FOREIGN KEY (`UnidadeComercialPadraoId`)
    REFERENCES `qualia`.`UnidadeComercial` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ConfigBanco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ConfigBanco` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Servidor` TEXT NOT NULL,
  `Tipo` VARCHAR(1) NOT NULL DEFAULT 'M',
  `Banco` TEXT NOT NULL,
  `Porta` VARCHAR(4) NOT NULL,
  `Usuario` VARCHAR(45) NOT NULL,
  `Senha` TEXT NULL,
  `DadosEmpresaId` INT NOT NULL,
  `TabelaItem` VARCHAR(45) NOT NULL,
  `CampoCodigoBarras` VARCHAR(45) NOT NULL,
  `CampoDescricao` VARCHAR(45) NOT NULL,
  `CampoNCM` VARCHAR(45) NULL,
  `CampoCEST` VARCHAR(45) NULL,
  `CampoPreco` VARCHAR(45) NULL,
  `CampoCusto` VARCHAR(45) NULL,
  `CampoEstoque` VARCHAR(45) NULL,
  `CampoReservado` VARCHAR(45) NULL,
  `Ordem` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_ConfigBanco_DadosEmpresa1_idx` (`DadosEmpresaId` ASC),
  CONSTRAINT `fk_ConfigBanco_DadosEmpresa1`
    FOREIGN KEY (`DadosEmpresaId`)
    REFERENCES `qualia`.`DadosEmpresa` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Item` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(120) NOT NULL,
  `CodigoBarras` VARCHAR(14) NULL,
  `CodigoNCM` VARCHAR(8) NULL,
  `Disponivel` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `Imagem` LONGTEXT NULL,
  `Ativo` TINYINT NOT NULL DEFAULT 1,
  `UnidadeComercialId` INT NOT NULL,
  `CodigoCest` VARCHAR(7) NULL,
  `CategoriaId` INT NULL,
  `PrecoCusto` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `PrecoVenda` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Reservado` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `ControlaEstoque` TINYINT NOT NULL DEFAULT 1,
  `TributoId` INT NOT NULL,
  `ProducaoPropria` TINYINT NOT NULL DEFAULT 0,
  `Combustivel` TINYINT NOT NULL DEFAULT 0,
  `EstoqueMinimo` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `ConfigBancoId` INT NULL,
  `Conferido` DECIMAL(11,4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `CodigoDeBarras_UNIQUE` (`CodigoBarras` ASC),
  INDEX `fk_Item_UnidadeComercial1_idx` (`UnidadeComercialId` ASC),
  INDEX `fk_Item_Categoria1_idx` (`CategoriaId` ASC),
  INDEX `fk_Item_Tributo1_idx` (`TributoId` ASC),
  INDEX `fk_Item_ConfigBanco1_idx` (`ConfigBancoId` ASC),
  CONSTRAINT `fk_Item_UnidadeComercial1`
    FOREIGN KEY (`UnidadeComercialId`)
    REFERENCES `qualia`.`UnidadeComercial` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Item_Categoria1`
    FOREIGN KEY (`CategoriaId`)
    REFERENCES `qualia`.`Categoria` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Item_Tributo1`
    FOREIGN KEY (`TributoId`)
    REFERENCES `qualia`.`Tributo` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Item_ConfigBanco1`
    FOREIGN KEY (`ConfigBancoId`)
    REFERENCES `qualia`.`ConfigBanco` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Cliente` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(50) NOT NULL,
  `CepId` INT NOT NULL,
  `Complemento` VARCHAR(40) NULL,
  `Numero` VARCHAR(8) NULL,
  `Email` TEXT NULL,
  `Telefone` VARCHAR(20) NULL,
  `CnpjCpf` VARCHAR(14) NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Cliente_Cep1_idx` (`CepId` ASC),
  CONSTRAINT `fk_Cliente_Cep1`
    FOREIGN KEY (`CepId`)
    REFERENCES `qualia`.`Cep` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Venda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Venda` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataVenda` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UsuarioId` INT NOT NULL,
  `Status` VARCHAR(1) NOT NULL DEFAULT 'A',
  `DadosEmpresaId` INT NOT NULL,
  `ClienteId` INT NULL,
  `DataHoraCancelamento` DATETIME NULL,
  `PDV` TINYINT NOT NULL DEFAULT 1,
  `Subtotal` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `UsuarioCancelamentoId` INT NULL,
  `Desconto` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `APagar` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Pago` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Falta` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Troco` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `UsuarioDescontoId` INT NULL,
  `UsuarioAprovacaoId` INT NULL,
  `Orcamento` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`Id`),
  INDEX `fk_Venda_Usuario1_idx` (`UsuarioId` ASC),
  INDEX `fk_Venda_DadosEmpresa1_idx` (`DadosEmpresaId` ASC),
  INDEX `fk_Venda_Cliente1_idx` (`ClienteId` ASC),
  INDEX `fk_Venda_Usuario2_idx` (`UsuarioCancelamentoId` ASC),
  INDEX `fk_Venda_Usuario3_idx` (`UsuarioDescontoId` ASC),
  INDEX `fk_Venda_Usuario4_idx` (`UsuarioAprovacaoId` ASC),
  CONSTRAINT `fk_Venda_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Venda_DadosEmpresa1`
    FOREIGN KEY (`DadosEmpresaId`)
    REFERENCES `qualia`.`DadosEmpresa` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Venda_Cliente1`
    FOREIGN KEY (`ClienteId`)
    REFERENCES `qualia`.`Cliente` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Venda_Usuario2`
    FOREIGN KEY (`UsuarioCancelamentoId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Venda_Usuario3`
    FOREIGN KEY (`UsuarioDescontoId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Venda_Usuario4`
    FOREIGN KEY (`UsuarioAprovacaoId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`VendaDetalhe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`VendaDetalhe` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `VendaId` INT NOT NULL,
  `Ordem` INT NOT NULL,
  `Quantidade` DECIMAL(11,4) NOT NULL DEFAULT 1,
  `PrecoUnitario` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Desconto` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Subtotal` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `ValorFrete` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `ItemId` INT NOT NULL,
  `Cancelado` TINYINT NOT NULL DEFAULT 0,
  `DataHoraCancelamento` DATETIME NULL,
  `UsuarioCancelamentoId` INT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_VendaDetalhe_Venda1_idx` (`VendaId` ASC),
  INDEX `fk_VendaDetalhe_Item1_idx` (`ItemId` ASC),
  UNIQUE INDEX `uk_VendaDetalhe_Ordem_idx` (`VendaId` ASC, `Ordem` ASC),
  INDEX `fk_VendaDetalhe_Usuario1_idx` (`UsuarioCancelamentoId` ASC),
  CONSTRAINT `fk_VendaDetalhe_Venda1`
    FOREIGN KEY (`VendaId`)
    REFERENCES `qualia`.`Venda` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VendaDetalhe_Item1`
    FOREIGN KEY (`ItemId`)
    REFERENCES `qualia`.`Item` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VendaDetalhe_Usuario1`
    FOREIGN KEY (`UsuarioCancelamentoId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`DadosNFCe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`DadosNFCe` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `VendaId` INT NOT NULL,
  `NaturezaOperacao` VARCHAR(45) NOT NULL DEFAULT 'VENDA AO CONSUMIDOR',
  `DataEmissao` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `PresencaComprador` VARCHAR(1) NOT NULL DEFAULT '1',
  `ModalidadeFrete` VARCHAR(1) NOT NULL DEFAULT '9',
  `LocalDestino` VARCHAR(1) NOT NULL DEFAULT '1',
  `Cpf` VARCHAR(11) NULL,
  `Numero` VARCHAR(9) NULL,
  `Serie` VARCHAR(3) NULL,
  `RefNota` TEXT NULL,
  `Status` VARCHAR(45) NULL,
  `StatusSefaz` VARCHAR(45) NULL,
  `MensagemSefaz` TEXT NULL,
  `ChaveNFCe` TEXT NULL,
  `Protocolo` TEXT NULL,
  `XML` TEXT NULL,
  `CaminhoXMLNotaFiscal` TEXT NULL,
  `CaminhoDANFe` TEXT NULL,
  `QrCodeURL` TEXT NULL,
  `URLConsultaNF` TEXT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_DadosNFCe_Venda1_idx` (`VendaId` ASC),
  CONSTRAINT `fk_DadosNFCe_Venda1`
    FOREIGN KEY (`VendaId`)
    REFERENCES `qualia`.`Venda` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`DadosDetalheNFCe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`DadosDetalheNFCe` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `VendaDetalheId` INT NOT NULL,
  `OrigemICMS` VARCHAR(1) NOT NULL DEFAULT 0,
  `SituacaoTributariaICMS` VARCHAR(3) NOT NULL,
  `AliquotaICMS` DECIMAL(4,2) NOT NULL DEFAULT 0,
  `BaseCalculoICMS` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `ModalidadeBaseCalculoICMS` VARCHAR(1) NOT NULL DEFAULT '3',
  `CFOP` VARCHAR(4) NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_DadosDetalheNFCe_VendaDetalhe1_idx` (`VendaDetalheId` ASC),
  CONSTRAINT `fk_DadosDetalheNFCe_VendaDetalhe1`
    FOREIGN KEY (`VendaDetalheId`)
    REFERENCES `qualia`.`VendaDetalhe` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ContaFinanceira`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ContaFinanceira` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`FormaPagamentoNFe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`FormaPagamentoNFe` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Codigo` VARCHAR(2) NOT NULL,
  `Descricao` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `Codigo_UNIQUE` (`Codigo` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`FormaPagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`FormaPagamento` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(50) NOT NULL,
  `Orcamento` TINYINT NOT NULL DEFAULT 1,
  `DisponivelEm` INT NOT NULL DEFAULT 0,
  `ContaFinanceiraId` INT NOT NULL,
  `TipoAcrescimo` VARCHAR(1) NOT NULL DEFAULT 'P',
  `TipoDesconto` VARCHAR(1) NOT NULL DEFAULT 'P',
  `Acrescimo` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Desconto` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Parcelas` INT NOT NULL DEFAULT 1,
  `DiasEntreParcelas` INT NOT NULL DEFAULT 0,
  `FormaPagamentoNFeId` INT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_FormaPagamento_ContaFinanceira1_idx` (`ContaFinanceiraId` ASC),
  INDEX `fk_FormaPagamento_FormaPagamentoNFe1_idx` (`FormaPagamentoNFeId` ASC),
  CONSTRAINT `fk_FormaPagamento_ContaFinanceira1`
    FOREIGN KEY (`ContaFinanceiraId`)
    REFERENCES `qualia`.`ContaFinanceira` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FormaPagamento_FormaPagamentoNFe1`
    FOREIGN KEY (`FormaPagamentoNFeId`)
    REFERENCES `qualia`.`FormaPagamentoNFe` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`VendaPagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`VendaPagamento` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `FormaPagamentoId` INT NOT NULL,
  `ValorPago` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `VendaId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_VendaPagamento_FormaPagamento1_idx` (`FormaPagamentoId` ASC),
  INDEX `fk_VendaPagamento_Venda1_idx` (`VendaId` ASC),
  CONSTRAINT `fk_VendaPagamento_FormaPagamento1`
    FOREIGN KEY (`FormaPagamentoId`)
    REFERENCES `qualia`.`FormaPagamento` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VendaPagamento_Venda1`
    FOREIGN KEY (`VendaId`)
    REFERENCES `qualia`.`Venda` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`MovimentoCaixa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`MovimentoCaixa` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataCaixa` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `UsuarioId` INT NOT NULL,
  `SaldoAnterior` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Suprimento` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Sangria` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Recebido` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Troco` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Saldo` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Aberto` TINYINT NOT NULL DEFAULT 1,
  `Obs` VARCHAR(45) NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_MovimentoCaixa_Usuario1_idx` (`UsuarioId` ASC),
  CONSTRAINT `fk_MovimentoCaixa_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`MovimentoItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`MovimentoItem` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataHora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ItemId` INT NOT NULL,
  `SaldoAnterior` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `Quantidade` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `Saldo` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `Tipo` VARCHAR(1) NOT NULL,
  `CustoAnterior` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `NovoCusto` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `ConferidoAnterior` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `SaldoConferido` DECIMAL(11,4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  INDEX `fk_MovimentoItem_Item1_idx` (`ItemId` ASC),
  CONSTRAINT `fk_MovimentoItem_Item1`
    FOREIGN KEY (`ItemId`)
    REFERENCES `qualia`.`Item` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Fornecedor` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `CnpjCpf` VARCHAR(14) NULL,
  `Nome` VARCHAR(80) NOT NULL,
  `CepId` INT NOT NULL,
  `Complemento` VARCHAR(40) NULL,
  `Numero` VARCHAR(8) NULL,
  `Email` TEXT NULL,
  `Telefone` VARCHAR(20) NULL,
  `InscricaoEstadual` VARCHAR(14) NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Fornecedor_Cep1_idx` (`CepId` ASC),
  CONSTRAINT `fk_Fornecedor_Cep1`
    FOREIGN KEY (`CepId`)
    REFERENCES `qualia`.`Cep` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ContaCorrenteCliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ContaCorrenteCliente` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataHora` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `ClienteId` INT NOT NULL,
  `UsuarioId` INT NOT NULL,
  `Tipo` VARCHAR(1) NOT NULL,
  `Valor` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Vencimento` DATE NOT NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (`Id`),
  INDEX `fk_ContaCorrenteCliente_Cliente1_idx` (`ClienteId` ASC),
  INDEX `fk_ContaCorrenteCliente_Usuario1_idx` (`UsuarioId` ASC),
  CONSTRAINT `fk_ContaCorrenteCliente_Cliente1`
    FOREIGN KEY (`ClienteId`)
    REFERENCES `qualia`.`Cliente` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContaCorrenteCliente_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Entrada`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Entrada` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataHoraDocumento` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `FornecedorId` INT NOT NULL,
  `ChaveNFe` VARCHAR(44) NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Entrada_Fornecedor1_idx` (`FornecedorId` ASC),
  UNIQUE INDEX `ChaveNFe_UNIQUE` (`ChaveNFe` ASC),
  CONSTRAINT `fk_Entrada_Fornecedor1`
    FOREIGN KEY (`FornecedorId`)
    REFERENCES `qualia`.`Fornecedor` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`EntradaItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`EntradaItem` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `EntradaId` INT NOT NULL,
  `ItemId` INT NOT NULL,
  `Custo` DECIMAL(14,4) NOT NULL DEFAULT 0,
  `Quantidade` DECIMAL(11,4) NOT NULL,
  `Subtotal` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_EntradaItem_Entrada1_idx` (`EntradaId` ASC),
  INDEX `fk_EntradaItem_Item1_idx` (`ItemId` ASC),
  CONSTRAINT `fk_EntradaItem_Entrada1`
    FOREIGN KEY (`EntradaId`)
    REFERENCES `qualia`.`Entrada` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EntradaItem_Item1`
    FOREIGN KEY (`ItemId`)
    REFERENCES `qualia`.`Item` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ReajustePrecos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ReajustePrecos` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataHora` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `ItemId` INT NOT NULL,
  `PrecoAnterior` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `PrecoNovo` DECIMAL(12,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  INDEX `fk_ReajustePrecos_Item1_idx` (`ItemId` ASC),
  CONSTRAINT `fk_ReajustePrecos_Item1`
    FOREIGN KEY (`ItemId`)
    REFERENCES `qualia`.`Item` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ContasAPagar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ContasAPagar` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Data` DATE NOT NULL,
  `UsuarioId` INT NOT NULL,
  `ValorAPagar` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Parcelas` INT NOT NULL DEFAULT 1,
  `DiasEntreParcelas` INT NOT NULL DEFAULT 1,
  `DataPrimeiraParcela` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `EntradaId` INT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_ContasAPagar_Usuario1_idx` (`UsuarioId` ASC),
  INDEX `fk_ContasAPagar_Entrada1_idx` (`EntradaId` ASC),
  CONSTRAINT `fk_ContasAPagar_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContasAPagar_Entrada1`
    FOREIGN KEY (`EntradaId`)
    REFERENCES `qualia`.`Entrada` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ParcelaContasAPagar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ParcelaContasAPagar` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `ContasAPagarId` INT NOT NULL,
  `Data` DATE NOT NULL,
  `ValorAPagar` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `ValorPago` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Situacao` VARCHAR(1) NOT NULL DEFAULT 0,
  `NumeroParcela` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_ParcelaContasAPagar_ContasAPagar1_idx` (`ContasAPagarId` ASC),
  CONSTRAINT `fk_ParcelaContasAPagar_ContasAPagar1`
    FOREIGN KEY (`ContasAPagarId`)
    REFERENCES `qualia`.`ContasAPagar` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Composicao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Composicao` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `ItemId` INT NOT NULL,
  `PrecoVenda` DECIMAL(12,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  INDEX `fk_Composicao_Item1_idx` (`ItemId` ASC),
  CONSTRAINT `fk_Composicao_Item1`
    FOREIGN KEY (`ItemId`)
    REFERENCES `qualia`.`Item` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ComposicaoDetalhe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ComposicaoDetalhe` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `ComposicaoId` INT NOT NULL,
  `ItemId` INT NOT NULL,
  `Quantidade` DECIMAL(11,4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  INDEX `fk_ComposicaoDetalhe_Composicao1_idx` (`ComposicaoId` ASC),
  INDEX `fk_ComposicaoDetalhe_Item1_idx` (`ItemId` ASC),
  CONSTRAINT `fk_ComposicaoDetalhe_Composicao1`
    FOREIGN KEY (`ComposicaoId`)
    REFERENCES `qualia`.`Composicao` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ComposicaoDetalhe_Item1`
    FOREIGN KEY (`ItemId`)
    REFERENCES `qualia`.`Item` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Cardapio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Cardapio` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(45) NOT NULL,
  `Ativo` TINYINT NOT NULL DEFAULT 1,
  `DadosEmpresaId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Cardapio_DadosEmpresa1_idx` (`DadosEmpresaId` ASC),
  CONSTRAINT `fk_Cardapio_DadosEmpresa1`
    FOREIGN KEY (`DadosEmpresaId`)
    REFERENCES `qualia`.`DadosEmpresa` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`LocalComanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`LocalComanda` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `DadosEmpresaId` INT NOT NULL,
  `Impressora` TEXT NULL,
  `Imprime` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  INDEX `fk_LocalComanda_DadosEmpresa1_idx` (`DadosEmpresaId` ASC),
  CONSTRAINT `fk_LocalComanda_DadosEmpresa1`
    FOREIGN KEY (`DadosEmpresaId`)
    REFERENCES `qualia`.`DadosEmpresa` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`CardapioDetalhe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`CardapioDetalhe` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `CardapioId` INT NOT NULL,
  `ItemId` INT NOT NULL,
  `Observacoes` TEXT NULL,
  `LocalComandaId` INT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_CardapioDetalhe_Item1_idx` (`ItemId` ASC),
  INDEX `fk_CardapioDetalhe_Cardapio1_idx` (`CardapioId` ASC),
  INDEX `fk_CardapioDetalhe_LocalComanda1_idx` (`LocalComandaId` ASC),
  CONSTRAINT `fk_CardapioDetalhe_Item1`
    FOREIGN KEY (`ItemId`)
    REFERENCES `qualia`.`Item` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CardapioDetalhe_Cardapio1`
    FOREIGN KEY (`CardapioId`)
    REFERENCES `qualia`.`Cardapio` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CardapioDetalhe_LocalComanda1`
    FOREIGN KEY (`LocalComandaId`)
    REFERENCES `qualia`.`LocalComanda` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Garcom`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Garcom` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NULL,
  `CepId` INT NULL,
  `Logradouro` VARCHAR(45) NULL,
  `Numero` VARCHAR(8) NULL,
  `UsuarioId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Garcom_Cep1_idx` (`CepId` ASC),
  INDEX `fk_Garcom_Usuario1_idx` (`UsuarioId` ASC),
  CONSTRAINT `fk_Garcom_Cep1`
    FOREIGN KEY (`CepId`)
    REFERENCES `qualia`.`Cep` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Garcom_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Comanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Comanda` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataHora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Situacao` INT NOT NULL DEFAULT 0,
  `GarcomAberturaId` INT NOT NULL,
  `GarcomFechamentoId` INT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Comanda_Garcom1_idx` (`GarcomAberturaId` ASC),
  INDEX `fk_Comanda_Garcom2_idx` (`GarcomFechamentoId` ASC),
  CONSTRAINT `fk_Comanda_Garcom1`
    FOREIGN KEY (`GarcomAberturaId`)
    REFERENCES `qualia`.`Garcom` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comanda_Garcom2`
    FOREIGN KEY (`GarcomFechamentoId`)
    REFERENCES `qualia`.`Garcom` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ComandaDetalhe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ComandaDetalhe` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataHora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `GarcomPedidoId` INT NOT NULL,
  `GarcomEntregaId` INT NULL,
  `Situacao` INT NOT NULL DEFAULT 0,
  `Quantidade` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `PrecoUnitario` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Subtotal` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `CardapioDetalheId` INT NOT NULL,
  `ComandaId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_ComandaDetalhe_Garcom1_idx` (`GarcomPedidoId` ASC),
  INDEX `fk_ComandaDetalhe_Garcom2_idx` (`GarcomEntregaId` ASC),
  INDEX `fk_ComandaDetalhe_CardapioDetalhe1_idx` (`CardapioDetalheId` ASC),
  INDEX `fk_ComandaDetalhe_Comanda1_idx` (`ComandaId` ASC),
  CONSTRAINT `fk_ComandaDetalhe_Garcom1`
    FOREIGN KEY (`GarcomPedidoId`)
    REFERENCES `qualia`.`Garcom` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ComandaDetalhe_Garcom2`
    FOREIGN KEY (`GarcomEntregaId`)
    REFERENCES `qualia`.`Garcom` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ComandaDetalhe_CardapioDetalhe1`
    FOREIGN KEY (`CardapioDetalheId`)
    REFERENCES `qualia`.`CardapioDetalhe` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ComandaDetalhe_Comanda1`
    FOREIGN KEY (`ComandaId`)
    REFERENCES `qualia`.`Comanda` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`MensagemUsuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`MensagemUsuario` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataHora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Mensagem` TEXT NOT NULL,
  `UsuarioId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_MensagemUsuario_Usuario1_idx` (`UsuarioId` ASC),
  CONSTRAINT `fk_MensagemUsuario_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Suprimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Suprimento` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataHora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Valor` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `MovimentoCaixaId` INT NOT NULL,
  `Obs` VARCHAR(45) NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Suprimento_MovimentoCaixa1_idx` (`MovimentoCaixaId` ASC),
  CONSTRAINT `fk_Suprimento_MovimentoCaixa1`
    FOREIGN KEY (`MovimentoCaixaId`)
    REFERENCES `qualia`.`MovimentoCaixa` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Sangria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Sangria` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataHora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Valor` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `MovimentoCaixaId` INT NOT NULL,
  `Obs` VARCHAR(45) NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Sangria_MovimentoCaixa1_idx` (`MovimentoCaixaId` ASC),
  CONSTRAINT `fk_Sangria_MovimentoCaixa1`
    FOREIGN KEY (`MovimentoCaixaId`)
    REFERENCES `qualia`.`MovimentoCaixa` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`Inventario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`Inventario` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `ItemId` INT NOT NULL,
  `Mes` INT NOT NULL,
  `Ano` INT NOT NULL,
  `Anterior` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `Entrada` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `Saida` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `Saldo` DECIMAL(11,4) NOT NULL DEFAULT 0,
  `UnidadeComercialId` INT NOT NULL,
  `ValorUnitario` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `ValorTotal` DECIMAL(12,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  INDEX `fk_Inventario_Item1_idx` (`ItemId` ASC),
  INDEX `fk_Inventario_UnidadeComercial1_idx` (`UnidadeComercialId` ASC),
  CONSTRAINT `fk_Inventario_Item1`
    FOREIGN KEY (`ItemId`)
    REFERENCES `qualia`.`Item` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Inventario_UnidadeComercial1`
    FOREIGN KEY (`UnidadeComercialId`)
    REFERENCES `qualia`.`UnidadeComercial` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`CalendarioUsuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`CalendarioUsuario` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `UsuarioId` INT NOT NULL,
  `Data` DATE NOT NULL,
  `Titulo` VARCHAR(45) NOT NULL,
  `Texto` TEXT NULL,
  `Ativo` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`Id`),
  INDEX `fk_CalendarioUsuario_Usuario1_idx` (`UsuarioId` ASC),
  CONSTRAINT `fk_CalendarioUsuario_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`PagamentoContasAPagar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`PagamentoContasAPagar` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Data` DATE NOT NULL,
  `FormaPagamentoId` INT NOT NULL,
  `Valor` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `ParcelaContasAPagarId` INT NOT NULL,
  `UsuarioId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_PagamentoContasAPagar_FormaPagamento1_idx` (`FormaPagamentoId` ASC),
  INDEX `fk_PagamentoContasAPagar_ParcelaContasAPagar1_idx` (`ParcelaContasAPagarId` ASC),
  INDEX `fk_PagamentoContasAPagar_Usuario1_idx` (`UsuarioId` ASC),
  CONSTRAINT `fk_PagamentoContasAPagar_FormaPagamento1`
    FOREIGN KEY (`FormaPagamentoId`)
    REFERENCES `qualia`.`FormaPagamento` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PagamentoContasAPagar_ParcelaContasAPagar1`
    FOREIGN KEY (`ParcelaContasAPagarId`)
    REFERENCES `qualia`.`ParcelaContasAPagar` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PagamentoContasAPagar_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ContasAReceber`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ContasAReceber` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `UsuarioId` INT NOT NULL,
  `DataCadastro` DATE NOT NULL,
  `ValorAReceber` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Parcelas` INT NOT NULL DEFAULT 1,
  `DiasEntreParcelas` INT NOT NULL,
  `DataPrimeiraParcela` DATE NULL,
  `VendaPagamentoId` INT NULL,
  `Obs` VARCHAR(255) NULL,
  `ClienteId` INT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_ContasAReceber_Usuario1_idx` (`UsuarioId` ASC),
  INDEX `fk_ContasAReceber_VendaPagamento1_idx` (`VendaPagamentoId` ASC),
  INDEX `fk_ContasAReceber_Cliente1_idx` (`ClienteId` ASC),
  CONSTRAINT `fk_ContasAReceber_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContasAReceber_VendaPagamento1`
    FOREIGN KEY (`VendaPagamentoId`)
    REFERENCES `qualia`.`VendaPagamento` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContasAReceber_Cliente1`
    FOREIGN KEY (`ClienteId`)
    REFERENCES `qualia`.`Cliente` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ParcelaContasAReceber`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ParcelaContasAReceber` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Vencimento` DATE NOT NULL,
  `ValorAReceber` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `ValorRecebido` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Situacao` VARCHAR(1) NOT NULL DEFAULT 0,
  `ContasAReceberId` INT NOT NULL,
  `NumeroParcela` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_PacelaContasAReceber_ContasAReceber1_idx` (`ContasAReceberId` ASC),
  CONSTRAINT `fk_PacelaContasAReceber_ContasAReceber1`
    FOREIGN KEY (`ContasAReceberId`)
    REFERENCES `qualia`.`ContasAReceber` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`PagamentoContasAReceber`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`PagamentoContasAReceber` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Data` DATE NOT NULL,
  `FormaPagamentoId` INT NOT NULL,
  `Valor` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `UsuarioId` INT NOT NULL,
  `PacelaContasAReceberId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_PagamentoContasAReceber_FormaPagamento1_idx` (`FormaPagamentoId` ASC),
  INDEX `fk_PagamentoContasAReceber_Usuario1_idx` (`UsuarioId` ASC),
  INDEX `fk_PagamentoContasAReceber_PacelaContasAReceber1_idx` (`PacelaContasAReceberId` ASC),
  CONSTRAINT `fk_PagamentoContasAReceber_FormaPagamento1`
    FOREIGN KEY (`FormaPagamentoId`)
    REFERENCES `qualia`.`FormaPagamento` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PagamentoContasAReceber_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PagamentoContasAReceber_PacelaContasAReceber1`
    FOREIGN KEY (`PacelaContasAReceberId`)
    REFERENCES `qualia`.`ParcelaContasAReceber` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ReajustePrecosLote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ReajustePrecosLote` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DataHora` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`ReajustePrecosLoteDetalhe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`ReajustePrecosLoteDetalhe` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `ReajustePrecosLoteId` INT NOT NULL,
  `ReajustePrecosId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_ReajustePrecosLoteDetalhe_ReajustePrecosLote1_idx` (`ReajustePrecosLoteId` ASC),
  INDEX `fk_ReajustePrecosLoteDetalhe_ReajustePrecos1_idx` (`ReajustePrecosId` ASC),
  CONSTRAINT `fk_ReajustePrecosLoteDetalhe_ReajustePrecosLote1`
    FOREIGN KEY (`ReajustePrecosLoteId`)
    REFERENCES `qualia`.`ReajustePrecosLote` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ReajustePrecosLoteDetalhe_ReajustePrecos1`
    FOREIGN KEY (`ReajustePrecosId`)
    REFERENCES `qualia`.`ReajustePrecos` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`OrcamentoCompra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`OrcamentoCompra` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Data` DATE NOT NULL,
  `UsuarioId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_OrcamentoCompra_Usuario1_idx` (`UsuarioId` ASC),
  CONSTRAINT `fk_OrcamentoCompra_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`OrcamentoCompraDetalhe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`OrcamentoCompraDetalhe` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `OrcamentoCompraId` INT NOT NULL,
  `ItemId` INT NOT NULL,
  `UnidadeComercialId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_OrcamentoCompraDetalhe_OrcamentoCompra1_idx` (`OrcamentoCompraId` ASC),
  INDEX `fk_OrcamentoCompraDetalhe_Item1_idx` (`ItemId` ASC),
  INDEX `fk_OrcamentoCompraDetalhe_UnidadeComercial1_idx` (`UnidadeComercialId` ASC),
  CONSTRAINT `fk_OrcamentoCompraDetalhe_OrcamentoCompra1`
    FOREIGN KEY (`OrcamentoCompraId`)
    REFERENCES `qualia`.`OrcamentoCompra` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OrcamentoCompraDetalhe_Item1`
    FOREIGN KEY (`ItemId`)
    REFERENCES `qualia`.`Item` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OrcamentoCompraDetalhe_UnidadeComercial1`
    FOREIGN KEY (`UnidadeComercialId`)
    REFERENCES `qualia`.`UnidadeComercial` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`OrcamentoCompraDetalhePreco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`OrcamentoCompraDetalhePreco` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `OrcamentoCompraDetalheId` INT NOT NULL,
  `FornecedorId` INT NOT NULL,
  `Preco` DECIMAL(12,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`, `Preco`),
  INDEX `fk_OrcamentoCompraDetalhePreco_OrcamentoCompraDetalhe1_idx` (`OrcamentoCompraDetalheId` ASC),
  INDEX `fk_OrcamentoCompraDetalhePreco_Fornecedor1_idx` (`FornecedorId` ASC),
  CONSTRAINT `fk_OrcamentoCompraDetalhePreco_OrcamentoCompraDetalhe1`
    FOREIGN KEY (`OrcamentoCompraDetalheId`)
    REFERENCES `qualia`.`OrcamentoCompraDetalhe` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OrcamentoCompraDetalhePreco_Fornecedor1`
    FOREIGN KEY (`FornecedorId`)
    REFERENCES `qualia`.`Fornecedor` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qualia`.`MovimentoContaFinanceira`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `qualia`.`MovimentoContaFinanceira` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `ContaFinanceiraId` INT NOT NULL,
  `DataHora` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SaldoAnterior` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Entrada` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Saida` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `Saldo` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `UsuarioId` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_MovimentoContaFinanceira_ContaFinanceira1_idx` (`ContaFinanceiraId` ASC),
  INDEX `fk_MovimentoContaFinanceira_Usuario1_idx` (`UsuarioId` ASC),
  CONSTRAINT `fk_MovimentoContaFinanceira_ContaFinanceira1`
    FOREIGN KEY (`ContaFinanceiraId`)
    REFERENCES `qualia`.`ContaFinanceira` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MovimentoContaFinanceira_Usuario1`
    FOREIGN KEY (`UsuarioId`)
    REFERENCES `qualia`.`Usuario` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
