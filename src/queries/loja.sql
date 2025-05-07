CREATE TABLE loja
(
  cod_loja serial NOT NULL,
  nom_loja character varying(50),
  cod_endereco integer NOT NULL,
  flg_matriz character varying(1)
);