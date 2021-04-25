---CREATE DATABASE ariana;
---USE ariana;

CREATE TABLE pessoa(
    cpf VARCHAR(20),
    nome VARCHAR(60) NOT NULL,
    end_rua VARCHAR(60),
    end_bairro VARCHAR(30),
    end_cep VARCHAR(15),
    CONSTRAINT pk_pessoa PRIMARY KEY (cpf)
);

CREATE TABLE telefone(
    cpf VARCHAR(20),
    telefone VARCHAR(15),
    CONSTRAINT pk_telefone PRIMARY KEY (cpf, telefone),
    CONSTRAINT fk_telefone FOREIGN KEY (cpf) REFERENCES pessoa(cpf)
);

CREATE TABLE academia(
    cnpj VARCHAR(20),
    nome VARCHAR(60) NOT NULL,
    conta_deposito NUMBER(25) NOT NULL,
    end_rua VARCHAR(60),
    end_bairro VARCHAR(30),
    end_cep VARCHAR(15),
    CONSTRAINT pk_academia PRIMARY KEY (cnpj)
);

CREATE TABLE cliente_matricula(
    cpf VARCHAR(20),
    frequencia NUMBER(5) DEFAULT 0,
    plano_saude VARCHAR(20),
    data_renovacao DATE NOT NULL,
    plano_tipo VARCHAR(20) NOT NULL,
    conta_bancaria NUMBER(25),
    fk_academia VARCHAR(20) NOT NULL,
    CONSTRAINT pk_cliente_matricula PRIMARY KEY (cpf),
    CONSTRAINT fk_cliente_matricula FOREIGN KEY (cpf) REFERENCES pessoa(cpf),
    CONSTRAINT fk_academia FOREIGN KEY (fk_academia) REFERENCES academia(cnpj)
);

CREATE TABLE funcionario(
    cpf VARCHAR(20),
    funcao VARCHAR(20) NOT NULL,
    salario NUMBER(15) NOT NULL,
    CONSTRAINT pk_funcionario  PRIMARY KEY (cpf),
    CONSTRAINT fk_funcionario FOREIGN KEY (cpf) REFERENCES pessoa(cpf)
);

CREATE TABLE parcelas(
    cpf VARCHAR(20),
    codigo NUMBER(25),
    valor NUMBER(20) NOT NULL,
    data_ DATE NOT NULL,
    forma_pagamento VARCHAR(20) NOT NULL,
    CONSTRAINT pk_parcelas PRIMARY KEY (cpf, codigo),
    CONSTRAINT fk_parcelas FOREIGN KEY (cpf) REFERENCES cliente_matricula(cpf)
);

CREATE TABLE avaliacao(
    id_avaliacao NUMBER(25),
    data_realizacao DATE NOT NULL,
    gordura_corporal NUMBER(10) NOT NULL,
    massa_muscular NUMBER(10) NOT NULL,
    peso NUMBER(10) NOT NULL,
    altura NUMBER(10) NOT NULL,
    CONSTRAINT pk_avaliacao PRIMARY KEY (id_avaliacao),
    CONSTRAINT avaliacao_check_gord CHECK (gordura_corporal > 0),
    CONSTRAINT avaliacao_massa CHECK (massa_muscular > 0),
    CONSTRAINT avaliacao_check_peso CHECK (peso > 0),
    CONSTRAINT avaliacao_check_altura CHECK (altura > 0)
);

CREATE TABLE acompanha(
    id_cliente_matricula VARCHAR(20),
    id_funcionario VARCHAR(20),
    CONSTRAINT pk_companha PRIMARY KEY (id_cliente_matricula, id_funcionario),
    CONSTRAINT fk1_acompanha FOREIGN KEY (id_cliente_matricula) REFERENCES cliente_matricula(cpf),
    CONSTRAINT fk2_acompanha FOREIGN KEY (id_funcionario) REFERENCES funcionario(cpf)
);

CREATE TABLE avalia(
    id_funcionario VARCHAR(20),
    id_avaliacao NUMBER(25),
    id_cliente_matricula VARCHAR(20) NOT NUll,
    CONSTRAINT pk_avalia PRIMARY KEY (id_funcionario, id_avaliacao),
    CONSTRAINT fk1_avalia FOREIGN KEY (id_funcionario) REFERENCES funcionario(cpf),
    CONSTRAINT fk2_avalia FOREIGN KEY (id_avaliacao) REFERENCES avaliacao(id_avaliacao),
    CONSTRAINT fk3_avalia FOREIGN KEY (id_cliente_matricula) REFERENCES cliente_matricula(cpf)
);

CREATE TABLE gerencia(
    gerenciador VARCHAR(20),
    gerenciado VARCHAR(20),
    CONSTRAINT pk_gerencia PRIMARY KEY (gerenciador, gerenciado),
    CONSTRAINT fk1_gerencia FOREIGN KEY (gerenciador) REFERENCES funcionario(cpf),
    CONSTRAINT fk2_gerencia FOREIGN KEY (gerenciado) REFERENCES funcionario(cpf)
);