USE locadora_veiculos;

-- 1. INNER JOIN: Listagem de locações com cliente, veículo e filial de retirada.
-- FINALIDADE: Relatório básico de transações, ligando os IDs de locação aos nomes de entidades.
SELECT
    L.idLocacao,
    C.nome AS Cliente,
    V.placa AS Veiculo,
    F.nome AS FilialRetirada,
    L.dtRetirada,
    L.valorFinal
FROM LOCACAO L
INNER JOIN CLIENTE C ON L.idCliente = C.idCliente
INNER JOIN VEICULO V ON L.idVeiculo = V.idVeiculo
INNER JOIN FILIAL F ON L.idFilialRetirada = F.idFilialRetirada
ORDER BY L.idLocacao;

-- 2. LEFT JOIN: Veículos e sua última locação (mesmo que não tenham sido locados).
-- FINALIDADE: Identificar veículos que nunca foram locados ou qual foi sua última transação.
SELECT
    V.placa,
    V.modelo,
    L.dtRetirada AS UltimaRetirada,
    L.dtDevolucao AS UltimaDevolucao
FROM VEICULO V
LEFT JOIN LOCACAO L ON V.idVeiculo = L.idVeiculo
LEFT JOIN ( -- Subconsulta para achar a locação mais recente para cada veículo
    SELECT idVeiculo, MAX(dtRetirada) AS UltimaRetirada
    FROM LOCACAO
    GROUP BY idVeiculo
) AS Ultima ON L.idVeiculo = Ultima.idVeiculo AND L.dtRetirada = Ultima.UltimaRetirada
ORDER BY V.placa;

-- 3. RIGHT JOIN: Filiais e veículos que estão atualmente nela.
-- FINALIDADE: Garantir que todas as filiais (mesmo as sem veículos) sejam listadas.
-- É equivalente a um LEFT JOIN de VEICULO com FILIAL, mas usa RIGHT JOIN conforme requisito.
SELECT
    F.nome AS Filial,
    V.placa,
    V.modelo
FROM VEICULO V
RIGHT JOIN FILIAL F ON V.idFilialAtual = F.idFilial
ORDER BY F.nome, V.placa;

-- 4. Agregação SUM: Faturamento total por mês e filial de retirada.
-- FINALIDADE: Análise gerencial do desempenho de vendas das filiais ao longo do tempo.
SELECT
    F.nome AS Filial,
    DATE_FORMAT(L.dtRetirada, '%Y-%m') AS MesReferencia,
    SUM(L.valorFinal) AS FaturamentoTotal
FROM LOCACAO L
INNER JOIN FILIAL F ON L.idFilialRetirada = F.idFilial
WHERE L.dtDevolucao IS NOT NULL -- Apenas locações concluídas (com valorFinal)
GROUP BY F.nome, MesReferencia
ORDER BY MesReferencia, F.nome;

-- 5. Agregação MAX/MIN: Maior valor de diária e menor quilometragem de retirada por categoria.
-- FINALIDADE: Comparar dados de locação (preço e uso) entre as categorias.
SELECT
    CAT.nome AS Categoria,
    MAX(L.valorDiaria) AS MaiorDiariaEfetiva,
    MIN(L.kmRetirada) AS MenorKmRetirada
FROM LOCACAO L
INNER JOIN VEICULO V ON L.idVeiculo = V.idVeiculo
INNER JOIN CATEGORIA CAT ON V.idCategoria = CAT.idCategoria
GROUP BY CAT.nome
ORDER BY CAT.nome;

-- 6. GROUP BY: Quantidade de locações por categoria de veículo.
-- FINALIDADE: Medir a popularidade e demanda por cada tipo de veículo na frota.
SELECT
    CAT.nome AS Categoria,
    COUNT(L.idLocacao) AS TotalLocacoes
FROM LOCACAO L
INNER JOIN VEICULO V ON L.idVeiculo = V.idVeiculo
INNER JOIN CATEGORIA CAT ON V.idCategoria = CAT.idCategoria
GROUP BY CAT.nome
ORDER BY TotalLocacoes DESC;

-- 7. CASE: Classificação de atraso na devolução.
-- FINALIDADE: Relatório de inadimplência/multas para fins de cobrança e análise de risco.
SELECT
    L.idLocacao,
    C.nome AS Cliente,
    R.dtFimPrev AS PrevisaoDevolucao,
    L.dtDevolucao AS DevolucaoEfetiva,
    L.multa,
    CASE
        WHEN L.multa > 0 THEN 'Com Atraso e Multa'
        WHEN L.dtDevolucao > R.dtFimPrev THEN 'Com Atraso (Multa Não Aplicada ou ZERO)' -- Caso a multa seja 0 por alguma política
        WHEN L.dtDevolucao IS NULL THEN 'Locação em Andamento'
        ELSE 'No Prazo'
    END AS StatusAtraso
FROM LOCACAO L
LEFT JOIN RESERVA R ON L.idReserva = R.idReserva -- Atraso só faz sentido em locação baseada em reserva
INNER JOIN CLIENTE C ON L.idCliente = C.idCliente
ORDER BY L.idLocacao;

-- 8. Subconsulta: Top 3 clientes por valor total locado.
-- FINALIDADE: Identificar os clientes mais valiosos para programas de fidelidade ou marketing.
SELECT
    C.nome AS Cliente,
    TotalGasto AS ValorTotalLocado
FROM CLIENTE C
INNER JOIN (
    SELECT
        idCliente,
        SUM(valorFinal) AS TotalGasto
    FROM LOCACAO
    WHERE valorFinal IS NOT NULL
    GROUP BY idCliente
    ORDER BY TotalGasto DESC
    LIMIT 3
) AS TopClientes ON C.idCliente = TopClientes.idCliente
ORDER BY TotalGasto DESC;

-- ===============================================
-- 🧪 Consultas de validação (obrigatórias)
-- ===============================================

-- VALIDAÇÃO 1: Cálculo da FUNCTION isolada (SELECT calcular_multa_atraso(2, 100.00);)
-- (Esta será executada após a criação da FUNCTION no script 07)
-- SELECT calcular_multa_atraso(2, 100.00);

-- VALIDAÇÃO 2: Uso da VIEW em uma consulta (ex.: SELECT * FROM vw_faturamento_mensal WHERE mes='2025-11';)
-- (Esta será executada após a criação da VIEW no script 06)
-- SELECT * FROM vw_faturamento_mensal WHERE mes='2025-11';

-- VALIDAÇÃO 3: Locação antes e depois da devolução (para provar a PROCEDURE)
-- Escolhemos a Locação 10 (idVeiculo 19) que está em andamento (NULL)
-- 3a. Situação ANTES da devolução:
SELECT
    L.idLocacao, V.placa, V.status AS StatusVeiculo, L.dtDevolucao, L.kmDevolucao, L.valorFinal
FROM LOCACAO L
INNER JOIN VEICULO V ON L.idVeiculo = V.idVeiculo
WHERE L.idLocacao = 10;
-- O status do Veículo (id=19) deve ser 'Locado' e os campos de devolução/final NULL.

-- 3b. Simulação do EFEITO da PROCEDURE (Será executado após a criação da PROCEDURE no script 07)
-- CALL registrar_devolucao(10, '2025-12-02 10:00:00', 1500);

-- 3c. Situação DEPOIS da devolução (após a chamada da PROCEDURE):
-- SELECT
--     L.idLocacao, V.placa, V.status AS StatusVeiculo, L.dtDevolucao, L.kmDevolucao, L.valorFinal
-- FROM LOCACAO L
-- INNER JOIN VEICULO V ON L.idVeiculo = V.idVeiculo
-- WHERE L.idLocacao = 10;
-- O status do Veículo (id=19) deve ser 'Disponível' e os campos de devolução/final preenchidos.

-- Desabilita o Modo de Atualização Segura (apenas para a sessão atual)
SET SQL_SAFE_UPDATES = 0; 

-- DELETE FROM LOG_AUDITORIA... (comando problemático)

-- Opcional: Reabilitar o Modo de Atualização Segura
SET SQL_SAFE_UPDATES = 1;

-- ALTERNATIVA COMPLEXA: Adicionar um índice na coluna 'dtAcao'
-- ALTER TABLE LOG_AUDITORIA ADD INDEX idx_dt_acao (dtAcao);