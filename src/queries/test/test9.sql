SELECT 
  ci.nom_cidade,
  ci.nom_estado,
  COUNT(DISTINCT cl.cod_cliente) AS total_clientes,
  COUNT(n.seq_nota) AS total_compras,
  SUM(n.vlr_nota) AS total_gasto,
  AVG(n.vlr_nota) AS media_por_compra
FROM cidade ci
JOIN endereco e ON ci.cod_ibge = e.cod_ibge
JOIN cliente cl ON cl.cod_endereco = e.cod_endereco
JOIN nota_fiscal n ON n.cod_cliente = cl.cod_cliente
GROUP BY ci.nom_cidade, ci.nom_estado
HAVING COUNT(n.seq_nota) > 10
ORDER BY total_gasto DESC
LIMIT 15;
-- Ranking de cidades com mais clientes e suas médias de compra