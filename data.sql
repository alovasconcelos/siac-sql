insert into estado (CodigoIBGE,Nome,Sigla) values
('11',	'Rondônia'	,'RO'),
('12',	'Acre'	,'AC'),
('13',	'Amazonas'	,'AM'),
('14',	'Roraima'	,'RR'),
('15',	'Pará'	,'PA'),
('16',	'Amapá'	,'AP'),
('17',	'Tocantins'	,'TO'),
('21',	'Maranhão'	,'MA'),
('22',	'Piauí'	,'PI'),
('23',	'Ceará'	,'CE'),
('24',	'Rio Grande do Norte'	,'RN'),
('25',	'Paraíba'	,'PB'),
('26',	'Pernambuco'	,'PE'),
('27',	'Alagoas'	,'AL'),
('28',	'Sergipe'	,'SE'),
('29',	'Bahia'	,'BA'),
('31',	'Minas Gerais'	,'MG'),
('32',	'Espírito Santo'	,'ES'),
('33',	'Rio de Janeiro'	,'RJ'),
('35',	'São Paulo'	,'SP'),
('41',	'Paraná'	,'PR'),
('42',	'Santa Catarina'	,'SC'),
('43',	'Rio Grande do Sul'	,'RS'),
('50',	'Mato Grosso do Sul'	,'MS'),
('51',	'Mato Grosso'	,'MT'),
('52',	'Goiás'	,'GO'),
('53',	'Distrito Federal'	,'DF');

insert into UnidadeComercial (Codigo,Descricao,FatorConversao) values 
('UNID','UNIDADE',1),
('KG','QUILOGRAMA',1),
('LITRO','LITRO',1),
('DUZIA','DUZIA',1);

insert into Categoria (Id, Descricao) values (1, 'DIVERSOS');
insert into Categoria (Id, Descricao) values (2, 'LATICÍNIOS');
insert into Categoria (Id, Descricao) values (3, 'CEREAIS');
insert into Categoria (Id, Descricao) values (4, 'AÇÚCARES E ADOÇANTES');
insert into Categoria (Id, Descricao) values (5, 'BISCOITOS');
insert into Categoria (Id, Descricao) values (6, 'MASSAS');
insert into Categoria (Id, Descricao) values (7, 'GRÃOS');
insert into Categoria (Id, Descricao) values (8, 'ENLATADOS E CONSERVAS');
insert into Categoria (Id, Descricao) values (9, 'HIGIENE E LIMPEZA');
insert into Categoria (Id, Descricao) values (10, 'PERFUMARIA E FÁRMACOS');
insert into Categoria (Id, Descricao) values (11, 'UTENSÍLIOS EM GERAL');
insert into Categoria (Id, Descricao) values (12, 'CARNES E FRUTOS DO MAR');
insert into Categoria (Id, Descricao) values (13, 'PADARIA');
insert into Categoria (Id, Descricao) values (14, 'LANCHONETE');
insert into Categoria (Id, Descricao) values (15, 'BEBIDAS');
insert into Categoria (Id, Descricao) values (16, 'AMIDOS E FARINÁCEOS');
insert into Categoria (Id, Descricao) values (17, 'EMBUTIDOS');
insert into Categoria (Id, Descricao) values (18, 'CERVEJAS');
insert into Categoria (Id, Descricao) values (19, 'VINHOS');


insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('01','Dinheiro');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('02','Cheque');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('03','Cartão de Crédito');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('04','Cartão de Débito');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('05','Crédito Loja');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('10','Vale Alimentação');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('11','Vale Refeição');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('12','Vale Presente');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('13','Vale Combustível');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('15','Boleto Bancário');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('16','Depósito Bancário');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('17','Pagamento Instantâneo (PIX)');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('18','Transferência bancária, Carteira Digital');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('19','Programa de fidelidade, Cashback, Crédito Virtual');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('90','Sem pagamento');
insert into FormaPagamentoNFe (Codigo, Descricao) VALUES ('99','Outros');

insert into FormaPagamento (Descricao) VALUES ('A VISTA');

insert into Tributo (Descricao, 
                    AliquotaICMSConsumidor, 
                    AliquotaICMSContribuinte,
                    AliquotaICMSST,
                    CSTContribuinte,
                    CSTConsumidor,
                    CSTSubstituicaoTributaria,
                    CSOSNConsumidor,
                    CSOSNContribuinte,
                    OrigemMercadoria,
                    AliquotaPIS,
                    AliquotaCOFINS,
                    CSTPIS,
                    CSTCOFINS) VALUES (
                        'Simples BA',
                        0,
                        18,
                        0,
                        '00',
                        '00',
                        '60',
                        '102',
                        '102',
                        '0',
                        .65,
                        3,
                        '49',
                        '49'
                    );
