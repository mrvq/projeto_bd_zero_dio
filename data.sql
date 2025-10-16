-- data.sql (PostgreSQL) - dados de exemplo
SET client_min_messages TO WARNING;
BEGIN;

-- Clientes
INSERT INTO cliente(nome, cpf, telefone, email) VALUES
('Ana Pereira','12345678901','+5511999990001','ana.pereira@example.com'),
('Bruno Souza','98765432100','+5511988880002','bruno.souza@example.com'),
('Carlos Lima','11122233344','+5519977770003','carlos.lima@example.com');

-- Veiculos
INSERT INTO veiculo (cliente_id, placa, modelo, fabricante, ano, chassis) VALUES
(1,'ABC1234','Gol 1.0','Volkswagen',2010,'CHS1234567890'),
(2,'DEF5678','Uno','Fiat',2015,'CHS0987654321'),
(1,'GHI9012','HB20','Hyundai',2018,'CHS1122334455');

-- Mecanicos
INSERT INTO mecanico (nome, cpf, telefone, email) VALUES
('Marcio Silva','55566677788','+5511944440001','marcio.silva@oficina.com'),
('Joaquina Alves','44455566677','+5511933330002','joaquina.alves@oficina.com');

-- Fornecedores
INSERT INTO fornecedor (nome, cnpj, telefone, email) VALUES
('AutoPeças SA','12345678000199','+551132220000','contato@autopecas.com'),
('Pecas Rapidas LTDA','22345678000188','+551933330000','vendas@pecasrapidas.com');

-- Pecas
INSERT INTO peca (sku, nome, descricao, preco_compra, preco_venda, fornecedor_id) VALUES
('P-001','Filtro de óleo','Filtro de óleo para motores 1.0-1.6',10.00,25.00,1),
('P-002','Pastilha de freio','Pastilha dianteira',30.00,80.00,2),
('P-003','Vela ignicao','Vela para diversos modelos',5.00,12.00,1);

-- Estoque
INSERT INTO estoque (peca_id, local_estoque, quantidade) VALUES
(1,'PRINCIPAL',50),
(2,'PRINCIPAL',20),
(3,'PRINCIPAL',100);

-- Ordens de serviço (OS)
INSERT INTO ordem_servico (cliente_id, veiculo_id, mecanico_resp_id, data_abertura, status, valor_total, observacoes) VALUES
(1,1,1,'2025-10-01 08:30:00','FINALIZADA',150.00,'Troca de óleo e filtros'),
(2,2,2,'2025-10-03 09:00:00','EM_EXECUCAO',300.00,'Troca de pastilhas de freio'),
(1,3,NULL,'2025-10-05 10:15:00','ABERTA',0.00,'Diagnóstico - sem orçamento ainda');

-- OS_Mecanico (auxiliares)
INSERT INTO os_mecanico (os_id, mecanico_id, papel) VALUES
(2,1,'AUXILIAR');

-- Itens de OS
INSERT INTO item_os (os_id, tipo_item, descricao, peca_id, quantidade, valor_unitario, desconto) VALUES
(1,'PECA','Filtro de óleo',1,1,25.00,0.00),
(1,'SERVICO','Troca de óleo (mão de obra)',NULL,1,50.00,0.00),
(2,'PECA','Pastilha de freio',2,4,80.00,0.00),
(2,'SERVICO','Substituição pastilhas',NULL,1,20.00,0.00);

-- Pagamentos
INSERT INTO pagamento (os_id, valor_pago, forma_pagamento, data_pagamento, status_pagamento) VALUES
(1,150.00,'CARTAO','2025-10-01 10:00:00','PAGO'),
(2,100.00,'DINHEIRO','2025-10-04 12:00:00','PENDENTE');

COMMIT;
