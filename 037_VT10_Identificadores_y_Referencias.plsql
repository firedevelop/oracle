DROP TABLE AUTORES;
DROP TYPE AUTOR;

DROP TABLE LIBROS;
DROP TYPE LIBRO;

-- Paso 1: Crear el tipo de objeto 'Autor'
-- Este tipo representa a un autor con un identificador único, nombre y fecha de nacimiento.
CREATE TYPE Autor AS OBJECT (
  autor_id NUMBER,
  nombre VARCHAR2(100),
  fecha_nacimiento DATE
);
/

-- Paso 2: Crear la tabla 'Autores' para almacenar objetos del tipo 'Autor'
-- El identificador del objeto (OID) será el 'autor_id', que es la clave primaria.
CREATE TABLE Autores OF Autor (
  autor_id PRIMARY KEY
);
/

-- Paso 3: Crear el tipo de objeto 'Libro'
-- Cada libro tiene un identificador único, título, una referencia a un 'Autor' y fecha de publicación.
CREATE TYPE Libro AS OBJECT (
  libro_id NUMBER,
  titulo VARCHAR2(255),
  autor_ref REF Autor,  -- Referencia al tipo 'Autor'
  fecha_publicacion DATE
);
/

-- Paso 4: Crear la tabla 'Libros' para almacenar objetos del tipo 'Libro'
-- Utilizamos el tipo REF para vincular cada libro con su autor correspondiente.
CREATE TABLE Libros OF Libro (
  libro_id PRIMARY KEY,
  titulo NOT NULL
);
/

-- Paso 5: Insertar autores en la tabla 'Autores'
-- Insertamos dos autores que serán referenciados en la tabla 'Libros'.
INSERT INTO Autores (autor_id, nombre, fecha_nacimiento) VALUES (1, 'Gabriel García Márquez', TO_DATE('1927-03-06', 'YYYY-MM-DD'));
INSERT INTO Autores (autor_id, nombre, fecha_nacimiento) VALUES (2, 'J.K. Rowling', TO_DATE('1965-07-31', 'YYYY-MM-DD'));
/

-- Paso 6: Insertar libros en la tabla 'Libros' con referencias a autores
-- Insertamos libros y utilizamos la palabra clave 'REF' para obtener la referencia del autor.
DECLARE
  ref_autor1 REF Autor;
  ref_autor2 REF Autor;
BEGIN
  SELECT REF(a) INTO ref_autor1 FROM Autores a WHERE a.autor_id = 1;
  SELECT REF(a) INTO ref_autor2 FROM Autores a WHERE a.autor_id = 2;

  INSERT INTO Libros (libro_id, titulo, autor_ref, fecha_publicacion) VALUES (1, 'Cien años de soledad', ref_autor1, TO_DATE('1967-06-05', 'YYYY-MM-DD'));
  INSERT INTO Libros (libro_id, titulo, autor_ref, fecha_publicacion) VALUES (2, 'Harry Potter y la piedra filosofal', ref_autor2, TO_DATE('1997-06-26', 'YYYY-MM-DD'));
END;
/

-- Paso 7: Consultar los libros y sus autores
-- Utilizamos DEREF() para desreferenciar la referencia y obtener detalles del autor.
SELECT l.titulo, DEREF(l.autor_ref).nombre AS nombre_autor
FROM Libros l;

SELECT * FROM autores;
SELECT * FROM libros;