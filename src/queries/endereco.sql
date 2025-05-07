
CREATE TABLE endereco
(
  cod_endereco integer NOT NULL,
  nom_logradouro character varying(50),
  num_logradouro character varying(10),
  cod_cep numeric(8,0),
  cod_ibge integer NOT NULL,
  flg_exterior character varying(1),
  tip_logradouro character varying(3)
);