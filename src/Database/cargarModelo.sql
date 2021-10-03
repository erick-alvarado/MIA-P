DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS actor CASCADE;
DROP TABLE IF EXISTS traduccion CASCADE;
DROP TABLE IF EXISTS pais CASCADE;
DROP TABLE IF EXISTS ciudad CASCADE;
DROP TABLE IF EXISTS direccion CASCADE;
DROP TABLE IF EXISTS tienda CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS pelicula CASCADE;
DROP TABLE IF EXISTS empleado CASCADE;
DROP TABLE IF EXISTS renta CASCADE;
DROP TABLE IF EXISTS detalle_categoria CASCADE;
DROP TABLE IF EXISTS detalle_traduccion CASCADE;
DROP TABLE IF EXISTS detalle_actor CASCADE;


CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR NOT NULL
);
 CREATE TABLE actor (
    id_actor SERIAL PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    apellido VARCHAR NOT NULL
);
 CREATE TABLE traduccion (
    id_traduccion SERIAL PRIMARY KEY,
    nombre VARCHAR NOT NULL
);
 CREATE TABLE pais (
    id_pais SERIAL PRIMARY KEY,
    nombre VARCHAR NOT NULL
);
 CREATE TABLE ciudad (
    id_ciudad SERIAL PRIMARY KEY,
    id_pais INT NOT NULL REFERENCES pais(id_pais),
    nombre VARCHAR NOT NULL
);
 CREATE TABLE direccion (
    id_direccion SERIAL PRIMARY KEY,
    id_ciudad INT NOT NULL REFERENCES ciudad(id_ciudad),
    distrito VARCHAR NOT NULL,
    codigo VARCHAR NOT NULL
);
CREATE TABLE tienda (
    id_tienda SERIAL PRIMARY KEY,
    id_direccion INT REFERENCES direccion(id_direccion),
    nombre VARCHAR NOT NULL
);
 CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    id_tienda INT NOT NULL REFERENCES tienda(id_tienda),
    id_direccion INT NOT NULL REFERENCES direccion(id_direccion),
    nombre VARCHAR NOT NULL,
    apellido VARCHAR NOT NULL,
    correo VARCHAR NOT NULL,
    fecha_registro VARCHAR NOT NULL,
    activo VARCHAR NOT NULL
);
 CREATE TABLE pelicula (
    id_pelicula SERIAL PRIMARY KEY,
    titulo VARCHAR NOT NULL,
    descripcion VARCHAR NOT NULL,
    ano INT NOT NULL,
    duracion INT NOT NULL,
    dias INT NOT NULL,
    costo DECIMAL NOT NULL,
    clasificacion VARCHAR NOT NULL
);
 CREATE TABLE empleado (
    id_empleado SERIAL PRIMARY KEY,
    id_tienda INT NOT NULL REFERENCES tienda(id_tienda),
    id_direccion INT NOT NULL REFERENCES direccion(id_direccion),
    nombre VARCHAR NOT NULL,
    apellido VARCHAR NOT NULL,
    correo VARCHAR NOT NULL,
    activo VARCHAR NOT NULL,
    usuario VARCHAR NOT NULL,
    contrasena VARCHAR NOT NULL
);
 CREATE TABLE renta (
    id_renta SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES cliente(id_cliente),
    id_empleado INT NOT NULL REFERENCES empleado(id_empleado),
    id_pelicula INT NOT NULL REFERENCES pelicula(id_pelicula),
    monto DECIMAL NOT NULL,
    fecha_renta TIMESTAMP NOT NULL,
    fecha_retorno TIMESTAMP NOT NULL,
    fecha_pago TIMESTAMP
);
 CREATE TABLE detalle_categoria (
    id_detalle_categoria SERIAL PRIMARY KEY,
    id_pelicula INT NOT NULL REFERENCES pelicula(id_pelicula),
    id_categoria INT NOT NULL REFERENCES categoria(id_categoria)
);
 CREATE TABLE detalle_actor (
    id_detalle_actor SERIAL PRIMARY KEY,
    id_pelicula INT NOT NULL REFERENCES pelicula(id_pelicula),
    id_actor INT NOT NULL REFERENCES actor(id_actor)
);
 CREATE TABLE detalle_traduccion (
    id_detalle_traduccion SERIAL PRIMARY KEY,
    id_pelicula INT NOT NULL REFERENCES pelicula(id_pelicula),
    id_traduccion INT NOT NULL REFERENCES traduccion(id_traduccion)
);
ALTER TABLE tienda ADD COLUMN id_empleado INT;
ALTER TABLE tienda
    ADD CONSTRAINT id_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);