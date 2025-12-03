USE locadora_veiculos;

-- 1. UPDATE: Correção de Cadastro (Cliente)
-- CENÁRIO: O e-mail do cliente 'Carlos Mendes' está incorreto no sistema.
UPDATE CLIENTE
SET email = 'carlos.mendes.novo@mail.com'
WHERE idCliente = 1;
-- Comentário: Correção de erro de digitação no cadastro do cliente.

-- 2. UPDATE: Cancelamento de Reserva
-- CENÁRIO: O cliente 'Luciana Santos' (id=2) decidiu cancelar a reserva futura (R8).
UPDATE RESERVA
SET statusReserva = 'Cancelada'
WHERE idReserva = 8;
-- Comentário: Cancelamento de uma reserva futura antes da retirada do veículo.

-- 3. UPDATE: Baixa de Veículo
-- CENÁRIO: O veículo 'Fiat Uno' (id=5) sofreu perda total e deve ser baixado.
UPDATE VEICULO
SET status = 'Baixado', idFilialAtual = 1 -- Mantém na filial de registro
WHERE idVeiculo = 5;
-- Comentário: Atualização do status do veículo para 'Baixado' devido à perda total, removendo-o da frota disponível.

-- 4. DELETE: Remover logs de auditoria antigos (usando tabela de exemplo)
-- CENÁRIO: Logs de auditoria com mais de 1 ano devem ser removidos para liberar espaço.
-- Inserindo um log de exemplo antigo para demonstrar o DELETE.
INSERT INTO LOG_AUDITORIA (dtAcao, usuario, tabelaAfetada) VALUES ('2024-01-01 12:00:00', 'Sistema', 'LOCACAO');

DELETE FROM LOG_AUDITORIA
WHERE dtAcao < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
-- Comentário: Remoção de registros de auditoria obsoletos, melhorando o desempenho da tabela.