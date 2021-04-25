-- selecionar por bairro as academias que tem mais de um cliente matriculado
-- GROUP BY/HAVING
SELECT P.end_bairro, ACAD.nome, COUNT(*) AS Quantidade
FROM cliente_matricula CM, pessoa P, academia ACAD
WHERE CM.cpf = P.cpf AND fk_academia = cnpj
GROUP BY P.end_bairro, ACAD.nome
HAVING COUNT(*) > 0;

-- selecionar o nome e a função de cada funcionario
-- INNER JOIN
SELECT nome, funcao
FROM pessoa P INNER JOIN funcionario F ON P.cpf = F.cpf;

-- selecionar o nome e telefone de todos os clientes ou funcionarios
-- OUTER JOIN
SELECT P.nome, telefone
FROM pessoa P
LEFT OUTER JOIN telefone T ON P.cpf = T.cpf;

-- semi-junção
-- selecionar os cpfs dos clientes que pagam com o cartao de credito
SELECT CM.cpf
FROM cliente_matricula CM
WHERE EXISTS (SELECT *
              FROM parcelas P
              WHERE CM.cpf = P.cpf AND P.forma_pagamento = 'Cartão de Crédito');

-- selecionar nome das pessoas que nao tem telefone cadastrado
-- anti-junção
SELECT P.nome
FROM pessoa P
WHERE P.cpf NOT IN ( SELECT cpf 
                     FROM telefone T);

-- selecionar as academias em que a media de gordura corporal é maior do 15%
-- subconsulta escalar
SELECT ACAD.nome
FROM academia ACAD
WHERE ( SELECT AVG(gordura_corporal) 
        FROM cliente_matricula CM, avaliacao AV, avalia A
        WHERE CM.cpf = A.id_cliente_matricula 
              AND AV.id_avaliacao = A.id_avaliacao 
              AND CM.fk_academia = ACAD.cnpj ) > 15
;

-- selecionar os cpfs dos clientes que frequentam a mesma academia
-- e tenham a mesma forma de pagamento do cliente com cpf dado
-- subconsulta do tipo linha
SELECT CM.cpf
FROM cliente_matricula CM
WHERE (CM.fk_academia, CM.plano_tipo) = (SELECT CMR.fk_academia, CMR.plano_tipo
                                         FROM cliente_matricula CMR
                                         WHERE CMR.cpf = '81335003529')
;

-- selecionar todos os clientes que tem a frquencia maior do que a media
-- subconsulta do tipo tabela
SELECT CM.cpf
FROM cliente_matricula CM
WHERE CM.cpf IN (SELECT CMF.cpf
                 FROM cliente_matricula CMF
                 WHERE CMF.frequencia > (SELECT AVG(frequencia)
                                         FROM cliente_matricula))
;
-- selecionar todos os cep das pessoas e das academias
-- operação de conjunto 
SELECT P.end_cep AS CEP, 'pessoa' AS TIPO
FROM pessoa P
UNION
SELECT A.end_cep AS CEP, 'academia' AS TIPO
FROM academia A
;


------------------------------------------------------------------------------------------------

--Procedimento
--Dado um CPF, retorna o nome
CREATE OR REPLACE PROCEDURE print_nome(cpf_aux VARCHAR) IS
nome_aux VARCHAR(60);

BEGIN
    SELECT P.nome INTO nome_aux
    FROM pessoa P
    WHERE p.cpf = cpf_aux;

    dbms_output.put_line(nome_aux);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('CPF não encontrado.');

END;


BEGIN
print_nome('03176487532');
END;


--------------------------

--Funcao
--Dado um CPF, retorna o cargo de um funcionário
CREATE OR REPLACE FUNCTION get_funcao(cpf_aux VARCHAR) RETURN VARCHAR IS
funcao_aux VARCHAR(20);

BEGIN
    SELECT F.funcao INTO funcao_aux
    FROM funcionario F
    WHERE F.cpf = cpf_aux;

    RETURN funcao_aux;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RETURN 'Funcionário não Cadastrado.';
END;


BEGIN
dbms_output.put_line('Cargo: ' || get_funcao('03176487532'));
END;


--------------------------

--Procedimento
--Retorna o nome das pessoas que vivem em um bairro especifico
CREATE OR REPLACE PROCEDURE onde_vives(bairro VARCHAR) IS 
CURSOR lista_nomes IS 
    SELECT nome
    FROM pessoa
    WHERE end_bairro = bairro;

nomeaux VARCHAR(30);

BEGIN
    OPEN lista_nomes;
        LOOP
            FETCH lista_nomes INTO nomeaux;
            EXIT WHEN lista_nomes%NOTFOUND;
            dbms_output.put_line('nome: ' || nomeaux);
        END LOOP;
    CLOSE lista_nomes;
END;


BEGIN
onde_vives('Bairro das Chagas');
END;


--------------------------

--Gatilho
--indica quando uma nova academia é registrada
CREATE OR REPLACE TRIGGER indicador_academia
AFTER INSERT ON academia
REFERENCING NEW AS ACAD

FOR EACH ROW
BEGIN 
    dbms_output.put_line('A academia ' || :ACAD.nome || ' foi registrada!');
END;


INSERT INTO academia
VALUES('159432258746', 'SolyMariaFIT', 569549682, 'Rua das Flores', ' Bairro das Laranjeiras', '48192366');