
-- Conectar con onliner
-- conn onliner / onliner1234;

-- Crea las tablas con el usuario Onliner que tine ALL privileges
-- Crear tabla alumno.
--DROP TABLE notas;
--DROP TABLE alumnos;
--DROP TABLE asignaturas;

-- Crear tabla alumno.
drop table notas;
drop table alumnos;
drop table asignaturas;

CREATE TABLE alumnos (
    id_alumno        INT PRIMARY KEY,
    nombre_completo  VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL
);

-- Crear tabla asignaturas
CREATE TABLE asignaturas (
    codigo_asig VARCHAR(10) PRIMARY KEY,
    nombre      VARCHAR(25) NOT NULL
);

-- Crear tabla notas
CREATE TABLE notas (
    id_alumno   INT,
    codigo_asig VARCHAR(10),
    nota        FLOAT NOT NULL,
    CONSTRAINT id_alumno_fk FOREIGN KEY ( id_alumno )
        REFERENCES alumnos ( id_alumno ),
    CONSTRAINT codigo_asig_fk FOREIGN KEY ( codigo_asig )
        REFERENCES asignaturas ( codigo_asig ),
    PRIMARY KEY ( id_alumno,
                  codigo_asig )
);

-- INSERTAR DATOS
INSERT INTO alumnos VALUES (1,'Juan Fernando Pérez del Corral','10/02/2005');
INSERT INTO alumnos VALUES (2,'Valentina Laverde de la Rosa','13/10/2005');
INSERT INTO alumnos VALUES (3,'Óscar de la Renta','15/08/2006');
INSERT INTO alumnos VALUES (4,'Sara Teresa Sánchez del Pinar','02/09/2005');
INSERT INTO alumnos VALUES (5,'Efraín de las Casas Mejía','19/08/2005');
INSERT INTO alumnos VALUES (6,'Julieta Ponce de León','05/02/2006');
INSERT INTO alumnos VALUES (7,'Martín Elías de los Ríos Acosta','02/04/2006');
INSERT INTO alumnos VALUES (8,'Gabriel del Cristo','24/06/2006');
INSERT INTO alumnos VALUES (9,'Juana de la Santísima Cruz','29/10/2007');
INSERT INTO alumnos VALUES (10,'Jairo de Jesús','30/05/2005');


INSERT INTO asignaturas VALUES ('DAX_M01','Sistemas Informáticos');
INSERT INTO asignaturas VALUES ('DAX_M02A','Bases de Datos A');
INSERT INTO asignaturas VALUES ('DAX_M02B','Bases de Datos B');
INSERT INTO asignaturas VALUES ('DAX_M03A','Programación A');
INSERT INTO asignaturas VALUES ('DAX_M03B','Programación B');
INSERT INTO asignaturas VALUES ('DAX_M04','Lenguajes de Marcas');
INSERT INTO asignaturas VALUES ('DAX_M05','Entornos de desarrollo');

 
INSERT INTO notas VALUES ('1','DAX_M01','6');
INSERT INTO notas VALUES ('2','DAX_M01','3');
INSERT INTO notas VALUES ('7','DAX_M01','3');
INSERT INTO notas VALUES ('8','DAX_M01','10');
INSERT INTO notas VALUES ('9','DAX_M01','7');
INSERT INTO notas VALUES ('10','DAX_M01','6');
INSERT INTO notas VALUES ('1','DAX_M02A','6');
INSERT INTO notas VALUES ('4','DAX_M02A','9');
INSERT INTO notas VALUES ('9','DAX_M02A','5');
INSERT INTO notas VALUES ('10','DAX_M02A','6');
INSERT INTO notas VALUES ('1','DAX_M03A','4');
INSERT INTO notas VALUES ('2','DAX_M03A','7');
INSERT INTO notas VALUES ('3','DAX_M03A','10');
INSERT INTO notas VALUES ('7','DAX_M03A','9');
INSERT INTO notas VALUES ('8','DAX_M03A','3');
INSERT INTO notas VALUES ('9','DAX_M03A','6');
INSERT INTO notas VALUES ('10','DAX_M03A','4');
INSERT INTO notas VALUES ('4','DAX_M02B','3');
INSERT INTO notas VALUES ('5','DAX_M02B','3');
INSERT INTO notas VALUES ('6','DAX_M03B','10');
INSERT INTO notas VALUES ('7','DAX_M03B','8');
INSERT INTO notas VALUES ('8','DAX_M03B','9');
INSERT INTO notas VALUES ('9','DAX_M03B','4');
INSERT INTO notas VALUES ('10','DAX_M03B','4');
INSERT INTO notas VALUES ('1','DAX_M04','5');
INSERT INTO notas VALUES ('2','DAX_M04','8');
INSERT INTO notas VALUES ('3','DAX_M04','9');


-- Crear una vista para consultar los datos de los alumnos asignaturas y notas de la asignatura DAX_M02B
CREATE OR REPLACE VIEW NOTAS_ALUMNOS_DAX_M02B AS
SELECT 
    alumnos.nombre_completo,
    asignaturas.nombre,
    notas.nota
FROM
    notas
        INNER JOIN
    alumnos ON notas.id_alumno = alumnos.id_alumno
        INNER JOIN
    asignaturas ON notas.codigo_asig = asignaturas.codigo_asig
    WHERE asignaturas.codigo_asig = 'DAX_M02B' 
ORDER BY asignaturas.codigo_asig DESC;
