-- Se quiere crear una base de datos orientada a objetos para gestionar una biblioteca. Deberá tener objetos para Autor y Libro. Cada libro tendrá una referencia al autor. Además, se debe garantizar que cada libro tenga un título y que cada autor tenga un nombre.

-- Creación del tipo de objeto "Autor"

CREATE OR REPLACE TYPE autor AS
    OBJECT (
        id NUMBER,
        nombre VARCHAR2(100) NOT NULL -- Garantizamos que cada autor tenga un nombre
    );
/

-- Creación del tipo de objeto "Libro"

CREATE OR REPLACE TYPE libro AS
    OBJECT (
        id NUMBER,
        titulo VARCHAR2(200) NOT NULL, -- Garantizamos que cada libro tenga un título
        autor ref autor
    );
/

-- Creación de la tabla "Autores" para almacenar objetos del tipo "Autor"

CREATE TABLE autores (
    detalle_autor autor
);

/

-- Creación de la tabla "Libros" para almacenar objetos del tipo "Libro"

CREATE TABLE libros (
    detalle_libro libro
);

/