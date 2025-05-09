SELECT c.NOM_ESTADO, SUM(nf.VLR_NOTA) AS total_faturado
FROM nota_fiscal nf
JOIN cliente cl ON cl.COD_CLIENTE = nf.COD_CLIENTE
JOIN endereco e ON e.COD_ENDERECO = cl.COD_ENDERECO
JOIN cidade c ON c.COD_IBGE = e.COD_IBGE
GROUP BY c.NOM_ESTADO;
-- Total faturado por estado