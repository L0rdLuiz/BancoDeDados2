CREATE TABLE Funcionario (ID serial primary key, nome text, salario numeric (10,2));


CREATE TABLE Funcionario_log (ID serial primary key,id_funcionario int, novo_salario numeric (10,2), data_alteracao TIMESTAMPTZ NOT NULL DEFAULT now());

insert into Funcionario (nome, salario)
values ('saldanha', 1000)
	   ,('maria', 10000)
	   ,('jorge', 5000)

select * from funcionario

select * from funcionario_log

CREATE OR REPLACE FUNCTION f_log_func() 
RETURNS TRIGGER AS $$ 
BEGIN 
  INSERT INTO Funcionario_log      (id_funcionario, novo_salario, data_alteracao, antigo_salario) 
  VALUES (new.id, new.salario, now(), old.salario); 
RETURN NEW; 
END; $$ LANGUAGE plpgsql; 


CREATE TRIGGER g_logfunc
AFTER UPDATE
ON Funcionario
FOR EACH ROW
WHEN (old.salario<>new.salario)
EXECUTE FUNCTION f_log_func();

update Funcionario set salario = 1500 where id = 1

select fl.id, f.nome, fl.novo_salario, fl.data_alteracao
from funcionario_log fl inner join funcionario f on (f.id = fl.id_funcionario)

alter table Funcionario_log add column antigo_salario numeric
