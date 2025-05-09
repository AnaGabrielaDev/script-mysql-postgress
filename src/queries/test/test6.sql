SELECT 
    nf.seq_nota,
    nf.num_nota,
    nf.dat_nota,
    nf.vlr_nota,
    
    cl.nom_cliente,
    cl.flg_fidelizado,
    
    cd.nom_cidade,
    cd.nom_estado,
    cd.nom_regiao,
    cd.nom_pais,
    
    e.nom_logradouro,
    e.num_logradouro,
    e.cod_cep,
    e.flg_exterior,
    e.tip_logradouro,
    
    p.nom_produto,
    p.vlr_venda,
    p.vlr_custo,
    p.vlr_medio,
    p.vlr_promocao,
    
    f.nom_fornecedor,
    
    s.nom_setor,
    u.nom_unidade,
    
    i.qtd_produto,
    i.vlr_venda AS item_vlr_venda,
    i.vlr_custo AS item_vlr_custo,
    i.vlr_medio AS item_vlr_medio,
    i.vlr_promocao AS item_vlr_promocao,
    
    pr.nom_promocao,
    
    l.nom_loja,
    l.flg_matriz,
    
    cx.nom_caixa
FROM nota_fiscal nf
JOIN item_nota i            ON nf.seq_nota = i.seq_nota
JOIN produto p              ON i.cod_produto = p.cod_produto
JOIN fornecedor f           ON p.cod_fornecedor = f.cod_fornecedor
JOIN setor s                ON p.cod_setor = s.cod_setor
JOIN unidade u              ON p.cod_unidade = u.cod_unidade
LEFT JOIN promocao pr       ON p.cod_promocao = pr.cod_promocao
JOIN cliente cl             ON nf.cod_cliente = cl.cod_cliente
JOIN endereco e             ON cl.cod_endereco = e.cod_endereco
JOIN cidade cd              ON e.cod_ibge = cd.cod_ibge
JOIN caixa cx               ON nf.cod_caixa = cx.cod_caixa
JOIN loja l                 ON cx.cod_loja = l.cod_loja
JOIN pdv                    ON nf.cod_pdv = pdv.cod_pdv
ORDER BY nf.dat_nota DESC
LIMIT 100;

-- recupera informações completas sobre notas fiscais emitidas, incluindo: os clientes que compraram,os produtos vendidos,os valores pagos,

