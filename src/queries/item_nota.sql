CREATE TABLE item_nota
(
  seq_item_nota integer NOT NULL,
  seq_nota integer NOT NULL,
  cod_produto integer NOT NULL,
  qtd_produto numeric(5,2),
  vlr_venda numeric(10,2),
  vlr_custo numeric(10,2),
  vlr_medio numeric(10,2),
  vlr_promocao numeric(10,2)
);