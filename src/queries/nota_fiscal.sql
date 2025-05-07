CREATE TABLE nota_fiscal
(
  seq_nota integer NOT NULL,
  cod_pdv integer NOT NULL,
  cod_caixa integer NOT NULL,
  cod_cliente integer NOT NULL,
  num_nota numeric(10,0),
  dat_nota date,
  flg_entrega character varying(1),
  vlr_nota numeric(10,2),
  vlr_dinheiro numeric(10,2),
  vlr_tick numeric(10,2),
  vlr_cartao numeric(10,2)
);