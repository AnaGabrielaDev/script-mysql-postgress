CREATE TABLE produto
(
  cod_produto integer NOT NULL,
  nom_produto character varying(50),
  cod_fornecedor integer NOT NULL,
  cod_setor integer NOT NULL,
  cod_unidade integer NOT NULL,
  flg_fracionado character varying(1),
  vlr_venda numeric(8,2),
  vlr_custo numeric(8,2),
  vlr_medio numeric(8,2),
  cod_promocao integer,
  vlr_promocao numeric(8,2)
);