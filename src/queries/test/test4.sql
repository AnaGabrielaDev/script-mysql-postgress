SELECT cd.NOM_CIDADE, COUNT(*) AS qtd_fidelizados
FROM CLIENTE cl
JOIN ENDERECO e ON e.COD_ENDERECO = cl.COD_ENDERECO
JOIN CIDADE cd ON cd.COD_IBGE = e.COD_IBGE
WHERE cl.FLG_FIDELIZADO = 'S'
GROUP BY cd.NOM_CIDADE;
-- Quantidade de clientes fidelizados por cidade