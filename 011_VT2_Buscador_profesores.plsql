-- 0. DESCRIPTION
-- User input postal code using a promt and get the total numbers of teacher on these city, include small validation.
-- Issues: if input is bigger than 10 = outbound exception

-- 1. CLEAN OLD DATA
------------------------------------
DROP TABLE profesor_sede;
DROP TABLE profesores;
DROP TABLE ciudad_sede;


-- 2. CREATE TABLES
------------------------------------
CREATE TABLE profesores (
    dni       VARCHAR(9) PRIMARY KEY,
    nombre    VARCHAR(60) NOT NULL,
    direccion VARCHAR(60) NOT NULL,
    email     VARCHAR(30) NOT NULL,
    edad INT NOT NULL
);

-- Crear la tabla 'ciudad_sede' donde esta el profesor
CREATE TABLE ciudad_sede (
    cod_post VARCHAR(5) PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    habitantes INT
);

-- Crear la tabla 'profesor_sede' para establecer relaciones entre profesores y ciudad_sede
CREATE TABLE profesor_sede (
    profesor_dni VARCHAR(9),
    sede_cp VARCHAR(5),
    fecha DATE,
    horas_trabajadas INT,
    CONSTRAINT dni_fk FOREIGN KEY (profesor_dni) REFERENCES profesores(dni),
    CONSTRAINT cod_post_fk FOREIGN KEY (sede_cp) REFERENCES ciudad_sede(cod_post),
    PRIMARY KEY (profesor_dni, sede_cp, fecha)
);


-- 3. INSERT FAKE DATA
------------------------------------
select * from profesores;
select * from ciudad_sede;
select * from profesor_sede;
-- Insertar registros en la tabla 'profesores'
INSERT INTO profesores VALUES ('12345678A', 'Juan P�rez', 'Calle Mayor 123', 'juan@gmail.com', 25);
INSERT INTO profesores VALUES ('98765432B', 'Laura G�mez', 'Avenida Central 456', 'laura@gmail.com', 28);
INSERT INTO profesores VALUES ('56789012C', 'Pedro Rodr�guez', 'Calle Principal 789', 'pedro@gmail.com', 46);
INSERT INTO profesores VALUES ('58568652A', 'Pablo Gonzo', 'Calle Bailen 12', 'pgon@gmail.com', 33);
INSERT INTO profesores VALUES ('69875234B', 'Sandra Bala', 'Call Mallorca 56', 'sbala@gmail.com', 55);

-- Insertar registros en la tabla 'ciudad_sede'

INSERT INTO ciudad_sede VALUES ('28001', 'Madrid', 3200000);
INSERT INTO ciudad_sede VALUES ('08001', 'Barcelona', 1600000);
INSERT INTO ciudad_sede VALUES ('41001', 'Sevilla', 690566);
INSERT INTO ciudad_sede VALUES ('46001', 'Valencia', 800215);

-- Insertar registros en la tabla 'profesor_sede' para relacionar profesores con ciudad_sede
INSERT INTO profesor_sede VALUES ('12345678A', '28001', TO_DATE('13/01/2024', 'DD/MM/YYYY'), 9 ); 
INSERT INTO profesor_sede VALUES ('12345678A', '28001', TO_DATE('14/01/2024', 'DD/MM/YYYY'), 9 ); 
INSERT INTO profesor_sede VALUES ('12345678A', '28001', TO_DATE('15/01/2024', 'DD/MM/YYYY'), 9 ); 

INSERT INTO profesor_sede VALUES ('98765432B', '08001', TO_DATE('15/01/2024', 'DD/MM/YYYY'), 8 );
INSERT INTO profesor_sede VALUES ('98765432B', '08001', TO_DATE('16/01/2024', 'DD/MM/YYYY'), 8 );

INSERT INTO profesor_sede VALUES ('56789012C', '41001', TO_DATE('20/01/2024', 'DD/MM/YYYY'), 7 );
INSERT INTO profesor_sede VALUES ('56789012C', '41001', TO_DATE('21/01/2024', 'DD/MM/YYYY'), 7 );

INSERT INTO profesor_sede VALUES ('58568652A', '46001', TO_DATE('17/01/2024', 'DD/MM/YYYY'), 7 );
INSERT INTO profesor_sede VALUES ('58568652A', '46001', TO_DATE('18/01/2024', 'DD/MM/YYYY'), 7 );
INSERT INTO profesor_sede VALUES ('58568652A', '46001', TO_DATE('19/01/2024', 'DD/MM/YYYY'), 8 );



-- 4. CREATE A VIEW
------------------------------------
-- Seleccionar todos los profesores y sus sedes correspondiente:
SELECT * FROM profesores;

SELECT
    p.dni,
    p.nombre  AS nombre_profesor,
    p.email,
    cs.nombre AS nombre_sede
FROM
         profesores p
    INNER JOIN profesor_sede ps ON p.dni = ps.profesor_dni
    INNER JOIN ciudad_sede cs ON cc.sede_cp = cs.cod_post;

-- Crear vista de ciudad_sede con m�s de un mill�n de habitantes:
CREATE OR REPLACE VIEW v_ciudad_sede_mas_millon AS
    SELECT
        cod_post,
        nombre,
        habitantes
    FROM
        ciudad_sede
    WHERE
        habitantes > 1000000;

SELECT * FROM v_ciudad_sede_mas_millon;



-- 5. BLOQUE ANONIMO
-------------------------------------------------
SET SERVEROUTPUT ON;
DECLARE
    v_codigo_postal VARCHAR2(10);
    v_numero_profesores NUMBER;
    v_nombre_sede VARCHAR2(60);
BEGIN
    v_codigo_postal := '&codigopostal';

    IF LENGTH(v_codigo_postal) <> 5 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El código postal debe tener exactamente 5 caracteres.');
    END IF;

    SELECT COUNT(*) INTO v_numero_profesores
    FROM profesor_sede
    WHERE sede_cp = v_codigo_postal;

    SELECT nombre INTO v_nombre_sede
    FROM ciudad_sede
    WHERE cod_post = v_codigo_postal;

    DBMS_OUTPUT.PUT_LINE(
        'La sede con código postal ' || 
        v_codigo_postal || 
        ' (' || v_nombre_sede || ') tiene ' || v_numero_profesores || ' profesor(es).');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron profesores para el código postal ' || v_codigo_postal || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END;
/
