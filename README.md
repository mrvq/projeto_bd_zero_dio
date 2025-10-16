# 🛠️ Projeto de Banco de Dados - Oficina Mecânica (PostgreSQL)

## 📘 Descrição do Projeto
Este projeto apresenta o **modelo lógico e físico** de um banco de dados para o contexto de uma oficina mecânica.
Inclui esquema em **PostgreSQL** (DDL), dados de exemplo (DML), consultas SQL complexas (queries) e um diagrama ER em PNG.

### Entidades principais
- Cliente (Pessoa Física)
- Veículo (pertence a um cliente)
- Mecânico
- Peça
- Ordem de Serviço (OS)
- Item_OS (peças/serviços aplicados na OS)
- Pagamento
- Fornecedor (de peças)
- Estoque

### Regras de negócio principais
- Um cliente pode ter vários veículos.
- Uma Ordem de Serviço (OS) pertence a um cliente e a um veículo; uma OS pode incluir vários itens (mão-de-obra e peças).
- Um mecânico pode atender várias OS; uma OS pode ter um mecânico responsável e vários mecânicos auxiliares registrados via tabela de vínculo (os_mecanico).
- Peças são fornecidas por fornecedores; existe controle de estoque por peça.
- Pagamentos podem ser parciais e vinculados a uma OS (possibilidade de múltiplos pagamentos por OS).

## Estrutura do repositório
```
oficina-db-pg/
├── README.md
├── schema.sql    -- criação do esquema (PostgreSQL)
├── data.sql      -- dados de exemplo (inserts)
├── queries.sql   -- consultas complexas com SELECT, WHERE, HAVING, JOIN, ORDER BY
└── diagrama-er.png -- diagrama ER (imagem)
```

## Como executar (PostgreSQL)
1. Criar banco e conectar (exemplo):
```sql
CREATE DATABASE oficina_db WITH ENCODING 'UTF8';
\c oficina_db
```
2. Executar o script `schema.sql` em um cliente psql ou pgAdmin.
3. Executar `data.sql` para popular os dados de exemplo.
4. Executar `queries.sql` para testar as consultas.

---
Autor: Marcio Queirantes
