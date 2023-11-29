drop database if exists kioscoDB;
create database if not exists kioscoDB;
use kioscoDB;

CREATE TABLE IF NOT EXISTS `usuario` (
    `id_usuario` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`usuario` VARCHAR(20) NOT NULL UNIQUE,
    `clave` VARCHAR(30) NOT NULL,
    `ci` INT(8) UNSIGNED,
    `nombre` VARCHAR(45),
	`apellido` VARCHAR(45),
    `es_admin` BOOLEAN NOT NULL,
    `salario_por_hora` DECIMAL(15,2) NOT NULL,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deshabilitado` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id_usuario`)
);

CREATE TABLE IF NOT EXISTS `usuario_tel` (
	`id_usuario` SMALLINT UNSIGNED NOT NULL,
    `telefono` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id_usuario`,`telefono`),
    CONSTRAINT `fk_id_usuario_tel`FOREIGN KEY (`id_usuario`) REFERENCES `usuario`(`id_usuario`)  ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `key_tel_unico` UNIQUE (`id_usuario`,`telefono`)
);

CREATE TABLE IF NOT EXISTS `turno` (
	`id_turno` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`dia` ENUM('L','M','X','J','V','S','D') NOT NULL,
    `inicio_turno` TIME NOT NULL,
    `fin_turno` TIME NOT NULL,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_turno`),
    CONSTRAINT `key_unico_turno` UNIQUE (`dia`,`inicio_turno`,`fin_turno`),
    CONSTRAINT `chk_turno` CHECK (`fin_turno`>`inicio_turno`)
);

CREATE TABLE IF NOT EXISTS `asigna` (
	`id_turno` TINYINT UNSIGNED NOT NULL,
	`id_usuario` SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (`id_turno`,`id_usuario`),
    CONSTRAINT `fk_id_turno_asigna` FOREIGN KEY (`id_turno`) REFERENCES `turno`(`id_turno`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `fk_id_usuario_asigna` FOREIGN KEY (`id_usuario`) REFERENCES `usuario`(`id_usuario`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `key_asigna_unico` UNIQUE (`id_turno`,`id_usuario`)
);

CREATE TABLE IF NOT EXISTS `balance` (
	`id_balance` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `fecha_inicio` DATETIME NOT NULL,
    `fecha_cierre` DATETIME,
	`salida` DECIMAL(15,2) NOT NULL,
    `entrada` DECIMAL(15,2) NOT NULL,
    `nota` VARCHAR(120),
    `estado` ENUM('ABIERTO','CERRADO','PENDIENTE','ANULADO') NOT NULL,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_balance`),
    CONSTRAINT `chk_fecha_i_balance` CHECK (`fecha_inicio`<`fecha_cierre` OR `fecha_cierre` IS NULL)
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
