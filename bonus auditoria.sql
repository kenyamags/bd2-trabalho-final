CREATE TABLE AUDITORIA_LOG (
  idLog INT PRIMARY KEY AUTO_INCREMENT,
  tabelaAfetada VARCHAR(50) NOT NULL,
  idRegistroAfetado INT NOT NULL,
  operacao CHAR(1) NOT NULL COMMENT 'I: Insert, U: Update, D: Delete',
  detalhes TEXT,
  dataHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  usuario VARCHAR(100)
);

DELIMITER $$

-- Comentário: Trigger para auditar mudanças no valor da diária de uma categoria.
CREATE TRIGGER trg_before_update_categoria
BEFORE UPDATE ON CATEGORIA
FOR EACH ROW
BEGIN
    -- Verifica se o valor da diária foi alterado
    IF OLD.valorDiariaPadrao <> NEW.valorDiariaPadrao THEN
        INSERT INTO AUDITORIA_LOG (
            tabelaAfetada,
            idRegistroAfetado,
            operacao,
            detalhes
        )
        VALUES (
            'CATEGORIA',
            NEW.idCategoria,
            'U',
            CONCAT(
                'Valor Diária alterado de ',
                OLD.valorDiariaPadrao,
                ' para ',
                NEW.valorDiariaPadrao
            )
        );
    END IF;
END$$

DELIMITER ;
