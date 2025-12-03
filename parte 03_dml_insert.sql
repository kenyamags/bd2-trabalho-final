USE locadora_veiculos;

-- INSERTS (dados de teste)

-- 1. FILIAIS (>= 3)
INSERT INTO FILIAL (nome, cidade, uf) VALUES
('Matriz São Paulo', 'São Paulo', 'SP'),
('Filial Rio', 'Rio de Janeiro', 'RJ'),
('Filial BH', 'Belo Horizonte', 'MG'),
('Filial Brasília', 'Brasília', 'DF');

-- 2. FUNCIONARIOS (>= 3)
-- idFilial 1: SP, 2: RJ, 3: BH
INSERT INTO FUNCIONARIO (nome, cpf, email, idFilial, dtAdmissao) VALUES
('João Silva', '11122233344', 'joao.s@locadora.com', 1, '2020-01-15'),
('Maria Oliveira', '22233344455', 'maria.o@locadora.com', 1, '2021-03-20'),
('Pedro Souza', '33344455566', 'pedro.s@locadora.com', 2, '2019-11-10'),
('Ana Costa', '44455566677', 'ana.c@locadora.com', 3, '2022-07-01');

-- 3. CATEGORIAS (>= 5)
INSERT INTO CATEGORIA (nome, descricao, valorDiariaPadrao) VALUES
('Econômico', 'Carros 1.0, 4 portas, sem luxo.', 80.00),
('Sedan', 'Carros intermediários com porta-malas grande.', 120.00),
('SUV', 'Utilitários esportivos, conforto e espaço.', 180.00),
('Luxo', 'Veículos de alto padrão e desempenho.', 350.00),
('Van', 'Veículos para 7+ passageiros.', 250.00);

-- 4. VEICULOS (>= 20)
-- idCategoria 1: Econômico, 2: Sedan, 3: SUV, 4: Luxo, 5: Van
-- idFilialAtual 1: SP, 2: RJ, 3: BH, 4: Brasília
INSERT INTO VEICULO (placa, renavam, marca, modelo, ano, idCategoria, idFilialAtual, kmAtual, status) VALUES
-- SP (Filial 1)
('ABC1A23', '11111111111', 'Fiat', 'Mobi', 2023, 1, 1, 5000, 'Disponível'), -- 1
('DEF4G56', '22222222222', 'Hyundai', 'HB20S', 2022, 2, 1, 15000, 'Locado'), -- 2 (Locado)
('GHI7J89', '33333333333', 'Jeep', 'Renegade', 2023, 3, 1, 8000, 'Disponível'), -- 3
('JKL0L12', '44444444444', 'BMW', 'Série 3', 2024, 4, 1, 1000, 'Disponível'), -- 4
('MNO3P45', '55555555555', 'Fiat', 'Uno', 2018, 1, 1, 80000, 'Em Manutenção'), -- 5
('PQR6S78', '66666666666', 'VW', 'Gol', 2020, 1, 1, 30000, 'Disponível'), -- 6
-- RJ (Filial 2)
('STU9V01', '77777777777', 'Toyota', 'Corolla', 2023, 2, 2, 10000, 'Locado'), -- 7 (Locado)
('WXY2Z34', '88888888888', 'Chevrolet', 'Spin', 2024, 5, 2, 500, 'Disponível'), -- 8
('ZAB5C67', '99999999999', 'Fiat', 'Mobi', 2024, 1, 2, 1000, 'Disponível'), -- 9
('CDE8F90', '00000000000', 'Honda', 'Civic', 2021, 2, 2, 45000, 'Disponível'), -- 10
-- BH (Filial 3)
('FGH1I23', '12345678901', 'Jeep', 'Compass', 2023, 3, 3, 9000, 'Disponível'), -- 11
('IJK4L56', '23456789012', 'Fiat', 'Mobi', 2022, 1, 3, 20000, 'Locado'), -- 12 (Locado)
('LMÑ7O89', '34567890123', 'Mercedes', 'C180', 2024, 4, 3, 500, 'Disponível'), -- 13
('OPQ0R12', '45678901234', 'VW', 'Polo', 2023, 1, 3, 12000, 'Disponível'), -- 14
-- Brasília (Filial 4)
('RST3U45', '56789012345', 'VW', 'T-Cross', 2023, 3, 4, 11000, 'Disponível'), -- 15
('UVW6X78', '67890123456', 'Fiat', 'Cronos', 2022, 2, 4, 25000, 'Disponível'), -- 16
('XYZ9A01', '78901234567', 'Fiat', 'Argo', 2023, 1, 4, 18000, 'Disponível'), -- 17
('BCE2D34', '89012345678', 'VW', 'Jetta', 2020, 2, 4, 60000, 'Disponível'), -- 18
('DFG5H67', '90123456789', 'Jeep', 'Commander', 2024, 3, 4, 500, 'Locado'), -- 19 (Locado)
('HIJ8K90', '01234567890', 'Audi', 'A4', 2023, 4, 2, 9000, 'Disponível'); -- 20 (Filial 2)

-- 5. CLIENTES (>= 8)
INSERT INTO CLIENTE (nome, cpf, email, telefone) VALUES
('Carlos Mendes', '55566677788', 'carlos.m@mail.com', '11988887777'), -- 1
('Luciana Santos', '66677788899', 'lu.santos@mail.com', '21977776666'), -- 2
('Ricardo Almeida', '77788899900', 'ricardo.a@mail.com', '31966665555'), -- 3
('Fernanda Lima', '88899900011', 'fe.lima@mail.com', '61955554444'), -- 4
('Guilherme Pires', '99900011122', 'gui.pires@mail.com', '11944443333'), -- 5
('Juliana Paes', '00011122233', 'ju.paes@mail.com', '21933332222'), -- 6
('Márcio Braga', '10120230340', 'marcio.braga@mail.com', '31922221111'), -- 7
('Teresa Silva', '20230340450', 'teresa.silva@mail.com', '61911110000'); -- 8

-- 6. RESERVAS (>= 12)
-- Clientes: 1-Carlos (SP), 2-Luciana (RJ), 3-Ricardo (BH), 4-Fernanda (DF)
-- Veículos: 1-Mobi, 3-Renegade, 7-Corolla (Locado), 11-Compass
-- Filiais: 1-SP, 2-RJ, 3-BH
INSERT INTO RESERVA (idCliente, idVeiculo, idFilialRetirada, idFilialDevolucaoPrev, dtInicioPrev, dtFimPrev, valorDiariaBase, idFuncReserva) VALUES
-- Locações concluídas (passado)
(1, 1, 1, 1, '2025-10-01', '2025-10-05', 80.00, 1), -- R1 - SP/SP, 5 dias, Mobi (Econômico)
(2, 7, 2, 2, '2025-10-10', '2025-10-13', 120.00, 3), -- R2 - RJ/RJ, 4 dias, Corolla (Sedan)
(3, 11, 3, 1, '2025-10-20', '2025-10-22', 180.00, 4), -- R3 - BH/SP, 3 dias, Compass (SUV)
(4, 3, 1, 4, '2025-10-25', '2025-10-30', 180.00, 2), -- R4 - SP/BSB, 6 dias, Renegade (SUV)
-- Locações em andamento (locado)
(5, 2, 1, 2, '2025-11-25', '2025-11-28', 120.00, 1), -- R5 - SP/RJ, 4 dias, HB20S (Sedan) -> idVeiculo 2, status 'Locado'
(6, 7, 2, 1, '2025-11-20', '2025-12-01', 120.00, 3), -- R6 - RJ/SP, 12 dias, Corolla (Sedan) -> idVeiculo 7, status 'Locado' (Ainda locado)
-- Reservas futuras/sem locação
(1, 1, 1, 1, '2025-12-10', '2025-12-15', 80.00, 2), -- R7
(2, 9, 2, 2, '2025-12-20', '2025-12-22', 80.00, 3), -- R8
(3, 14, 3, 3, '2026-01-05', '2026-01-10', 80.00, 4), -- R9
(4, 15, 4, 4, '2026-01-15', '2026-01-20', 180.00, 1), -- R10
(5, 18, 1, 2, '2026-02-01', '2026-02-05', 120.00, 2), -- R11
(8, 1, 1, 2, '2026-02-10', '2026-02-15', 80.00, 1); -- R12

-- 7. LOCACOES (>= 10)
-- 7a. Baseadas em RESERVAS (R1, R2, R3, R4, R5, R6)
-- R1 - Concluída e no prazo
INSERT INTO LOCACAO (idReserva, idCliente, idVeiculo, idFuncRetirada, idFilialRetirada, dtRetirada, kmRetirada, idFilialDevolucao, dtDevolucao, kmDevolucao, valorDiaria, taxas, multa, valorFinal) VALUES
(1, 1, 1, 1, 1, '2025-10-01 10:00:00', 5000, 1, '2025-10-05 09:30:00', 5500, 80.00, 10.00, 0.00, (80.00 * 4) + 10.00), -- 1 (4 dias)

-- R2 - Concluída, multa por atraso (devolveu dia 14/10, fim previsto 13/10)
(2, 2, 7, 3, 2, '2025-10-10 14:00:00', 10000, 2, '2025-10-14 10:00:00', 11000, 120.00, 20.00, (120.00 * 0.5), (120.00 * 4) + 20.00 + (120.00 * 0.5)), -- 2 (4 dias + 1 multa)

-- R3 - Concluída, sem multa
(3, 3, 11, 4, 3, '2025-10-20 09:00:00', 9000, 1, '2025-10-22 18:00:00', 9400, 180.00, 30.00, 0.00, (180.00 * 2) + 30.00), -- 3 (2 dias)

-- R4 - Concluída, sem multa (devolveu dia 29/10, fim previsto 30/10)
(4, 4, 3, 2, 1, '2025-10-25 11:00:00', 8000, 4, '2025-10-29 11:00:00', 8900, 180.00, 0.00, 0.00, (180.00 * 4)), -- 4 (4 dias)

-- R5 - EM ANDAMENTO (dtDevolucao NULL)
(5, 5, 2, 1, 1, '2025-11-25 09:00:00', 15000, NULL, NULL, NULL, 120.00, 15.00, 0.00, NULL), -- 5 (Ainda locado)

-- R6 - EM ANDAMENTO (dtDevolucao NULL)
(6, 6, 7, 3, 2, '2025-11-20 10:00:00', 11000, NULL, NULL, NULL, 120.00, 10.00, 0.00, NULL); -- 6 (Ainda locado)

-- 7b. Locações de Balcão (idReserva NULL)
-- Balcão 1 - Concluída
INSERT INTO LOCACAO (idReserva, idCliente, idVeiculo, idFuncRetirada, idFilialRetirada, dtRetirada, kmRetirada, idFilialDevolucao, dtDevolucao, kmDevolucao, valorDiaria, taxas, multa, valorFinal) VALUES
(NULL, 7, 13, 4, 3, '2025-11-01 10:00:00', 500, 3, '2025-11-03 10:00:00', 800, 350.00, 50.00, 0.00, (350.00 * 2) + 50.00), -- 7 (2 dias)

-- Balcão 2 - Concluída
(NULL, 8, 1, 1, 1, '2025-11-10 14:00:00', 5500, 1, '2025-11-11 14:00:00', 5600, 80.00, 5.00, 0.00, (80.00 * 1) + 5.00), -- 8 (1 dia)

-- Balcão 3 - Concluída com atraso
(NULL, 1, 14, 2, 3, '2025-11-15 08:00:00', 12000, 3, '2025-11-18 10:00:00', 12500, 80.00, 10.00, (80.00 * 0.5), (80.00 * 3) + 10.00 + (80.00 * 0.5)), -- 9 (3 dias + 1 multa - Atraso de 2 horas considerado 1 dia de multa)

-- Balcão 4 - EM ANDAMENTO (dtDevolucao NULL)
(NULL, 7, 19, 4, 4, '2025-11-28 15:00:00', 500, NULL, NULL, NULL, 180.00, 20.00, 0.00, NULL); -- 10 (Ainda locado)
-- Atualizar status dos veículos locados no Balcão
UPDATE VEICULO SET status = 'Locado' WHERE idVeiculo IN (19);