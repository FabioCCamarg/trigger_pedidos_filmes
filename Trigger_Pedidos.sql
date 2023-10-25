-- REPRODUZA O PRIMEIRO CÓDIGO SUGERIDO NO MYSQL WORKBENCH;
-- EXECUTE AS ETAPAS E VERIFIQUE SEUS RESULTADOS;

## ETAPA 1:
-- Criação das Tabelas e Dados de Exemplo:

CREATE TABLE Pedidos(
IDPedido INT AUTO_INCREMENT PRIMARY KEY,
DataPedido DATETIME,
NomeCliente VARCHAR(100)
);

INSERT INTO Pedidos(DataPedido, NomeCliente) VALUES
(NOW(), 'Cliente 1'),
(NOW(),'Cliente 2'),
(NOW(),	'Cliente 3');
## ETAPA 2
-- Criação de TRIGGER
DELIMITER $
CREATE TRIGGER RegistroDataCriacaoPedido
BEFORE INSERT ON Pedidos
FOR EACH ROW
BEGIN
	SET NEW.DataPedido = NOW();
END;
$
DELIMITER ; 
## ETAPA 3:
-- Teste da Trigger:
-- Inserção de um novo Registro na tabela "Pedidos" sem fornecer a data
INSERT INTO Pedidos (NomeCliente) VALUES ('NOVO CLIENTE');

-- Consulta para verificar os resultados
SELECT * FROM Pedidos;


   