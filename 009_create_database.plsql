create table autor(
    idautor int primary key,
    nombre varchar(50),
    apellido varchar(50),
    email varchar(50)
);

CREATE TABLE libro (
    idlibro INT PRIMARY KEY,
    titulo VARCHAR(100),
    precio DECIMAL(10, 2),
    idautor INT,
    FOREIGN KEY (idautor) REFERENCES autor(idautor) ON DELETE CASCADE
);


select * from libro;
select * from autor;

UPDATE autor
SET email = 'juan2@gmail.com'
WHERE idautor = 1;

DELETE FROM autor
WHERE idautor = 4;

INSERT INTO autor (idautor, nombre, email) VALUES (1, 'Juan Pérez', 'juan.perez@example.com');
INSERT INTO autor (idautor, nombre, email) VALUES (2, 'Maria García', 'maria.garcia@example.com');
INSERT INTO autor (idautor, nombre, email) VALUES (3, 'Luis Fernández', 'luis.fernandez@example.com');
INSERT INTO autor (idautor, nombre, email) VALUES (4, 'Ana López', 'ana.lopez@example.com');

INSERT INTO libro (idlibro, titulo, precio, idautor) VALUES (1, 'Aprendiendo SQL', 9.99, 1);
INSERT INTO libro (idlibro, titulo, precio, idautor) VALUES (2, 'Programación en Python', 15.50, 2);
INSERT INTO libro (idlibro, titulo, precio, idautor) VALUES (3, 'Introducción a la IA', 12.75, 3);
INSERT INTO libro (idlibro, titulo, precio, idautor) VALUES (4, 'Desarrollo Web', 8.99, 1);
INSERT INTO libro (idlibro, titulo, precio, idautor) VALUES (5, 'Ciencia de Datos', 19.99, 4);


SELECT
    libro.titulo,
    libro.precio,
    autor.nombre
FROM
    autor
INNER JOIN libro ON autor.idautor = libro.idautor
WHERE   
    libro.precio < 10.00;