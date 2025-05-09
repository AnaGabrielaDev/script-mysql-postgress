SELECT 
  cod_cliente,
  COUNT(*) AS total_compras
FROM nota_fiscal
WHERE cod_cliente IN (
  SELECT cod_cliente FROM cliente WHERE flg_fidelizado = 'S'
)
GROUP BY cod_cliente
ORDER BY total_compras DESC
LIMIT 20;


-- Tempo médio entre compras por cliente fidelizado