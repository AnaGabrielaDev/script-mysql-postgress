SELECT
  l.cod_loja,
  l.nom_loja,
  COUNT(n.seq_nota) AS qtd_notas,
  SUM(n.vlr_nota) AS total_vendas,
  AVG(n.vlr_nota) AS media_ticket,
  SUM(n.vlr_dinheiro) AS total_dinheiro,
  SUM(n.vlr_cartao) AS total_cartao,
  SUM(n.vlr_tick) AS total_ticket
FROM nota_fiscal n
JOIN caixa c ON n.cod_caixa = c.cod_caixa
JOIN loja l ON c.cod_loja = l.cod_loja
WHERE n.dat_nota >= DATE '2024-01-01'
GROUP BY l.cod_loja, l.nom_loja
ORDER BY total_vendas DESC;
-- Faturamento por loja, incluindo total de vendas, tickets médios e formas de pagamento