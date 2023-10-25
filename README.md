# EXERCÍCIOS BANCO DE DADOS  
## Descrição

-- REPRODUZA O PRIMEIRO CÓDIGO SUGERIDO NO MYSQL WORKBENCH;
-- EXECUTE AS ETAPAS E VERIFIQUE SEUS RESULTADOS;

## ETAPA 1:
-- Criação das Tabelas e Dados de Exemplo:

    CREATE TABLE Pedidos(
    IDPedido INT AUTO_INCREMENT PRIMARY KEY,
    DataPedido DATETIME,
    NomeCliente VARCHAR(100)
    );

![exer1](https://raw.githubusercontent.com/FabioCCamarg/trigger_pedidos_filmes/main/exemplo_2.png)

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

![exer2](https://raw.githubusercontent.com/FabioCCamarg/trigger_pedidos_filmes/main/exemplo_5.png)

# FILMES

-- APÓS A EXECUÇÃO DO PRIMEIRO CÓDIGO REALIZE O SEGUNDO EXEMPLO;
## ETAPA 1:
-- Neste exemplo considere a seguinte tabela que armazena dados de filmes:

    CREATE TABLE Filmes(
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo	VARCHAR(60),
    minutos  INT
    );

  ![exer3](https://raw.githubusercontent.com/FabioCCamarg/trigger_pedidos_filmes/main/Filmes1.png)

## ETAPA 2: 
-- código que cria uma trigger associada a tabela Filmes:

    DELIMITER $

    CREATE TRIGGER chk_minutos before insert on Filmes
    FOR EACH ROW
    BEGIN
	    IF NEW.minutos < 0 then
		    SET	NEW.minutos = NULL;
      END IF;
     END$   
     DELIMITER ;
 
## ETAPA 3: 
 -- inserção dos itens abaixo:

    INSERT INTO Filmes (titulo,minutos) VALUES ("The Terrible trigger", 120);
    INSERT INTO Filmes (titulo,minutos) VALUES ("O alto da compadecida", 135);
    INSERT INTO Filmes (titulo,minutos) VALUES ("Faroeste Cabloco", 240);
    INSERT INTO Filmes (titulo,minutos) VALUES ("The matrix", 90);
    INSERT INTO Filmes (titulo,minutos) VALUES ("Blade runner", -88);
    INSERT INTO Filmes (titulo,minutos) VALUES ("O labirinto de fauno", 110);
    INSERT INTO Filmes (titulo,minutos) VALUES ("Metropole", 0);
    INSERT INTO Filmes (titulo,minutos) VALUES ("A lista", 120);


    select * from Filmes;



## ETAPA 4:
-- criando uma exception e a lançamos como o comando signal.

    DELIMITER $
    CREATE TRIGGER chkminutos before  insert on Filmes
    FOR EACH ROW
	    BEGIN
		    IF NEW.minutos <= 0 then
        
      -- Lançar um Erro
			    SIGNAL SQLSTATE '45000' -- exceção não tratada
			    SET MESSAGE_TEXT = "Valor inválido para minutos",
			    MYSQL_ERRNO = 2022;  -- código de erro pra controle
        END IF;
    END$
    
    DELIMITER ;


## ETAPA 5:
-- criar uma tabela de informação sobre ocorrências, conforme o código abaixo:

    CREATE TABLE Log_deletions(
    id	INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR (60),
    quando DATETIME,
    quem  VARCHAR(40)
    );

	DELIMITER $
    
    CREATE TRIGGER Log_deletions AFTER DELETE ON Filmes
		FOR EACH ROW 
        BEGIN 
			INSERT INTO Log_deletions VALUES (NULL, OLD.titulo, SYSDATE(), USER());
		END$
    DELIMITER ;
   
-- Essa trigger registrará as exclusões de registros da tabela "Filmes" na tabela "Log_deletions"
-- sempre que uma exclusão ocorrer. O registro incluirá o título do filme excluído, a data e hora
-- da exclusão e o nome de usuário que a realizou.

-- Para medida de teste podemos deletar alguns filmes e tirar um relatório da tabela
-- Log_deletions, conforme na figura abaixo:

    DELETE FROM Filmes WHERE id = 2;
    DELETE FROM Filmes WHERE id = 4;

    SELECT * FROM Log_deletions; 

![exer4](https://raw.githubusercontent.com/FabioCCamarg/trigger_pedidos_filmes/main/Filmes.png)

-- Ao realizar esse processo teremos o seguinte resultado:

    INSERT INTO Filmes (titulo,minutos) VALUES ("The Terrible trigger", 120);
    INSERT INTO Filmes (titulo,minutos) VALUES ("O alto da compadecida", 135);
    INSERT INTO Filmes (titulo,minutos) VALUES ("Faroeste Cabloco", 240);
    INSERT INTO Filmes (titulo,minutos) VALUES ("The matrix", 90);
    INSERT INTO Filmes (titulo,minutos) VALUES ("Blade runner", -88);
    INSERT INTO Filmes (titulo,minutos) VALUES ("O labirinto de fauno", 110);
    INSERT INTO Filmes (titulo,minutos) VALUES ("Metropole", 0);
    INSERT INTO Filmes (titulo,minutos) VALUES ("A lista", 120);


   SELECT * FROM Filmes;
   
![exer5](https://raw.githubusercontent.com/FabioCCamarg/trigger_pedidos_filmes/main/resultado.png)
