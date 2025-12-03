USE locadora_veiculos;

-- 1. vw_faturamento_mensal(filial, mes, total)
-- FINALIDADE: Agregação rápida de faturamento mensal por filial para o dashboard gerencial.
CREATE VIEW vw_faturamento_mensal AS
SELECT
    F.nome AS Filial,
    DATE_FORMAT(L.dtDevolucao, '%Y-%m') AS MesReferencia,
    SUM(L.valorFinal) AS FaturamentoTotal
FROM LOCACAO L
INNER JOIN FILIAL F ON L.idFilialDevolucao = F.idFilial
WHERE L.valorFinal IS NOT NULL
GROUP BY F.nome, MesReferencia;

-- 2. vw_utilizacao_frota(categoria, totalVeiculos, emUso, disponibilidade)
-- FINALIDADE: Medir a taxa de ocupação da frota por categoria.
CREATE VIEW vw_utilizacao_frota AS
SELECT
    C.nome AS Categoria,
    COUNT(V.idVeiculo) AS TotalVeiculos,
    SUM(CASE WHEN V.status = 'Locado' THEN 1 ELSE 0 END) AS EmUso,
    SUM(CASE WHEN V.status = 'Disponível' THEN 1 ELSE 0 END) AS Disponibilidade,
    ROUND((SUM(CASE WHEN V.status = 'Locado' THEN 1 ELSE 0 END) / COUNT(V.idVeiculo)) * 100, 2) AS TaxaOcupacaoPct
FROM VEICULO V
INNER JOIN CATEGORIA C ON V.idCategoria = C.idCategoria
WHERE V.status <> 'Baixado'
GROUP BY C.nome;