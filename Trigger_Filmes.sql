-- APÓS A EXECUÇÃO DO PRIMEIRO CÓDIGO REALIZE O SEGUNDO EXEMPLO;
## ETAPA 1:
-- Neste exemplo considere a seguinte tabela que armazena dados de filmes:

CREATE TABLE Filmes(
id INT AUTO_INCREMENT PRIMARY KEY,
titulo	VARCHAR(60),
minutos  INT
);

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
   
  