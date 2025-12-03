-- Ou usar o DELIMITER para criar os objetos

DELIMITER $$

-- 1. FUNCTION: calcular_multa_atraso
-- Calcula o valor da multa com base nos dias de atraso e no valor da diária.
-- REGRA: Multa é 50% do valor da diária para cada dia de atraso.
CREATE FUNCTION calcular_multa_atraso(
    diasAtraso INT,
    valorDiaria DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE valorMulta DECIMAL(10,2);
    
    IF diasAtraso > 0 THEN
        SET valorMulta = diasAtraso * (valorDiaria * 0.50);
    ELSE
        SET valorMulta = 0.00;
    END IF;

    RETURN valorMulta;
END$$

-- 2. PROCEDURE: registrar_devolucao
-- Processa a devolução de um veículo, calcula o valor final e atualiza status.
CREATE PROCEDURE registrar_devolucao(
    IN p_idLocacao INT,
    IN p_dtDevolucao DATETIME,
    IN p_kmDevolucao INT
)
BEGIN
    DECLARE v_dtRetirada DATETIME;
    DECLARE v_idVeiculo INT;
    DECLARE v_valorDiaria DECIMAL(10,2);
    DECLARE v_taxas DECIMAL(10,2);
    DECLARE v_dtFimPrev DATE;
    DECLARE v_diasLocacao INT;
    DECLARE v_diasAtraso INT;
    DECLARE v_multaCalculada DECIMAL(10,2);
    DECLARE v_valorSubtotal DECIMAL(10,2);
    DECLARE v_valorFinal DECIMAL(10,2);

    -- 1. Buscar dados da locação e da reserva (se houver)
    SELECT 
        L.dtRetirada, 
        L.idVeiculo, 
        L.valorDiaria, 
        L.taxas,
        DATE(R.dtFimPrev) -- Apenas a data para comparação de atraso
    INTO 
        v_dtRetirada, 
        v_idVeiculo, 
        v_valorDiaria, 
        v_taxas, 
        v_dtFimPrev
    FROM LOCACAO L
    LEFT JOIN RESERVA R ON L.idReserva = R.idReserva
    WHERE L.idLocacao = p_idLocacao;

    -- 2. Cálculo dos dias de locação (Arredondamento para cima - dia extra conta como dia inteiro)
    SET v_diasLocacao = CEIL(TIMESTAMPDIFF(HOUR, v_dtRetirada, p_dtDevolucao) / 24);
    
    -- 3. Cálculo do Atraso
    SET v_diasAtraso = 0;
    IF v_dtFimPrev IS NOT NULL AND DATE(p_dtDevolucao) > v_dtFimPrev THEN
        SET v_diasAtraso = DATEDIFF(DATE(p_dtDevolucao), v_dtFimPrev);
    END IF;

    -- 4. Cálculo da Multa (chama a FUNCTION)
    SET v_multaCalculada = calcular_multa_atraso(v_diasAtraso, v_valorDiaria);

    -- 5. Cálculo do Valor Final
    SET v_valorSubtotal = v_valorDiaria * v_diasLocacao;
    SET v_valorFinal = v_valorSubtotal + v_taxas + v_multaCalculada;

    -- 6. Atualizar a tabela LOCACAO
    UPDATE LOCACAO
    SET 
        dtDevolucao = p_dtDevolucao,
        kmDevolucao = p_kmDevolucao,
        multa = v_multaCalculada,
        valorFinal = v_valorFinal
    WHERE idLocacao = p_idLocacao;
    
    -- 7. Atualizar a KM atual do veículo
    UPDATE VEICULO
    SET kmAtual = p_kmDevolucao
    WHERE idVeiculo = v_idVeiculo;

    -- 8. Atualizar o STATUS do veículo (para 'Disponível')
    UPDATE VEICULO
    SET status = 'Disponível'
    WHERE idVeiculo = v_idVeiculo;

END$$

DELIMITER ;