USE locadora_veiculos;

-- 1. ALTER TABLE: Adicionar campo para controlar a próxima revisão
-- CENÁRIO: A empresa implementou uma política de manutenção preventiva a cada 10.000km rodados.
-- É necessário um campo para registrar a quilometragem para a próxima revisão.
ALTER TABLE VEICULO
ADD COLUMN kmProximaRevisao INT AFTER kmAtual;

-- 2. ALTER TABLE: Aumentar o tamanho do campo 'descricao' da categoria
-- CENÁRIO: O campo 'descricao' na tabela CATEGORIA está muito pequeno para descrições detalhadas dos benefícios de cada categoria.
ALTER TABLE CATEGORIA
MODIFY COLUMN descricao VARCHAR(500);

-- 3. ALTER TABLE: Adicionar registro do funcionário na reserva (Para rastreamento e auditoria)
-- CENÁRIO: É necessário saber qual funcionário efetuou a reserva no sistema.
ALTER TABLE RESERVA
ADD COLUMN idFuncReserva INT AFTER idCliente,
ADD CONSTRAINT fk_reserva_func FOREIGN KEY (idFuncReserva) REFERENCES FUNCIONARIO(idFunc);


USE locadora_veiculos;

-- DROP VIEW: Excluir uma VIEW antiga.
-- CENÁRIO: Uma visão antiga 'vw_veiculos_baixados_antigo' será substituída por uma mais eficiente.
-- Comentamos a operação e, em um script de criação de objetos, a nova VIEW seria criada.
-- Nota: A VIEW não existe ainda, mas esta é a sintaxe de demonstração.
-- DROP VIEW IF EXISTS vw_veiculos_baixados_antigo;

-- Se necessário, podemos usar uma VIEW real para demonstração:
CREATE VIEW vw_veiculos_baixados_antigo AS
SELECT idVeiculo, placa, modelo FROM VEICULO WHERE status = 'Baixado' AND ano < 2010;

DROP VIEW vw_veiculos_baixados_antigo;
-- Comentário: VIEW removida pois a lógica de negócio para veículos baixados foi alterada.

-- TRUNCATE TABLE: Limpar uma tabela de logs ou staging.
-- CENÁRIO: A tabela 'LOG_ACESSO' (exemplo, não implementada) armazena logs temporários de acesso que precisam ser resetados a cada semana. 
-- TRUNCATE TABLE é usado para remover *todos* os registros de forma rápida, mantendo a estrutura da tabela.
-- Para o exercício, usaremos a tabela MANUTENCAO como exemplo de tabela não crítica (se os registros fossem logs de manutenção).

-- Se a tabela fosse MANUTENCAO_LOGS, seria:
-- TRUNCATE TABLE MANUTENCAO_LOGS;

-- Como não temos uma tabela de logs, vamos criar uma:
CREATE TABLE LOG_AUDITORIA (
  idLog INT PRIMARY KEY AUTO_INCREMENT,
  dtAcao DATETIME NOT NULL,
  usuario VARCHAR(100),
  tabelaAfetada VARCHAR(50)
);

-- TRUNCATE TABLE
TRUNCATE TABLE LOG_AUDITORIA;
-- Comentário: A tabela LOG_AUDITORIA foi truncada para iniciar um novo ciclo de monitoramento, garantindo que os dados sejam resetados mensalmente para fins de desempenho e conformidade com o volume de dados.


