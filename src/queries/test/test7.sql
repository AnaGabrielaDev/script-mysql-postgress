SELECT 
  p.cod_produto,
  p.nom_produto,
  pr.nom_promocao,
  SUM(i.qtd_produto) AS total_unidades,
  SUM(i.vlr_venda * i.qtd_produto) AS total_venda,
  SUM(i.vlr_promocao * i.qtd_produto) AS total_promocao,
  SUM((i.vlr_venda - i.vlr_promocao) * i.qtd_produto) AS economia_total
FROM item_nota i
JOIN produto p ON i.cod_produto = p.cod_produto
JOIN nota_fiscal n ON i.seq_nota = n.seq_nota
JOIN promocao pr ON p.cod_promocao = pr.cod_promocao
WHERE pr.dat_inicio_vigencia <= CURRENT_DATE
  AND pr.dat_fim_vigencia >= CURRENT_DATE
GROUP BY p.cod_produto, p.nom_produto, pr.nom_promocao
ORDER BY economia_total DESC
LIMIT 20;
-- Produtos mais vendidos com promoção ativa