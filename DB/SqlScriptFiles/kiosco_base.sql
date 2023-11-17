create database if not exists kioskbox;
use kioskbox;

create table if not exists usuario(
usuario_id varchar(20) NOT NULL UNIQUE, -- la id es una cadena de texto unica
clave varchar(30) NOT NULL,
ci int(8) UNSIGNED,
nombre varchar(45),
apellido varchar(45),
actividad timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
PRIMARY KEY (`usuario_id`)
);

create table if not exists producto(
prducto_id smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
nombre varchar(30),
detalle varchar(50),
categoria varchar(20),
precio decimal(5,2) NOT NULL,
proveedor varchar(10)
);

create table if not exists producto_categoria(
categoria_nombre varchar(20) NOT NULL UNIQUE, -- la id es un nombre de categoria unico
PRIMARY KEY (`categoria_nombre`)
);
