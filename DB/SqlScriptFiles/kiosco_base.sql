drop database if exists kioscoDB;
create database if not exists kioscoDB;
use kioscoDB;

CREATE TABLE IF NOT EXISTS `usuario` (
    `id_usuario` SMALLINT NOT NULL AUTO_INCREMENT,
	`usuario` VARCHAR(20) NOT NULL UNIQUE,
    `clave` VARCHAR(30) NOT NULL,
    `ci` INT(8) UNSIGNED,
    `nombre` VARCHAR(45),
	`apellido` VARCHAR(45),
    `es_admin` BOOLEAN NOT NULL,
    `salario_por_hora` DECIMAL(15,2) NOT NULL,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP () ON UPDATE CURRENT_TIMESTAMP (),
    `deshabilitado` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id_usuario`)
    -- CONSTRAINT dsf 
    -- UNIQUE(sdfsdf,sdfsdf,Rfg)
);

CREATE TABLE IF NOT EXISTS `usuario_tel` (
	`id_usuario` SMALLINT NOT NULL,
    `telefono` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id_usuario`, `telefono`),
    CONSTRAINT `fk_usuario_id`FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)  ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `horario` (
	`dia` ENUM('L','M','X','J','V','S','D') NOT NULL,
    `inicio_turno` TIME NOT NULL,
    `fin_turno` TIME NOT NULL CHECK (`fin_turno`>`inicio_turno`),
    `fecha_modificacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP () ON UPDATE CURRENT_TIMESTAMP ()
    );

CREATE TABLE IF NOT EXISTS producto (
    prducto_id SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(30),
    detalle VARCHAR(50),
    categoria VARCHAR(20),
    precio DECIMAL(5 , 2 ) NOT NULL,
    proveedor VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS producto_categoria (
    categoria_nombre VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY (`categoria_nombre`)
);
