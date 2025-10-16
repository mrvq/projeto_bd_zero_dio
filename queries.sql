-- queries.sql (PostgreSQL) - consultas para o desafio da oficina

-- 1) Recuperações simples: listar clientes
SELECT cliente_id, nome, cpf, telefone, email FROM cliente;

-- 2) Filtros com WHERE: clientes cujo nome contenha 'Ana' ou 'Bruno'
SELECT cliente_id, nome FROM cliente WHERE nome ILIKE '%ana%' OR nome ILIKE '%bruno%';

-- 3) Atributo derivado: total de itens em estoque por peça (expressão)
SELECT p.peca_id, p.sku, p.nome,
       COALESCE(e.quantidade,0) AS quantidade_estoque,
       to_char(p.preco_venda, 'FM999999999.00') || ' BRL' AS preco_formatado
FROM peca p
LEFT JOIN estoque e ON e.peca_id = p.peca_id
ORDER BY p.nome;

-- 4) Ordenação: peças por preco_venda desc
SELECT peca_id, nome, preco_venda FROM peca ORDER BY preco_venda DESC;

-- 5) Condição de grupo (HAVING): mecânicos com horas de serviço acumuladas (simulado) > 1
-- Aqui usamos COUNT de OS atribuídas como proxy para carga de trabalho
SELECT m.mecanico_id, m.nome, COUNT(o.os_id) AS total_os
FROM mecanico m
LEFT JOIN ordem_servico o ON o.mecanico_resp_id = m.mecanico_id
GROUP BY m.mecanico_id, m.nome
HAVING COUNT(o.os_id) > 0
ORDER BY total_os DESC;

-- 6) Junções complexas: listar OS com itens, peças e responsáveis
SELECT o.os_id, o.data_abertura, o.status, c.nome AS cliente, v.placa, m.nome AS mecanico_resp,
       i.item_os_id, i.tipo_item, i.descricao, p.nome AS peca_nome, i.quantidade, i.valor_unitario
FROM ordem_servico o
JOIN cliente c ON c.cliente_id = o.cliente_id
JOIN veiculo v ON v.veiculo_id = o.veiculo_id
LEFT JOIN mecanico m ON m.mecanico_id = o.mecanico_resp_id
LEFT JOIN item_os i ON i.os_id = o.os_id
LEFT JOIN peca p ON p.peca_id = i.peca_id
ORDER BY o.data_abertura DESC, o.os_id;

-- 7) Pergunta: Quais peças estão com estoque baixo (< 30)?
SELECT p.peca_id, p.nome, e.quantidade
FROM peca p
JOIN estoque e ON e.peca_id = p.peca_id
WHERE e.quantidade < 30
ORDER BY e.quantidade ASC;

-- 8) Pergunta: Qual o faturamento por OS (soma itens) e quais OS apresentam discrepância com o valor_total?
SELECT o.os_id, o.valor_total,
       COALESCE(SUM(i.quantidade * i.valor_unitario - i.desconto),0) AS soma_itens,
       (COALESCE(SUM(i.quantidade * i.valor_unitario - i.desconto),0) - o.valor_total) AS discrepancia
FROM ordem_servico o
LEFT JOIN item_os i ON i.os_id = o.os_id
GROUP BY o.os_id, o.valor_total
HAVING COALESCE(SUM(i.quantidade * i.valor_unitario - i.desconto),0) <> o.valor_total;

-- 9) Clientes que usaram mais de uma forma de pagamento (via pagamentos por OS)
SELECT c.cliente_id, c.nome, COUNT(DISTINCT pay.forma_pagamento) AS formas_pagamento
FROM cliente c
JOIN ordem_servico o ON o.cliente_id = c.cliente_id
JOIN pagamento pay ON pay.os_id = o.os_id
GROUP BY c.cliente_id, c.nome
HAVING COUNT(DISTINCT pay.forma_pagamento) > 1;

-- 10) Relacionar fornecedores e peças fornecidas
SELECT f.fornecedor_id, f.nome AS fornecedor, p.peca_id, p.nome AS peca
FROM fornecedor f
JOIN peca p ON p.fornecedor_id = f.fornecedor_id
ORDER BY f.nome, p.nome;
