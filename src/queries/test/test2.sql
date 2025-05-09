SELECT p.NOM_PRODUTO, SUM(i.QTD_PRODUTO) AS quantidade_total
FROM item_nota i
JOIN produto p ON p.COD_PRODUTO = i.COD_PRODUTO
GROUP BY p.NOM_PRODUTO
ORDER BY quantidade_total DESC
LIMIT 5;
-- Produtos mais vendidos
