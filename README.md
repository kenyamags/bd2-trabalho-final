# bd2-trabalho-final
A Descrição do Domínio do projeto Sistema de Locação de Veículos
   O principal objetivo do sistema é gerenciar todas as etapas do ciclo de vida de uma locação de veículos, desde a administração da frota e cadastro de clientes até a precificação e conclusão financeira das transações.

   O domínio simula a operação de uma locadora que atua em múltiplas cidades, utilizando uma estrutura de filiais para gerenciar os atendimentos e a localização física dos veículos.

2. Entidades Principais e Fluxo Operacional
O sistema opera em torno de três pilares: a Frota, os Clientes e as Transações.

A. Gestão da Frota
Veículos são classificados em diferentes Categorias (Econômico, SUV, etc.), cada uma com uma valorDiariaPadrao.

Cada veículo está sempre vinculado a uma Filial Atual, indicando sua localização para retirada ou devolução.

O sistema precisa rastrear o status do veículo (Disponível, Locado, Manutenção) para garantir que apenas carros disponíveis possam ser reservados ou locados.

(Bônus) O sistema também registra o Histórico de Manutenções para gerenciar a saúde da frota.

B. Gestão de Pessoas e Locais
Clientes são o centro das transações, responsáveis por Reservas e Locações.

Funcionários são registrados e associados a uma Filial específica, sendo responsáveis pela execução dos processos (retirada e devolução).

Filiais representam as unidades operacionais, sendo essenciais para determinar os pontos de retirada e devolução.

C. O Ciclo da Locação (Transações)
Reserva: O cliente manifesta a intenção de locar um veículo em um período pretendido (dtInicioPrev, dtFimPrev) e define a Filial de Retirada e Devolução Prevista. A reserva garante a disponibilidade do veículo naquele período.

Locação: É o contrato efetivo que nasce a partir de uma Reserva (ou pode ser direta).

Registra os dados reais de Retirada (data/hora/km) e, posteriormente, de Devolução (data/hora/km, filial real).

Precificação: No momento da devolução (processado pela PROCEDURE), o sistema realiza o cálculo financeiro:

Valor Total = (Valor Diária x Dias Reais) + Taxas + Multa por Atraso.

A Multa é calculada por uma FUNCTION se a devolução real (dtDevolucao) for posterior à data prevista na Reserva (dtFimPrev).

3. Requisitos de Relatórios e Integridade
O sistema deve fornecer relatórios essenciais para a gestão do negócio:

Faturamento: Cálculos de SUM, MAX, MIN e agrupamentos (GROUP BY) para analisar o desempenho financeiro por período, filial ou categoria.

Utilização da Frota: Indicadores para medir a ocupação dos veículos (vw_utilizacao_frota).
Ordem de Execução dos Scripts SQL
Para garantir a correta criação, povoamento e funcionamento de todos os objetos do banco de dados (tabelas, views, procedures e functions), os scripts devem ser executados na seguinte ordem lógica.

A integridade dos dados é garantida por PKs, FKs e Restrições (CHECK, UNIQUE), assegurando que as transações e o inventário da frota sejam sempre consistentes.
01_ddl_create.sql	Criação de todas as tabelas, PKs, FKs e índices básicos.
02_ddl_alter.sql	Execução dos comandos ALTER TABLE (ex: adicionar quilometragemRevisao).
03_dml_insert.sql	INSERT de Filiais, Categorias, Clientes, Funcionários, Veículos, Reservas e Locações.
04_dml_update_delete.sql	UPDATE e DELETE de dados existentes (ex: correção de cadastro, cancelamento de reserva).
05_queries_select.sql	SELECTs com JOIN, agregações, CASE, subconsultas, e os testes de validação (incluindo o teste da PROCEDURE e da FUNCTION).
06_view.sql	Criação das VIEWS (vw_faturamento_mensal, vw_utilizacao_frota).
07_procedure_function.sql	Criação da FUNCTION (calcular_multa_atraso) e da PROCEDURE (registrar devolução), que utiliza a FUNCTION.

Dependências e Configurações
Para executar o sistema de locação de veículos projetado, você precisará atender às seguintes dependências e garantir algumas configurações básicas no ambiente de banco de dados.
Dependências de SoftwareDependênciaVersão SugeridaFinalidadeSGBDMySQL 8.0+O código SQL (DDL, DML, Objetos) foi escrito em MySQL puro. Versões recentes (8.x) garantem suporte completo aos recursos utilizados, como DATETIME, ENUM, PROCEDURE e FUNCTION.Cliente SQLMySQL Workbench, DBeaver, HeidiSQL, ou linha de comando (mysql -u...).Necessário para conectar-se ao servidor MySQL, criar o banco de dados e executar os scripts.

Glossário das Tabelas e Campos
Aqui está o glossário das tabelas propostas para o sistema de locação de veículos, detalhando a finalidade e os campos principais de cada uma.
CLIENTE Armazena os dados cadastrais dos clientes que realizam reservas e locações.CampoTipoDescriçãoRestriçõesidClienteINTIdentificador único do cliente.PK, AUTO_INCREMENTnomeVARCHAR(150)Nome completo do cliente.NOT NULLcpfCHAR(11)Cadastro de Pessoa Física.NOT NULL, UNIQUEemailVARCHAR(100)Endereço de e-mail.UNIQUEtelefoneVARCHAR(15)Telefone de contato.dtCadastroDATETIMEData e hora do cadastro do cliente.NOT NULL, DEFAULT CURRENT_TIMESTAMP
FUNCIONARIO Armazena os dados cadastrais dos funcionários que operam o sistema.CampoTipoDescriçãoRestriçõesidFuncINTIdentificador único do funcionário.PK, AUTO_INCREMENTnomeVARCHAR(150)Nome completo do funcionário.NOT NULLcpfCHAR(11)Cadastro de Pessoa Física.NOT NULL, UNIQUEemailVARCHAR(100)Endereço de e-mail.UNIQUEidFilialINTFilial onde o funcionário está alocado.NOT NULL, FK (FILIAL)
FILIAL Armazena as unidades físicas da locadora onde são realizadas retiradas e devoluções de veículos.CampoTipoDescriçãoRestriçõesidFilialINTIdentificador único da filial.PK, AUTO_INCREMENTnomeVARCHAR(80)Nome popular da filial (ex: Filial Centro).NOT NULLcidadeVARCHAR(80)Cidade onde a filial está localizada.NOT NULLufCHAR(2)Unidade Federativa (Estado).NOT NULL
CATEGORIA Define os tipos de veículos disponíveis para locação (ex: Econômico, SUV).CampoTipoDescriçãoRestriçõesidCategoriaINTIdentificador único da categoria.PK, AUTO_INCREMENTnomeVARCHAR(40)Nome da categoria (ex: Luxo).NOT NULLdescricaoVARCHAR(255)Breve descrição da categoria.valorDiariaPadraoDECIMAL(10,2)Valor base da diária de locação para esta categoria.NOT NULL, CHECK (> 0) (Bônus)
VEICULO Armazena os dados de cada carro pertencente à frota da locadora.CampoTipoDescriçãoRestriçõesidVeiculoINTIdentificador único do veículo.PK, AUTO_INCREMENTplacaVARCHAR(10)Placa de identificação do veículo.NOT NULL, UNIQUErenavamVARCHAR(15)Registro Nacional de Veículos Automotores.UNIQUEmarcaVARCHAR(50)Fabricante do veículo (ex: Fiat, Ford).NOT NULLmodeloVARCHAR(50)Modelo do veículo (ex: Palio, Fiesta).NOT NULLanoINTAno de fabricação.NOT NULLidCategoriaINTCategoria a que o veículo pertence.NOT NULL, FK (CATEGORIA)idFilialAtualINTFilial onde o veículo está fisicamente.NOT NULL, FK (FILIAL)statusENUMSituação atual (Ex: 'Disponível', 'Locado', 'Manutenção', 'Baixado').NOT NULLquilometragemRevisaoINTQuilometragem na qual a próxima revisão é devida.(Adicionado no ALTER TABLE)
 RESERVA Registra a intenção de locação de um cliente, com datas e locais previstos.CampoTipoDescriçãoRestriçõesidReservaINTIdentificador único da reserva.PK, AUTO_INCREMENTidClienteINTCliente que realizou a reserva.NOT NULL, FK (CLIENTE)idVeiculoINTVeículo reservado.NOT NULL, FK (VEICULO)idFilialRetiradaINTFilial prevista para a retirada do veículo.NOT NULL, FK (FILIAL)idFilialDevolucaoPrevINTFilial prevista para a devolução.NOT NULL, FK (FILIAL)dtInicioPrevDATETIMEData e hora prevista para a retirada.NOT NULLdtFimPrevDATETIMEData e hora prevista para a devolução.NOT NULLstatusReservaENUMSituação (Ex: 'Confirmada', 'Cancelada', 'Em Locação', 'Concluída').NOT NULL
 LOCACAO Registra o contrato de locação em si, incluindo todos os valores e dados reais de retirada/devolução.CampoTipoDescriçãoRestriçõesidLocacaoINTIdentificador único da locação.PK, AUTO_INCREMENTidReservaINTReserva que deu origem a esta locação.UNIQUE, FK (RESERVA)idClienteINTCliente responsável pela locação.NOT NULL, FK (CLIENTE)idVeiculoINTVeículo locado.NOT NULL, FK (VEICULO)idFilialRetiradaINTFilial onde o carro foi retirado.NOT NULL, FK (FILIAL)dtRetiradaDATETIMEData e hora real da retirada.NOT NULLkmRetiradaINTQuilometragem do veículo no momento da retirada.NOT NULLidFilialDevolucaoINTFilial onde o carro foi devolvido.FK (FILIAL)dtDevolucaoDATETIMEData e hora real da devolução.kmDevolucaoINTQuilometragem do veículo no momento da devolução.CHECK (>= kmRetirada) (Bônus)valorDiariaDECIMAL(10,2)Valor real da diária aplicada na locação.NOT NULLtaxasDECIMAL(10,2)Valores extras (seguro, acessórios, etc.).NOT NULL, DEFAULT 0.00multaDECIMAL(10,2)Multa por atraso na devolução.NOT NULL, DEFAULT 0.00valorFinalDECIMAL(10,2)Total calculado da locação (Diárias + Taxas + Multa).
 
 Decisões de Modelagem (Modelo Lógico e Físico)
Aqui estão as principais decisões de modelagem tomadas para estruturar o banco de dados do sistema de locação de veículos, conforme solicitado no exercício.
Separação de RESERVA e LOCACAO (Chave de Modelagem)
Esta é a decisão mais crucial do modelo e atende diretamente ao requisito de rastrear o ciclo completo da transação.

Entidades Separadas:

RESERVA: Captura a intenção (o que deveria acontecer). Contém as datas e filiais previstas (dtInicioPrev, dtFimPrev).

LOCACAO: Captura a execução (o que realmente aconteceu). Contém as datas e quilometragens reais (dtRetirada, kmRetirada, dtDevolucao, kmDevolucao).

Relacionamento: RESERVA 1 — 0..1 LOCACAO. Uma Locação nasce de uma Reserva, mas nem toda Reserva vira uma Locação (pode ser cancelada). Isso é imposto pela Foreign Key e a restrição UNIQUE em idReserva dentro da tabela LOCACAO.

Vantagem: Permite o cálculo preciso da multa por atraso pela PROCEDURE ao comparar o dtDevolucao (real, na LOCACAO) com o dtFimPrev (previsto, na RESERVA).
Gerenciamento da Localização do Veículo
Para rastrear onde o carro está, a localização foi modelada em dois pontos distintos:

VEICULO.idFilialAtual: É uma Foreign Key na tabela VEICULO que aponta para a FILIAL.

Propósito: Indica a localização física atual do veículo. Este campo é atualizado pela PROCEDURE após a devolução.

RESERVA/LOCACAO Filiais:

A transação registra a idFilialRetirada e a idFilialDevolucao (real ou prevista).

Propósito: Registra o histórico da transação e permite locações one-way (devolução em filial diferente da retirada).
Uso de Categorias para Precificação
A precificação básica foi centralizada e normalizada:

CATEGORIA: Entidade separada para evitar redundância. Armazena o valorDiariaPadrao.

VEICULO: Relaciona-se 1-N com CATEGORIA.

LOCACAO.valorDiaria: Este campo é capturado no momento da retirada.

Decisão: Embora o valor padrão esteja na CATEGORIA, ele é copiado para a LOCACAO. Isso permite que o valor da diária seja alterado no futuro na tabela CATEGORIA sem afetar o preço de locações já registradas ou em andamento. Isso segue o princípio da Imutabilidade Histórica para dados transacionais.
Estrutura de Chaves e Normalização (3FN)
Chaves Primárias (PKs): Todas as tabelas têm uma chave primária simples, geralmente um INT ou BIGINT com AUTO_INCREMENT, seguindo a prática de usar chaves substitutas para performance e flexibilidade.

Normalização (3FN): O modelo está minimamente na Terceira Forma Normal (3FN):

Não há repetição de dados desnecessária (ex: dados da cidade/UF estão apenas em FILIAL).

Todos os campos não-chave (atributos) são dependentes da chave primária (PK) e não de outros campos não-chave. (Ex: o nome do funcionário depende do idFunc, não do idFilial).

Índices Secundários (Físico): A decisão de criar índices UNIQUE em campos de busca essenciais (CLIENTE.cpf, VEICULO.placa) garante a integridade dos dados e acelera as buscas.

Autoria:Kênya Magalhães
Disciplina:Banco de Dados II - Trabalho Final
BANCO DE DADOS RELACIONAL - SISTEMA DE LOCAÇÃO DE VEÍCULOS - MYSQL
