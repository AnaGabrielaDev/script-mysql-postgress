CREATE TABLE pdv
(
  cod_pdv integer NOT NULL,
  num_registro numeric(10,0),
  dat_inicio_vigencia date,
  dat_fim_vigencia date,
  num_nota_inicial numeric(10,0),
  num_nota_final numeric(10,0),
  cod_loja integer NOT NULL,
  num_pdv_loja numeric(2,0)
);