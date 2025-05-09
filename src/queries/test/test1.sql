SELECT EXTRACT(YEAR FROM nf.DAT_NOTA) AS ano, SUM(nf.VLR_NOTA) AS total_vendido
FROM nota_fiscal nf
GROUP BY EXTRACT(YEAR FROM nf.DAT_NOTA)
ORDER BY ano;
-- Total vendido por ano