-- Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS locadora_veiculos;
USE locadora_veiculos;

-- 1. Tabela FILIAL
CREATE TABLE FILIAL (
  idFilial INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(80) NOT NULL,
  cidade VARCHAR(80) NOT NULL,
  uf CHAR(2) NOT NULL,
  UNIQUE KEY uk_nome_cidade (nome, cidade) -- Índice de unicidade
);

-- 2. Tabela FUNCIONARIO
CREATE TABLE FUNCIONARIO (
  idFunc INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  cpf CHAR(11) UNIQUE NOT NULL,
  email VARCHAR(100),
  idFilial INT NOT NULL,
  dtAdmissao DATE NOT NULL,
  
  CONSTRAINT fk_func_filial FOREIGN KEY (idFilial) REFERENCES FILIAL(idFilial),
  INDEX idx_func_cpf (cpf) -- Índice para buscas por CPF
);

-- 3. Tabela CLIENTE
CREATE TABLE CLIENTE (
  idCliente INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  cpf CHAR(11) UNIQUE NOT NULL,
  email VARCHAR(100),
  telefone VARCHAR(15),
  dtCadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_cliente_cpf (cpf)
);

-- 4. Tabela CATEGORIA
CREATE TABLE CATEGORIA (
  idCategoria INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(40) UNIQUE NOT NULL,
  descricao VARCHAR(255),
  valorDiariaPadrao DECIMAL(10,2) NOT NULL CHECK (valorDiariaPadrao > 0)
);

-- 5. Tabela VEICULO
CREATE TABLE VEICULO (
  idVeiculo INT PRIMARY KEY AUTO_INCREMENT,
  placa CHAR(7) UNIQUE NOT NULL,
  renavam CHAR(11) UNIQUE NOT NULL,
  marca VARCHAR(50) NOT NULL,
  modelo VARCHAR(80) NOT NULL,
  ano YEAR NOT NULL,
  idCategoria INT NOT NULL,
  idFilialAtual INT NOT NULL,
  status ENUM('Disponível', 'Locado', 'Em Manutenção', 'Baixado') NOT NULL DEFAULT 'Disponível',
  kmAtual INT NOT NULL DEFAULT 0,
  
  CONSTRAINT fk_veiculo_categoria FOREIGN KEY (idCategoria) REFERENCES CATEGORIA(idCategoria),
  CONSTRAINT fk_veiculo_filial FOREIGN KEY (idFilialAtual) REFERENCES FILIAL(idFilial),
  INDEX idx_veiculo_placa (placa)
);

-- 6. Tabela RESERVA
CREATE TABLE RESERVA (
  idReserva INT PRIMARY KEY AUTO_INCREMENT,
  idCliente INT NOT NULL,
  idVeiculo INT, -- Pode ser NULL na reserva inicial se for por categoria, mas para este exercicio vamos assumir que o veículo é escolhido.
  idFilialRetirada INT NOT NULL,
  idFilialDevolucaoPrev INT NOT NULL,
  dtInicioPrev DATE NOT NULL,
  dtFimPrev DATE NOT NULL,
  statusReserva ENUM('Confirmada', 'Cancelada', 'Em Andamento', 'Concluída') NOT NULL DEFAULT 'Confirmada',
  valorDiariaBase DECIMAL(10,2) NOT NULL,

  CONSTRAINT fk_reserva_cliente FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente),
  CONSTRAINT fk_reserva_veiculo FOREIGN KEY (idVeiculo) REFERENCES VEICULO(idVeiculo),
  CONSTRAINT fk_reserva_retirada FOREIGN KEY (idFilialRetirada) REFERENCES FILIAL(idFilial),
  CONSTRAINT fk_reserva_devolucao FOREIGN KEY (idFilialDevolucaoPrev) REFERENCES FILIAL(idFilial),
  CHECK (dtInicioPrev <= dtFimPrev),
  INDEX idx_reserva_inicio (dtInicioPrev)
);

-- 7. Tabela LOCACAO
CREATE TABLE LOCACAO (
  idLocacao INT PRIMARY KEY AUTO_INCREMENT,
  idReserva INT UNIQUE, -- 1-0..1 RESERVA para LOCACAO (pode ser NULL para locações de balcão)
  idCliente INT NOT NULL,
  idVeiculo INT NOT NULL,
  idFuncRetirada INT,
  idFuncDevolucao INT,
  idFilialRetirada INT NOT NULL,
  dtRetirada DATETIME NOT NULL,
  kmRetirada INT NOT NULL,
  idFilialDevolucao INT, -- Preenchida na devolução
  dtDevolucao DATETIME, -- Preenchida na devolução
  kmDevolucao INT, -- Preenchida na devolução
  valorDiaria DECIMAL(10,2) NOT NULL, -- Valor efetivo da diária
  taxas DECIMAL(10,2) DEFAULT 0.00,
  multa DECIMAL(10,2) DEFAULT 0.00,
  valorFinal DECIMAL(10,2), -- Preenchida na devolução/fechamento
  
  CONSTRAINT fk_loc_reserva FOREIGN KEY (idReserva) REFERENCES RESERVA(idReserva),
  CONSTRAINT fk_loc_cliente FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente),
  CONSTRAINT fk_loc_veiculo FOREIGN KEY (idVeiculo) REFERENCES VEICULO(idVeiculo),
  CONSTRAINT fk_loc_func_ret FOREIGN KEY (idFuncRetirada) REFERENCES FUNCIONARIO(idFunc),
  CONSTRAINT fk_loc_func_dev FOREIGN KEY (idFuncDevolucao) REFERENCES FUNCIONARIO(idFunc),
  CONSTRAINT fk_loc_filial_ret FOREIGN KEY (idFilialRetirada) REFERENCES FILIAL(idFilial),
  CONSTRAINT fk_loc_filial_dev FOREIGN KEY (idFilialDevolucao) REFERENCES FILIAL(idFilial),
  CHECK (kmRetirada >= 0),
  INDEX idx_loc_dt_retirada (dtRetirada)
);

-- Tabela opcional para bônus (MANUTENCAO)
CREATE TABLE MANUTENCAO (
  idManutencao INT PRIMARY KEY AUTO_INCREMENT,
  idVeiculo INT NOT NULL,
  dtInicio DATE NOT NULL,
  dtFimPrevisto DATE,
  dtFimReal DATE,
  tipoManutencao VARCHAR(100) NOT NULL,
  custo DECIMAL(10,2),
  descricao TEXT,

  CONSTRAINT fk_manutencao_veiculo FOREIGN KEY (idVeiculo) REFERENCES VEICULO(idVeiculo),
  INDEX idx_manut_veiculo (idVeiculo)
);