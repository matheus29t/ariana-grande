CREATE DATABASE ariana;
USE ariana;

CREATE TABLE pessoa(
    cpf VARCHAR(20),
    nome VARCHAR(60) NOT NULL,
    end_rua VARCHAR(60),
    end_bairro VARCHAR(30),
    end_cep VARCHAR(15),
    CONSTRAINT pk_pessoa PRIMARY KEY (cpf)
)

CREATE TABLE telefone(
    cpf VARCHAR(20),
    telefone VARCHAR(15),
    CONSTRAINT pk_telefone PRIMARY KEY (cpf, telefone)
)

CREATE TABLE cliente_matricula(
    cpf VARCHAR(20),
    frequencia INT(5) DEFAULT 0,
    plano_saude VARCHAR(20),
    data_renovacao DATE NOT NULL,
    plano_tipo VARCHAR(20) NOT NULL,
    conta_bancaria INT(15),
    fk_academia VARCHAR(20) NOT NULL,
    CONSTRAINT pk_cliente_matricula PRIMARY KEY (cpf),
    CONSTRAINT fk_cliente_matricula FOREIGN KEY (cpf) REFERENCES pessoa(cpf)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_academia FOREIGN KEY (fk_academia) REFERENCES academia(cnpj)
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

CREATE TABLE funcionario(
    cpf VARCHAR(20),
    funcao VARCHAR(20) NOT NULL,
    salario INT(13) NOT NULL,
    CONSTRAINT pk_funcionario  PRIMARY KEY (cpf),
    CONSTRAINT fk_funcionario FOREIGN KEY (cpf) REFERENCES pessoa(cpf)
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

CREATE TABLE academia(
    cnpj VARCHAR(20),
    nome VARCHAR(60) NOT NULL,
    conta_deposito INT(15) NOT NULL,
    end_rua VARCHAR(60),
    end_bairro VARCHAR(30),
    end_cep VARCHAR(15),
    CONSTRAINT pk_academia PRIMARY KEY (cnpj)
)

CREATE TABLE parcelas(
    cpf VARCHAR(20),
    codigo INT(8),
    valor INT(8) NOT NULL,
    data_ DATE NOT NULL DEFAULT SELECT getdate(),
    forma_pagamento VARCHAR(20) NOT NULL,
    CONSTRAINT pk_parcelas PRIMARY KEY (cpf, codigo),
    CONSTRAINT fk_parcelas FOREIGN KEY cpf REFERENCES cliente_matricula(cpf)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)

CREATE TABLE avaliacao(
    id_avaliacao INT(15),
    data_realizacao DATE NOT NULL DEFAULT SELECT getdate(),
    gordura_corporal INT(7) NOT NULL,
    massa_muscular INT(7) NOT NULL,
    peso INT(8) NOT NULL,
    altura INT(8) NOT NULL,
    CONSTRAINT pk_avaliacao PRIMARY KEY (id_avaliacao),
)

CREATE TABLE acompanha(
    id_cliente_matricula VARCHAR(20),
    id_funcionario VARCHAR(20),
    CONSTRAINT pk_companha PRIMARY KEY (id_cliente_matricula, id_funcionario),
    CONSTRAINT fk1_acompanha FOREIGN KEY id_cliente_matricula REFERENCES cliente_matricula(cpf)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk2_acompanha FOREIGN KEy id_funcioanrio REFERENCES funcionario(cpf)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)

CREATE TABLE avalia(
    id_funcionario VARCHAR(20),
    id_avaliacao VARCHAR(20),
    id_cliente_matricula VARCHAR(20) NOT NUll,
    CONSTRAINT pk_avalia PRIMARY KEY (id_funcionario, id_avaliacao)
    CONSTRAINT fk1_avalia FOREIGN KEY id_funcioanrio REFERENCES funcionario(cpf)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk2_avalia FOREIGN KEY id_avaliacao REFERENCES avaliacao(id_avaliacao)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk3_avalia FOREIGN KEY id_cliente_matricula REFERENCES cliente_matricula(cpf)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)

CREATE TABLE gerencia(
    gerenciador VARCHAR(20),
    gerenciado VARCHAR(20),
    CONSTRAINT pk_gerencia PRIMARY KEY (gerenciador, gerenciado),
    CONSTRAINT fk1_gerencia FOREIGN KEY gerenciador REFERENCES funcionario(cpf)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk2_gerencia FOREIGN KEy gerenciado REFERENCES funcionario(cpf)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)