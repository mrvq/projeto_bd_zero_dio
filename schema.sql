-- schema.sql (PostgreSQL)
-- Criação do esquema para Oficina Mecânica

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
SET search_path = public;

-- Tabela: cliente (Pessoa Física)
CREATE TABLE cliente (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(255),
    criado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

-- Tabela: veiculo (pertence a cliente)
CREATE TABLE veiculo (
    veiculo_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES cliente(cliente_id) ON DELETE CASCADE,
    placa VARCHAR(10) NOT NULL UNIQUE,
    modelo VARCHAR(100),
    fabricante VARCHAR(100),
    ano INT,
    chassis VARCHAR(50)
);

-- Tabela: mecanico
CREATE TABLE mecanico (
    mecanico_id SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cpf CHAR(11) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(255)
);

-- Tabela: fornecedor (de peças)
CREATE TABLE fornecedor (
    fornecedor_id SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cnpj CHAR(14) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(255)
);

-- Tabela: peca (peças de estoque)
CREATE TABLE peca (
    peca_id SERIAL PRIMARY KEY,
    sku VARCHAR(80) UNIQUE,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT,
    preco_compra NUMERIC(12,2) DEFAULT 0,
    preco_venda NUMERIC(12,2) DEFAULT 0,
    fornecedor_id INT REFERENCES fornecedor(fornecedor_id) ON DELETE SET NULL
);

-- Tabela: estoque (por peça)
CREATE TABLE estoque (
    estoque_id SERIAL PRIMARY KEY,
    peca_id INT NOT NULL REFERENCES peca(peca_id) ON DELETE CASCADE,
    local_estoque VARCHAR(100) DEFAULT 'PRINCIPAL',
    quantidade INT NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
    UNIQUE (peca_id, local_estoque)
);

-- Tabela: ordem_servico (OS)
CREATE TABLE ordem_servico (
    os_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES cliente(cliente_id) ON DELETE RESTRICT,
    veiculo_id INT NOT NULL REFERENCES veiculo(veiculo_id) ON DELETE RESTRICT,
    mecanico_resp_id INT REFERENCES mecanico(mecanico_id) ON DELETE SET NULL,
    data_abertura TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    data_fechamento TIMESTAMP WITHOUT TIME ZONE,
    status VARCHAR(30) DEFAULT 'ABERTA', -- ABERTA, EM_EXECUCAO, FINALIZADA, CANCELADA
    valor_total NUMERIC(12,2) DEFAULT 0 CHECK (valor_total >= 0),
    observacoes TEXT
);

-- Tabela: os_mecanico (vincula mecanicos auxiliares à OS) - N:N
CREATE TABLE os_mecanico (
    os_id INT NOT NULL REFERENCES ordem_servico(os_id) ON DELETE CASCADE,
    mecanico_id INT NOT NULL REFERENCES mecanico(mecanico_id) ON DELETE CASCADE,
    papel VARCHAR(50) DEFAULT 'AUXILIAR',
    PRIMARY KEY (os_id, mecanico_id)
);

-- Tabela: item_os (peças e serviços aplicados na OS)
CREATE TABLE item_os (
    item_os_id SERIAL PRIMARY KEY,
    os_id INT NOT NULL REFERENCES ordem_servico(os_id) ON DELETE CASCADE,
    tipo_item VARCHAR(10) NOT NULL CHECK (tipo_item IN ('SERVICO','PECA')),
    descricao VARCHAR(255),
    peca_id INT REFERENCES peca(peca_id) ON DELETE SET NULL,
    quantidade INT DEFAULT 1 CHECK (quantidade > 0),
    valor_unitario NUMERIC(12,2) DEFAULT 0 CHECK (valor_unitario >= 0),
    desconto NUMERIC(12,2) DEFAULT 0 CHECK (desconto >= 0)
);

-- Tabela: pagamento (vinculado à OS)
CREATE TABLE pagamento (
    pagamento_id SERIAL PRIMARY KEY,
    os_id INT NOT NULL REFERENCES ordem_servico(os_id) ON DELETE CASCADE,
    valor_pago NUMERIC(12,2) NOT NULL CHECK (valor_pago >= 0),
    forma_pagamento VARCHAR(20) NOT NULL CHECK (forma_pagamento IN ('DINHEIRO','CARTAO','BOLETO','PIX')),
    data_pagamento TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    status_pagamento VARCHAR(20) DEFAULT 'PENDENTE' CHECK (status_pagamento IN ('PENDENTE','PAGO','ESTORNADO'))
);

-- Índices
CREATE INDEX idx_os_cliente ON ordem_servico(cliente_id);
CREATE INDEX idx_os_status ON ordem_servico(status);
CREATE INDEX idx_estoque_peca ON estoque(peca_id);

