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
    `salario_por_hora` DECIMAL(15 , 2 ) NOT NULL,
    `deshabilitado` BOOLEAN NOT NULL DEFAULT FALSE,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_usuario`),
    INDEX `idx_usuario` (`usuario`) USING BTREE,
    INDEX `idx_login` (`usuario`,`clave`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `usuario_tel` (
    `id_usuario` SMALLINT UNSIGNED NOT NULL,
    `telefono` VARCHAR(20) NOT NULL,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_usuario` , `telefono`),
    CONSTRAINT `fk_id_usuario_tel` FOREIGN KEY (`id_usuario`)
        REFERENCES `usuario` (`id_usuario`)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `key_tel_unico` UNIQUE (`id_usuario` , `telefono`),
    INDEX `idx_id_usuario` (`id_usuario`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `turno` (
    `id_turno` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `dia` ENUM('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo') NOT NULL,
    `inicio_turno` TIME NOT NULL,
    `fin_turno` TIME NOT NULL,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_turno`),
    CONSTRAINT `key_unico_turno` UNIQUE (`dia` , `inicio_turno` , `fin_turno`),
    CONSTRAINT `chk_turno` CHECK (`fin_turno` > `inicio_turno`),
    INDEX `idx_dia_inicio_turno` (`dia`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `asigna` (
    `id_turno` TINYINT UNSIGNED NOT NULL,
    `id_usuario` SMALLINT UNSIGNED NOT NULL,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_turno` , `id_usuario`),
    CONSTRAINT `fk_id_turno_asigna` FOREIGN KEY (`id_turno`)
        REFERENCES `turno` (`id_turno`)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `fk_id_usuario_asigna` FOREIGN KEY (`id_usuario`)
        REFERENCES `usuario` (`id_usuario`)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `key_asigna_unico` UNIQUE (`id_turno` , `id_usuario`),
    INDEX `idx_id_usuario` (`id_usuario`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `balance` (
    `id_balance` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `fecha_inicio` DATETIME NOT NULL,
    `fecha_cierre` DATETIME,
    `salida` DECIMAL(15 , 2 ) NOT NULL,
    `entrada` DECIMAL(15 , 2 ) NOT NULL,
    `nota` VARCHAR(200),
    `estado` ENUM('ABIERTO', 'CERRADO', 'PENDIENTE', 'ANULADO') NOT NULL,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_balance`),
    CONSTRAINT `chk_fecha_i_balance` CHECK (`fecha_inicio` < `fecha_cierre`
        OR `fecha_cierre` IS NULL),
    INDEX `idx_fecha_inicio_cierre` (`fecha_inicio`,`fecha_cierre`) USING BTREE,
    INDEX `idx_estado` (`estado`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `jornada` (
    `id_jornada` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `fecha` DATE NOT NULL,
    `hora_entrada` TIME NOT NULL,
    `hora_salida` TIME,
    `id_balance` SMALLINT UNSIGNED NOT NULL,
    `id_usuario` SMALLINT UNSIGNED NOT NULL,
    `paga_del_dia` DECIMAL(15 , 2 ) NOT NULL,
    `detalle` VARCHAR(200),
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_jornada`),
    CONSTRAINT `fk_id_usuario` FOREIGN KEY (`id_usuario`)
        REFERENCES `asigna` (`id_usuario`)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `fk_id_balance` FOREIGN KEY (`id_balance`)
        REFERENCES `balance` (`id_balance`)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `key_jornada_unica` UNIQUE (`fecha` , `hora_entrada` , `hora_salida`),
    INDEX `idx_fecha` (`fecha`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `categoria` (
    `nombre_categoria` VARCHAR(30) NOT NULL UNIQUE,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`nombre_categoria`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `producto` (
    `id_producto` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `codigo` VARCHAR(30),
    `nombre` VARCHAR(60) NOT NULL,
    `categoria` VARCHAR(30),
    `precio_venta` DECIMAL(15 , 2 ) UNSIGNED NOT NULL,
    `unidades` SMALLINT UNSIGNED,
    `fecha_terminado` DATETIME,
    `reponer` BOOLEAN DEFAULT FALSE,
    `estado` ENUM('Alta', 'Baja', 'Extraviado') DEFAULT 'Alta' NOT NULL,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_producto`),
    CONSTRAINT `fk_categoria_producto` FOREIGN KEY (`categoria`)
        REFERENCES `categoria` (`nombre_categoria`)
        ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX `idx_codigo` (`codigo`) USING BTREE,
    INDEX `idx_nombre` (`nombre`) USING BTREE,
    INDEX `idx_estado` (`estado`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `boleta` (
    `id_boleta` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_usuario` SMALLINT UNSIGNED NOT NULL,
    `monto_total` DECIMAL(15 , 2 ) UNSIGNED NOT NULL,
    `monto_entrega` DECIMAL(15 , 2 ) UNSIGNED NOT NULL,
    `monto_cambio` DECIMAL(15 , 2 ) UNSIGNED NOT NULL,
    `fecha` DATETIME,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_boleta`),
    CONSTRAINT `fk_id_usuario_boleta` FOREIGN KEY (`id_usuario`)
        REFERENCES `usuario` (`id_usuario`)
        ON UPDATE CASCADE,
    INDEX `idx_fecha` (`fecha`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `venta` (
    `id_boleta` INT UNSIGNED NOT NULL,
    `id_producto` INT UNSIGNED NOT NULL,
    `cantidad` TINYINT NOT NULL DEFAULT 1,
    `precio_final_unitario` DECIMAL(15 , 2 ) NOT NULL,
    `ganancia_total` DECIMAL(15 , 2 ) NOT NULL,
    `id_balance` SMALLINT UNSIGNED NOT NULL,
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_boleta` , `id_producto`),
    CONSTRAINT `fk_id_boleta_venta` FOREIGN KEY (`id_boleta`)
        REFERENCES `boleta` (`id_boleta`),
	CONSTRAINT `fk_id_producto_venta` FOREIGN KEY (`id_producto`)
		REFERENCES `producto`(`id_producto`),
    CONSTRAINT `fk_id_balance_venta` FOREIGN KEY (`id_balance`)
        REFERENCES `balance` (`id_balance`),
    INDEX `idx_id_boleta` (`id_boleta`) USING BTREE,
    INDEX `idx_ultima_actividad` (`ultima_actividad`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `proveedor` (
    `nombre_proveedor` VARCHAR(30) NOT NULL UNIQUE,
    `nota` VARCHAR(200),
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`nombre_proveedor`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `proveedor_tel`(
    `nombre_proveedor` VARCHAR(30),
    `telefono` VARCHAR(20),
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`nombre_proveedor`, `telefono`),
    FOREIGN KEY (`nombre_proveedor`) REFERENCES `proveedor`(`nombre_proveedor`),
    INDEX `idx_nombre_proveedor` (`nombre_proveedor`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `provee` (
    `id_producto` INT UNSIGNED NOT NULL,
    `nombre_proveedor` VARCHAR(30) NOT NULL UNIQUE,
    `fecha_ingreso` DATE,
    `vencimiento` DATE,
    `costo_compra` DECIMAL(15 , 2 ) NOT NULL,
    `precio_sugerido` DECIMAL(15 , 2 ),
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_producto`, `nombre_proveedor`),
    FOREIGN KEY (`id_producto`) REFERENCES `producto`(`id_producto`),
    FOREIGN KEY (`nombre_proveedor`) REFERENCES `proveedor`(`nombre_proveedor`),
    INDEX `idx_nombre_proveedor_fecha_ingreso` (`nombre_proveedor`,`fecha_ingreso`) USING BTREE,
    INDEX `idx_nombre_proveedor_id_producto` (`nombre_proveedor`,`id_producto`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `deuda` (
    `fecha` DATE,
    `nombre` VARCHAR(30),
    `id_boleta` INT UNSIGNED NOT NULL,
	`id_balance` SMALLINT UNSIGNED NOT NULL,
    `monto` DECIMAL(15, 2),
    `concepto` VARCHAR(200),
    `estado` ENUM('ABIERTA','CERRADA','PAGA'),
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`fecha`, `nombre`),
    FOREIGN KEY (`id_boleta`) REFERENCES `boleta`(`id_boleta`),
    FOREIGN KEY (`id_balance`) REFERENCES `balance`(`id_balance`),
    INDEX `idx_nombre` (`nombre`) USING BTREE,
    INDEX `idx_id_balance` (`id_balance`) USING BTREE,
    INDEX `idx_monto` (`monto`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `entrada_salida` (
    `id_ent_sal` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_balance` SMALLINT UNSIGNED NOT NULL,
    `fecha` DATETIME NOT NULL,
    `concepto` VARCHAR(30) NOT NULL,
    `tipo` ENUM('ENTRADA', 'SALIDA') NOT NULL,
    `monto` DECIMAL(15, 2) NOT NULL,
    `detalle` VARCHAR(200),
    `ultima_actividad` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_ent_sal`),
    FOREIGN KEY (`id_balance`) REFERENCES `balance`(`id_balance`),
    INDEX `idx_id_balance` (`id_balance`) USING BTREE,
    INDEX `idx_tipo` (`tipo`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;