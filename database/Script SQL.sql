

drop database mesaplus;
create database mesaplus;
use mesaplus;


create table tbl_usuarios(
    id int auto_increment primary key,
    nome varchar(200) not null,
    email varchar(150) not null unique,
    senha text not null,
    cpf varchar (15) not null unique,
    telefone varchar (20) not null,
    foto text null,
    data_modificacao DATETIME,
    codigo_recuperacao text,
    codigo_expiracao datetime
);

create table tbl_empresas(
    id int auto_increment primary key,
    nome varchar(200) not null,
    email varchar(150) not null unique,
    senha text not null,
    cnpj_mei varchar (20) not null unique,
    telefone varchar (20) not null,
    foto text null,
    data_modificacao DATETIME,
    codigo_recuperacao text,
    codigo_expiracao datetime
);

create table tbl_ongs (
    id int auto_increment primary key,
    nome varchar(200) not null,
    email varchar(150) not null unique,
    senha text not null,
    telefone varchar (20) not null,
    foto text null,
    data_modificacao DATETIME,
    codigo_recuperacao text,
    codigo_expiracao datetime
);

-- tabela de endereços
create table tbl_endereco (
    id int auto_increment primary key,
    logradouro varchar(200) not null,
    complemento varchar(80),
    bairro varchar(100) not null,
    cidade varchar(100) not null,
    numero varchar(6) not null,
    estado varchar(80) not null,
    cep varchar(15) not null,
    id_usuario int,
    id_empresa int,
    id_ong int,
    constraint fk_endereco_usuario foreign key(id_usuario) 
    references tbl_usuarios(id) on delete cascade,
    
    constraint fk_endereco_empresa foreign key(id_empresa) 
    references tbl_empresas(id) on delete cascade,
    
    constraint fk_endereco_ong foreign key(id_ong) 
    references tbl_ongs(id) on delete cascade,
    
    constraint chk_dono check(
        (id_usuario is not null) + (id_empresa is not null) + (id_ong is not null) = 1
    )
);

-- tabela de categoria
create table tbl_categoria (
    id int auto_increment primary key,
    nome varchar(255) not null
);

-- tabela tipo peso
create table tbl_tipo_peso (
    id int auto_increment primary key,
    tipo varchar(45) not null
);

-- tabela de alimentos
create table tbl_alimentos (
    id int auto_increment primary key,
    nome varchar(150) not null,
    quantidade int not null,
    peso decimal(5,2),
    data_de_validade date,
    descricao text,
    imagem text,
    id_empresa int not null,
    id_tipo_peso int not null,

    constraint fk_alimento_empresa foreign key(id_empresa) 
    references tbl_empresas(id),

    constraint fk_tipo_peso foreign key(id_tipo_peso) 
    references tbl_tipo_peso(id)
);

-- tabela de relação
create table tbl_alimento_categoria (
    id int auto_increment primary key,
    id_alimento int not null,
    id_categoria int not null,
 
    constraint fk_alimento foreign key(id_alimento) 
    references tbl_alimentos(id),

    constraint fk_categoria foreign key(id_categoria) 
    references tbl_categoria(id)
);


create table tbl_favoritos (
	id int auto_increment primary key,
    id_usuario int null,
    id_ong INT NULL,
    id_empresa int not null,
    
    constraint fk_empresa_favorita foreign key (id_empresa) 
    references tbl_empresas(id),
    
    constraint fk_usuario_favoritos foreign key (id_usuario) 
    references tbl_usuarios(id),
   
    constraint fk_ongs_favoritos foreign key (id_ong)  
     references tbl_ongs(id),
     
    constraint CHECK (
        (id_usuario IS NOT NULL AND id_ong IS NULL) OR 
        (id_usuario IS NULL AND id_ong IS NOT NULL)
    )
);


DELIMITER //
CREATE PROCEDURE filtrar_favoritos (
    IN f_id_usuario INT,
    IN f_id_ong INT
)
BEGIN
    SELECT 
        f.id AS id_favoritos, 
        f.id_usuario AS id_usuario, 
        f.id_ong AS id_ong,      
        f.id_empresa AS id_empresa, 
        e.nome AS nome_empresa, 
        e.email AS email, 
        e.cnpj_mei AS cnpj_mei,
        e.telefone AS telefone,    
        e.foto AS foto_empresa
    FROM 
        tbl_favoritos f
	JOIN
        tbl_empresas e ON e.id = f.id_empresa
        
    WHERE 
        (f.id_usuario = f_id_usuario OR f_id_usuario IS NULL) 
        AND (f.id_ong = f_id_ong OR f_id_ong IS NULL)
        
    ORDER BY f.id DESC;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE inserir_favorito_usuario (
    IN f_id_usuario INT,    
    IN f_id_ong INT,   
    IN f_id_empresa INT     
)
BEGIN
    INSERT INTO tbl_favoritos (
        id_usuario,
        id_ong,           
        id_empresa
    )
    VALUES (
        f_id_usuario,
        NULL,              
        f_id_empresa
    );
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE inserir_favorito_ong (
    IN f_id_ong INT,        
    IN f_id_empresa INT     
)
BEGIN
    INSERT INTO tbl_favoritos (
        id_usuario,      
        id_ong,
        id_empresa
    )
    VALUES (
        NULL,              
        f_id_ong,
        f_id_empresa
    );
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE deletar_favorito (
    IN f_id_favorito INT 
)
BEGIN
    DELETE FROM tbl_favoritos
    WHERE id = f_id_favorito;

END //

DELIMITER ;

delimiter //
create trigger trg_update_usuarios
before update on tbl_usuarios
for each row
begin
    set new.data_modificacao = now();
end;
//
delimiter ;

delimiter //
create trigger trg_update_empresas
before update on tbl_empresas
for each row
begin
    set new.data_modificacao = now();
end;
//
delimiter ;

delimiter //
create trigger trg_update_ongs
before update on tbl_ongs
for each row
begin
    set new.data_modificacao = now();
end;
//
delimiter ;

delimiter //
create procedure inserir_usuario(
    in d_nome varchar(200),
    in d_email varchar(150),
    in d_senha text,
    in d_cpf varchar(15),
    in d_telefone varchar(20)
)
begin
    insert into tbl_usuarios(nome, email, senha, cpf, telefone)
    values (d_nome, d_email, d_senha, d_cpf, d_telefone);
end;
//
delimiter ;


delimiter //
create procedure inserir_empresa(
    in d_nome varchar(200),
    in d_email varchar(150),
    in d_senha text,
    in d_cnpj_mei varchar(20),  
    in d_telefone varchar(20)
)
begin
    insert into tbl_empresas(nome, email, senha, cnpj_mei, telefone) 
    values (d_nome, d_email, d_senha, d_cnpj_mei, d_telefone);
end;
//
delimiter ;

delimiter //
create procedure inserir_ong(
    in d_nome varchar(200),
    in d_email varchar(150),
    in d_senha text,
    in d_telefone varchar(20)
)
begin
    insert into tbl_ongs(nome, email, senha, telefone)
    values (d_nome, d_email, d_senha, d_telefone);
end;
//
delimiter ;

-- inserir alimento
DELIMITER //
CREATE PROCEDURE inserir_alimento(
    IN d_nome VARCHAR(150),
    IN d_quantidade VARCHAR(100),
    IN d_peso DECIMAL(5,2),
    IN d_data VARCHAR(20),
    IN d_descricao TEXT,
    IN d_imagem VARCHAR(255),
    IN d_id_empresa INT,
    IN d_id_tipo_peso INT
)
BEGIN
    DECLARE data_geral DATE;

    -- tenta vários formatos (com hífens e barras)
    set data_geral = STR_TO_DATE(d_data, '%Y-%m-%d');
    if data_geral is null then
        set data_geral = STR_TO_DATE(d_data, '%Y/%m/%d');
    end if;
    if data_geral is null then
        set data_geral = STR_TO_DATE(d_data, '%d/%m/%Y');
    end if;

    -- Se ainda assim não converter, gera erro
    IF data_geral is null then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato de data inválido! Use YYYY-MM-DD, YYYY/MM/DD ou DD/MM/YYYY';
    end if;

    INSERT INTO tbl_alimentos(nome, quantidade, peso, data_de_validade, descricao, imagem, id_empresa, id_tipo_peso)
    VALUES (d_nome, d_quantidade, d_peso, data_geral, d_descricao, d_imagem, d_id_empresa, d_id_tipo_peso);
END;
//
DELIMITER ;



delimiter //
create procedure alimentos_categorias(
    in p_id_alimento int,
    in p_id_categoria int
)
begin
    insert into tbl_alimento_categoria(id_alimento, id_categoria)
    values (p_id_alimento, p_id_categoria);
end;
//
delimiter ;

delimiter //
create procedure inserir_categoria(
    in p_nome varchar(255)
)
begin
    insert into tbl_categoria(nome)
    values (p_nome);
end;
//
delimiter ;

delimiter //
create procedure inserir_tipo_peso(
    in p_tipo_peso varchar(45)
)
begin
    insert into tbl_tipo_peso(tipo_peso)
    values (p_tipo_peso);
end;
//
delimiter ;

delimiter //
create procedure deletar_usuario(in d_id int)
begin
    delete from tbl_usuarios where id = d_id;
end;
//
delimiter ;

delimiter //
create procedure deletar_empresa(in d_id int)
begin
    delete from tbl_empresas where id = d_id;
end;
//
delimiter ;

delimiter //
create procedure deletar_ong(in d_id int)
begin
    delete from tbl_ongs where id = d_id;
end;
//
delimiter ;

delimiter //
create procedure deletar_alimento(
	in d_id_alimentos int
)
begin
    delete from tbl_alimento_categoria where id_alimento = d_id_alimento;
	delete from tbl_user_pedidos where id_alimento = d_id_alimentos;
    delete from tbl_alimentos where id = d_id_alimentos;
end;
//
delimiter ;

delimiter //
create procedure deletar_categoria(in d_id_categorias int)
begin
    delete from tbl_alimentos_categoria where id_categoria = d_id_categoria;
    delete from tbl_categorias where id = d_id_categorias;
end;
//
delimiter ;

delimiter //
create trigger trg_empresa_cnpj
before update on tbl_empresas
for each row
begin
    if new.cnpj_mei <> old.cnpj_mei then
        signal sqlstate '45000'
        set message_text = 'o cnpj não pode ser alterado';
    end if;
end;
//
delimiter ;

create view vw_usuarios as
select id, nome, email, 'usuario' as tipo_usuario from tbl_usuarios
union
select id, nome, email, 'empresa' as tipo_usuario from tbl_empresas
union
select id, nome, email, 'ong' as tipo_usuario from tbl_ongs;

DELIMITER //
CREATE PROCEDURE filtrar_alimentos_categoria (
    IN id_categoria_filtro INT
)
BEGIN
    SELECT 
        a.id AS id_alimento, 
        a.nome AS nome_alimento, 
        a.quantidade AS quantidade, 
        a.peso AS peso,
        a.id_tipo_peso AS id_tipo_peso, 
		t.tipo AS tipoPeso,
        a.data_de_validade AS data_de_validade, 
        a.descricao AS descricao, 
        a.imagem AS imagem, 
        a.id_empresa AS id_empresa, 
        e.nome AS nome_empresa, 
        e.foto AS foto_empresa, 
        c.nome AS nome_categoria
    FROM 
        tbl_alimentos a
    
    -- 1. JOIN com a tabela de relacionamento (usaremos o filtro aqui)
    JOIN 
        tbl_alimento_categoria ac ON ac.id_alimento = a.id
    
    -- 2. JOIN com a tabela de categoria (necessário para pegar o nome da categoria, c.nome)
    JOIN 
        tbl_categoria c ON c.id = ac.id_categoria
    
    -- 3. JOIN com a tabela de empresa (para obter os detalhes)
    JOIN 
        tbl_empresas e ON e.id = a.id_empresa 
        
	-- 4. JOIN com a tabela de tipoPeso (para obter os detalhes)
    JOIN 
        tbl_tipo_peso t ON t.id = a.id_tipo_peso
    
    -- O FILTRO é aplicado na coluna id_categoria da tabela de relacionamento (ac)
    WHERE 
        ac.id_categoria = id_categoria_filtro
        
	ORDER BY a.id desc;
END //

DELIMITER ;



insert INTO tbl_tipo_peso (tipo)
values 
('Quilos(Kg)'),
('Gramas(g)'),
('Unidades(Un)'),
('Litros(L)'),
('Militros(ml)');



insert INTO tbl_categoria (nome)
values 	
('Não Perecivel'),
('Perecivel'),
('SemiPerecivel');



DELIMITER //
CREATE PROCEDURE filtrar_alimentos_por_data (
    IN d_data varchar(50)
)
BEGIN

	DECLARE data_geral DATE;

    -- Tenta o primeiro formato (DD-MM-YYYY)
    SET data_geral = STR_TO_DATE(d_data, '%d-%m-%Y');

    -- Tenta o segundo formato (DD/MM/YYYY)
    IF data_geral IS NULL THEN
        SET data_geral = STR_TO_DATE(d_data, '%d/%m/%Y');
    END IF;

    -- Tenta o terceiro formato (DD-MM-YYYYTHH:MM:SS)
    IF data_geral IS NULL THEN
        SET data_geral = STR_TO_DATE(d_data, '%d-%m-%YT%H:%i:%s');
    END IF;

    -- Tenta o quarto formato (DD/MM/YYYYTHH:MM:SS)
    IF data_geral IS NULL THEN
        SET data_geral = STR_TO_DATE(d_data, '%d/%m/%YT%H:%i:%s');
    END IF;

    -- Tenta o formato ISO (YYYY-MM-DD), que é o mais comum no JS/Prisma
    IF data_geral IS NULL THEN
        SET data_geral = STR_TO_DATE(d_data, '%Y-%m-%d');
    END IF;

    -- Se nenhuma conversão funcionar, sinaliza o erro
    IF data_geral IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato de data inválido! Use DD-MM-YYYY, DD/MM/YYYY ou formato ISO (YYYY-MM-DD).';
    END IF;

    SELECT 
        a.id AS id_alimento, 
        a.nome AS nome_alimento, 
        a.quantidade, 
        a.peso,
        a.id_tipo_peso, 
	t.tipo AS tipoPeso,
        a.data_de_validade, 
        a.descricao, 
        a.imagem, 
        a.id_empresa, 
        e.nome AS nome_empresa, 
        e.foto AS foto_empresa,
        null AS nome_categoria -- alterado para chamar a categoria
    FROM 
        tbl_alimentos a
    JOIN 
        tbl_empresas e ON e.id = a.id_empresa
    JOIN 
        tbl_tipo_peso t ON t.id = a.id_tipo_peso
    
    WHERE 
        a.data_de_validade = data_geral
    ORDER BY a.data_de_validade ASC;
END //
DELIMITER ;



CREATE TABLE tbl_user_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NULL,
    id_ong INT NULL,     
    id_alimento INT NOT NULL,
    quantidade INT NOT NULL,
    
    CONSTRAINT fk_pedidos_alimento FOREIGN KEY (id_alimento)  
    REFERENCES tbl_alimentos(id),
    
    CONSTRAINT fk_pedidos_usuario FOREIGN KEY (id_usuario)  
    REFERENCES tbl_usuarios(id),
    
    CONSTRAINT fk_pedidos_ong FOREIGN KEY (id_ong)  
    REFERENCES tbl_ongs(id),
    
    CONSTRAINT chk_usuario_ou_ong CHECK (
        (id_usuario IS NOT NULL AND id_ong IS NULL) OR 
        (id_usuario IS NULL AND id_ong IS NOT NULL)
    )
);



DELIMITER //

CREATE PROCEDURE filtrar_pedidos (
    IN p_id_usuario INT,
    IN p_id_ong INT
)
BEGIN
    SELECT 
        p.id AS id_pedido, 
        p.id_usuario AS id_usuario, 
        p.id_ong AS id_ong,      
        p.id_alimento AS id_alimento, 
        p.quantidade AS quantidade_pedido,
        a.nome AS nome_alimento, 
        a.quantidade AS quantidade, 
        a.peso AS peso,
        a.id_tipo_peso AS id_tipo_peso, 
        t.tipo AS tipoPeso,
        a.data_de_validade AS data_de_validade, 
        a.descricao AS descricao, 
        a.imagem AS imagem, 
        a.id_empresa AS id_empresa, 
        e.nome AS nome_empresa, 
        e.foto AS foto_empresa
    FROM 
        tbl_user_pedidos p 
    JOIN 
        tbl_alimentos a ON p.id_alimento = a.id 
    JOIN 
        tbl_tipo_peso t ON t.id = a.id_tipo_peso
    JOIN 
        tbl_empresas e ON e.id = a.id_empresa
        
    WHERE 
        (p.id_usuario = p_id_usuario OR p_id_usuario IS NULL) 
        AND (p.id_ong = p_id_ong OR p_id_ong IS NULL)
        
    ORDER BY p.id DESC;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE inserir_pedido_usuario (
    IN p_id_usuario INT,    
    IN p_id_alimento INT,   
    IN p_quantidade INT     
)
BEGIN
    INSERT INTO tbl_user_pedidos (
        id_usuario,
        id_ong,           
        id_alimento,
        quantidade
    )
    VALUES (
        p_id_usuario,
        NULL,              
        p_id_alimento,
        p_quantidade
    );
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE inserir_pedido_ong (
    IN p_id_ong INT,        
    IN p_id_alimento INT,   
    IN p_quantidade INT     
)
BEGIN
    INSERT INTO tbl_user_pedidos (
        id_usuario,      
        id_ong,
        id_alimento,
        quantidade
    )
    VALUES (
        NULL,              
        p_id_ong,
        p_id_alimento,
        p_quantidade
    );
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE deletar_pedido_usuario (
    IN p_id_pedido INT 
)
BEGIN
    DELETE FROM tbl_user_pedidos
    WHERE id = p_id_pedido;

END //

DELIMITER ;


DELIMITER //
CREATE PROCEDURE atualizar_ong (
    IN p_id INT,                  
    IN p_nome VARCHAR(200),        
    IN p_email VARCHAR(150),       
    IN p_senha TEXT,               
    IN p_telefone VARCHAR(20),     
    IN p_foto TEXT                
)
BEGIN
    DECLARE old_nome VARCHAR(200);
    DECLARE old_email VARCHAR(150);
    DECLARE old_senha TEXT;
    DECLARE old_telefone VARCHAR(20);
    DECLARE old_foto TEXT;
    
    -- 1. Tenta recuperar os dados antigos
    SELECT 
        nome, email, senha, telefone, foto
    INTO
        old_nome, old_email, old_senha, old_telefone, old_foto
    FROM
        tbl_ongs
    WHERE
        id = p_id;
        
    -- Se o parâmetro for NULL ou vazio, mantém o valor antigo.
    SET p_nome = IF(p_nome IS NULL OR p_nome = '', old_nome, p_nome);
    SET p_email = IF(p_email IS NULL OR p_email = '', old_email, p_email);
    SET p_senha = IF(p_senha IS NULL OR p_senha = '', old_senha, p_senha);
    SET p_telefone = IF(p_telefone IS NULL OR p_telefone = '', old_telefone, p_telefone);

    SET p_foto = IF(p_foto IS NULL, old_foto, p_foto);


    UPDATE tbl_ongs
    SET
        nome = p_nome,
        email = p_email,
        senha = p_senha,
        telefone = p_telefone,
        foto = p_foto
    WHERE
        id = p_id;
        
END //

DELIMITER ;



DELIMITER //
CREATE PROCEDURE atualizar_usuario (
    IN p_id INT,                  
    IN p_nome VARCHAR(200),        
    IN p_email VARCHAR(150),       
    IN p_senha TEXT,               
    IN p_telefone VARCHAR(20),     
    IN p_foto TEXT                
)
BEGIN
    DECLARE old_nome VARCHAR(200);
    DECLARE old_email VARCHAR(150);
    DECLARE old_senha TEXT;
    DECLARE old_telefone VARCHAR(20);
    DECLARE old_foto TEXT;
    DECLARE usuario_existe INT DEFAULT 0;

    -- Verifica se o usuário existe
    SELECT COUNT(*) INTO usuario_existe FROM tbl_usuarios WHERE id = p_id;
    
    IF usuario_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuário não encontrado.';
    ELSE
        SELECT 
            nome, email, senha, telefone, foto
        INTO
            old_nome, old_email, old_senha, old_telefone, old_foto
        FROM
            tbl_usuarios
        WHERE
            id = p_id;
            
        SET p_nome = IF(p_nome IS NULL OR p_nome = '', old_nome, p_nome);
        SET p_email = IF(p_email IS NULL OR p_email = '', old_email, p_email);
        SET p_senha = IF(p_senha IS NULL OR p_senha = '', old_senha, p_senha);
        SET p_telefone = IF(p_telefone IS NULL OR p_telefone = '', old_telefone, p_telefone);
        SET p_foto = IF(p_foto IS NULL, old_foto, p_foto);

        UPDATE tbl_usuarios
        SET
            nome = p_nome,
            email = p_email,
            senha = p_senha,
            telefone = p_telefone,
            foto = p_foto
        WHERE
            id = p_id;
    END IF;
END //
DELIMITER;


DELIMITER //
CREATE PROCEDURE atualizar_empresa (
    IN p_id INT,                  
    IN p_nome VARCHAR(200),        
    IN p_email VARCHAR(150),       
    IN p_senha TEXT,               
    IN p_telefone VARCHAR(20),     
    IN p_foto TEXT                
)
BEGIN
    DECLARE old_nome VARCHAR(200);
    DECLARE old_email VARCHAR(150);
    DECLARE old_senha TEXT;
    DECLARE old_telefone VARCHAR(20);
    DECLARE old_foto TEXT;
    DECLARE empresa_existe INT DEFAULT 0;

    -- Verifica se a empresa existe
    SELECT COUNT(*) INTO empresa_existe FROM tbl_empresas WHERE id = p_id;
    
    IF empresa_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Empresa não encontrada.';
    ELSE
        SELECT 
            nome, email, senha, telefone, foto
        INTO
            old_nome, old_email, old_senha, old_telefone, old_foto
        FROM
            tbl_empresas
        WHERE
            id = p_id;
            
        SET p_nome = IF(p_nome IS NULL OR p_nome = '', old_nome, p_nome);
        SET p_email = IF(p_email IS NULL OR p_email = '', old_email, p_email);
        SET p_senha = IF(p_senha IS NULL OR p_senha = '', old_senha, p_senha);
        SET p_telefone = IF(p_telefone IS NULL OR p_telefone = '', old_telefone, p_telefone);
        SET p_foto = IF(p_foto IS NULL, old_foto, p_foto);

        UPDATE tbl_empresas
        SET
            nome = p_nome,
            email = p_email,
            senha = p_senha,
            telefone = p_telefone,
            foto = p_foto
        WHERE
            id = p_id;
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE filtrar_alimentos_empresa (
    IN id_empresa_filtro INT
)
BEGIN
    SELECT 
        a.id AS id_alimento, 
        a.nome AS nome_alimento, 
        a.quantidade AS quantidade, 
        a.peso AS peso,
        a.id_tipo_peso AS id_tipo_peso, 
        t.tipo AS tipoPeso,
        a.data_de_validade AS data_de_validade, 
        a.descricao AS descricao, 
        a.imagem AS imagem, 
        a.id_empresa AS id_empresa, 
        e.nome AS nome_empresa, 
        e.foto AS foto_empresa,
        c.nome AS nome_categoria
    FROM 
        tbl_alimentos a
    

    -- 3. JOIN com a tabela de empresa (para obter os detalhes)
    JOIN 
        tbl_empresas e ON e.id = a.id_empresa 
        
	-- 3. JOIN com a tabela de tipoPeso (para obter os detalhes)
    JOIN 
        tbl_tipo_peso t ON t.id = a.id_tipo_peso
        
	LEFT JOIN 
		tbl_alimento_categoria ac ON ac.id_alimento = a.id
        
	LEFT JOIN 
		tbl_categoria c ON c.id = ac.id_categoria
    
    WHERE 
        e.id = id_empresa_filtro
        
	ORDER BY a.id desc;
END //

DELIMITER ;








