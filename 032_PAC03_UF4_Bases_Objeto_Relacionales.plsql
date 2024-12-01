CREATE TYPE Autor AS OBJECT (
 id INTEGER,
 nombre VARCHAR2(100)
);
/

-- Creación del tipo de objeto "Artículo"
CREATE OR REPLACE TYPE Articulo AS OBJECT (
 id INTEGER,
 titulo VARCHAR2(200),
 refautor REF Autor
);
/

-- Creación de la tabla "Autores"
CREATE TABLE Autores OF Autor;
/

-- Creación de la tabla "Artículos"
CREATE TABLE Articulos OF Articulo;
/

-- Insertar un autor y un artículo que haga referencia a ese autor
INSERT INTO Autores VALUES (Autor(1, 'Juan Pérez'));
INSERT INTO Articulos VALUES (Articulo(1, 'Título del Artículo', (SELECT REF(a) FROM Autores a WHERE a.id = 1)));
