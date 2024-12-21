SET SERVEROUTPUT ON
-- VARRAY

/*
1- Crear el tipo Varray:
En este paso, definiremos el tipo Varray para almacenar las notas de los estudiantes en una asignatura. 
Supongamos que cada estudiante puede tener hasta 5 notas y usaremos el tipo NUMBER para las notas.
*/
DROP Type notas_type FORCE;
CREATE OR REPLACE TYPE notas_type AS VARRAY(6) OF NUMBER;
-- Creamos un nuevo tipo llamado "notas_type" que es un Varray con un límite de 5 elementos de tipo NUMBER.
/
/*
2- Crear la tabla "estudiante":
Crearemos la tabla "estudiante" que utilizará el tipo Varray para almacenar las notas de los estudiantes en una asignatura.
*/
DROP TABLE estudiante;
CREATE TABLE estudiante (
    estudiante_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    notas notas_type
);
-- Creamos la tabla "estudiante" con tres columnas: "estudiante_id" como clave primaria, "nombre" para el nombre del estudiante y "notas" que utiliza el tipo Varray "notas_type" para almacenar las notas.
/
/*
3- Insertar datos en la tabla:
Insertaremos algunos datos de estudiantes con sus respectivas notas en la tabla "estudiante".
*/

INSERT INTO estudiante VALUES (1, 'Juan', notas_type(8, 9, 8,6,4));
INSERT INTO estudiante VALUES (2, 'Maria', notas_type(9, 8, 5,3));
INSERT INTO estudiante VALUES (3, 'Pedro', notas_type(7, 7, 8));
INSERT INTO estudiante (estudiante_id, nombre) VALUES (4, 'Emilio');
-- Insertamos tres registros en la tabla "estudiante" con sus respectivas notas utilizando el tipo Varray.

/*
4- Consultar datos de la tabla:
Haremos una consulta para obtener las notas de un estudiante en particular.
*/

SELECT nombre, notas FROM estudiante WHERE estudiante_id = 2;
-- Consultamos el nombre y las notas del estudiante con "estudiante_id" igual a 2.

/*
Bloque Anónimo para Varray:
consultar los datos de todos los estudiantes en la tabla "estudiante" 
*/
/

INSERT INTO estudiante VALUES (5, 'Ivan', notas_type(4, 5, 6,7,8,NULL));

INSERT INTO estudiante VALUES (6, 'Javier', notas_type(NULL, NULL, NULL,NULL,NULL,NULL));

INSERT INTO estudiante VALUES (7, 'Juanmi', NULL);

-- Bloque Anónimo para consultar datos de todos los estudiantes con Varray
DECLARE
    -- Declarar variables para almacenar datos
    estudiante_nombre VARCHAR2(50);
    notas_estudiante notas_type;
    
BEGIN
    -- Loop para recorrer todos los estudiantes
    FOR estudiante_rec IN (SELECT nombre, notas FROM estudiante WHERE estudiante_id = 7) LOOP
        estudiante_nombre := estudiante_rec.nombre;
        notas_estudiante := estudiante_rec.notas;

        -- Mostrar los datos del estudiante
        DBMS_OUTPUT.PUT_LINE('Nombre del estudiante: ' || estudiante_nombre);
        DBMS_OUTPUT.PUT_LINE('Notas del estudiante:');
        if  notas_estudiante is not null THEN
             FOR i IN 1..notas_estudiante.count LOOP
   --         IF notas_estudiante(i) > 7 THEN
                DBMS_OUTPUT.PUT_LINE('Nota ' || i || ': ' || notas_estudiante(i));
   --         END IF;
            END LOOP;
        END IF;
        -- Separador entre estudiantes
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
END;
/

-- TABLAS ANIDADAS
/*
1- Crear el tipo de tabla anidada:
Definiremos el tipo de tabla anidada que representará la información de los libros en una biblioteca. 
Cada registro de esta tabla anidada contendrá información sobre un libro, como su título y autor.
*/

CREATE OR REPLACE TYPE libro_type AS OBJECT (
    titulo VARCHAR2(100),
    autor VARCHAR2(50)
);
-- Creamos un nuevo tipo llamado "libro_type" que es un objeto con dos atributos: "titulo" y "autor".
/
/*
2- Crear la tabla "biblioteca":
Crearemos la tabla "biblioteca" que utilizará la tabla anidada "libro_type" para almacenar información sobre los libros disponibles en la biblioteca.
*/
-- Creamos un tipo tabla
CREATE TYPE tabla_libros AS
    TABLE OF libro_type;
 /   

 -- Creamos la tabla
CREATE TABLE biblioteca (
    biblioteca_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    libros tabla_libros
) NESTED TABLE libros STORE AS libros_tabla;

/* Creamos la tabla "biblioteca" con tres columnas: "biblioteca_id" como clave primaria, "nombre" para el nombre de la biblioteca y "libros" que utiliza el tipo de tabla anidada "libro_type" para almacenar información sobre los libros. 
-- La cláusula NESTED TABLE especifica cómo almacenar la tabla anidada.
Cuando se utiliza NESTED TABLE, se está definiendo una relación entre una tabla principal (contenedora) y una tabla anidada
la columna "libros" en la tabla "biblioteca" es una tabla anidada que almacena los libros en una tabla independiente llamada "libros_tabla". 
Esto permite gestionar y consultar los libros de cada biblioteca de manera más eficiente.
*/

/*
3- Insertar datos en la tabla:
Insertaremos algunos datos en la tabla "biblioteca" junto con los libros disponibles en cada biblioteca.
*/

INSERT INTO biblioteca VALUES (1, 'Biblioteca Central', tabla_libros(libro_type('El Gran Gatsby', 'F. Scott Fitzgerald'), 
                                                                                                                            libro_type('1984', 'George Orwell')));
                                                                                                                            
INSERT INTO biblioteca VALUES (2, 'Biblioteca del Campus',  tabla_libros(libro_type('Cien Años de Soledad', 'Gabriel García Márquez'), 
                                                                                                                                    libro_type('Matar un Ruiseñor', 'Harper Lee')));
-- Insertamos dos registros en la tabla "biblioteca", cada uno con una lista de libros utilizando la tabla anidada "libro_type".

select * from biblioteca;

/*
4- Consultar datos de la tabla:
Haremos una consulta para obtener los libros disponibles en una biblioteca en particular.
*/

SELECT nombre, libros FROM biblioteca WHERE biblioteca_id = 2;
-- Consultamos el nombre de la biblioteca y la lista de libros disponibles en la biblioteca con "biblioteca_id" igual a 2.

/*
Bloque Anónimo para Tabla Anidada:
bloque anónimo consulta todos los registros en la tabla "biblioteca" y utiliza un bucle FOR para recorrer cada biblioteca.
*/
/-- Bloque Anónimo para consultar datos de la tabla biblioteca con Tabla Anidada
DECLARE
    -- Declarar variables para almacenar datos
    biblioteca_id NUMBER;
    biblioteca_nombre VARCHAR2(100);
    libros_tabla  tabla_libros;
    
BEGIN
    -- Loop para recorrer todas las bibliotecas
    FOR biblioteca_rec IN (SELECT biblioteca_id, nombre, libros FROM biblioteca) LOOP
        biblioteca_id := biblioteca_rec.biblioteca_id;
        biblioteca_nombre := biblioteca_rec.nombre;
        libros_tabla := biblioteca_rec.libros;

        -- Mostrar los datos de la biblioteca
        DBMS_OUTPUT.PUT_LINE('Biblioteca ID: ' || biblioteca_id);
        DBMS_OUTPUT.PUT_LINE('Nombre de la biblioteca: ' || biblioteca_nombre);
        
        -- Mostrar los libros en la biblioteca
        DBMS_OUTPUT.PUT_LINE('Libros en la biblioteca:');
        FOR i IN 1..libros_tabla.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Título: ' || libros_tabla(i).titulo || ', Autor: ' || libros_tabla(i).autor);
        END LOOP;

        -- Separador entre bibliotecas
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
END;
/
