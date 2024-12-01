
/*
Paso 1: Crear el Supertipo Trabajador
Este será nuestro tipo general para todos los trabajadores y será marcado como NOT FINAL para que pueda ser extendido por otros subtipos.
*/
DROP TABLE empleados;
DROP TABLE gerentes;
DROP TYPE gerente;
DROP TYPE empleado;
DROP TYPE trabajador;

CREATE TYPE Trabajador AS OBJECT (
  id_trabaja NUMBER,
  nombre VARCHAR2(100),
  fecha_contratacion DATE,
  MEMBER FUNCTION calcular_antiguedad RETURN NUMBER
) NOT FINAL ;
/
/*
Paso 2: Hacer el Supertipo NOT INSTANTIABLE
Marcamos el tipo Trabajador como NOT INSTANTIABLE si queremos que actúe solo como un supertipo, 
es decir, no queremos crear instancias directas de Trabajador, solo de sus subtipos.
*/
ALTER TYPE Trabajador NOT INSTANTIABLE;

/
-- Comprobar la instrucción NOT INSTANTIABLE
DECLARE
  trabaja1 Trabajador;
BEGIN
  trabaja1 := Trabajador(1, 'Juan Pérez', DATE '2020-01-10'); -- Esto debería fallar
END;

/
/*
Paso 3: Crear el Subtipo Empleado
Usamos la cláusula UNDER para heredar las propiedades y métodos del supertipo Trabajador.
*/
CREATE TYPE Empleado UNDER Trabajador (
  salario NUMBER,
  departamento VARCHAR2(100),
  MEMBER FUNCTION calcular_salario_anual RETURN NUMBER
);
/
/*
Paso 4: Crear el Subtipo Gerente
Este subtipo también hereda del supertipo Trabajador y puede tener atributos adicionales como un bono.
*/
CREATE TYPE Gerente UNDER Trabajador (
  bono_gerente NUMBER
);
/
/*
Paso 5: Implementación de Funciones
Implementamos las funciones miembro para cada tipo.
*/

-- Funcion de antigüedad del tipo trabajador
CREATE OR REPLACE TYPE BODY Trabajador AS 
  MEMBER FUNCTION calcular_antiguedad RETURN NUMBER IS
  BEGIN
    RETURN MONTHS_BETWEEN(SYSDATE, fecha_contratacion) / 12;
  END;
END;
/

-- Funcion calculo salario del tipo empleado
CREATE OR REPLACE TYPE BODY Empleado AS 
  MEMBER FUNCTION calcular_salario_anual RETURN NUMBER IS
    salario_anual NUMBER;
  BEGIN
    salario_anual := salario * 12;
    RETURN salario_anual;
  END;
END;
/
/*
Paso 6: Crear Tablas y Insertar Datos
Finalmente, creamos una tabla para manejar empleados y gerentes e insertamos algunos datos.
*/

CREATE TABLE empleados OF empleado (
  id_trabaja PRIMARY KEY,
  salario NOT NULL
  );
  

CREATE TABLE gerentes OF gerente (
  id_trabaja PRIMARY KEY
  );
  
INSERT INTO empleados VALUES (
  Empleado(1, 'Juan Pérez', DATE '2020-01-10', 3000, 'IT')
);

INSERT INTO gerentes VALUES (
  Gerente(1, 'Ana Gómez', DATE '2018-08-15', 5000)
);


SELECT * FROM empleados;

SELECT * FROM gerentes;





/*
Ejemplo de Herencia
Creación de un Supertipo persona_obj:
Este tipo incluye información común de personas y una función miembro para mostrar la edad.
Creación de Subtipos tipo_profesor, tipo_estudiante:
Estos tipos heredan de persona_obj y agregan atributos específicos para profesors y estudiantes.
Creación de Tablas y Inserción de Datos:
Similar a los vehículos, se crean tablas para profesors y estudiantes e insertan datos.
*/
-- Hacer que este tipo de objeto ahora además sea un supertipo que permita Herencia

DROP TYPE profesor;
DROP TYPE ESTUDIANTE;
DROP TYPE PERSONA_OBJ;

CREATE OR REPLACE TYPE persona_obj AS OBJECT (
    idpersona   NUMBER,
    dni         VARCHAR2(9),
    nombre      VARCHAR2(15),
    apellidos   VARCHAR2(30),
    fecha_nac   DATE,
    MEMBER FUNCTION muestraedad RETURN NUMBER, -- Añadir funcion que muestra la edad
    pragma      restrict_references(muestraedad, wnds) --evita que el método pueda modificar las tablas de la BD
)NOT FINAL NOT INSTANTIABLE; 
/

CREATE OR REPLACE TYPE BODY persona_obj AS
    MEMBER FUNCTION muestraedad RETURN NUMBER IS
    v_ahoy number;
    v_anac number;
    v_edad number;
    BEGIN
        v_ahoy := TO_NUMBER(TO_CHAR(sysdate, 'YYYY'));
        v_anac := TO_NUMBER(TO_CHAR(fecha_nac, 'YYYY'));
        v_edad := v_ahoy - v_anac;
        
        RETURN v_edad;
    END muestraedad;
END;
/


CREATE OR REPLACE TYPE tipo_profesor UNDER persona_obj (
    especialidad     VARCHAR2(50),
    sueldo    NUMBER
);
/
CREATE OR REPLACE TYPE tipo_estudiante UNDER persona_obj (
    ciclo         VARCHAR2(10),
    pagado    NUMBER
);
/

DROP TABLE tabla_profesor;
CREATE TABLE tabla_profesor OF tipo_profesor
(PRIMARY KEY (idpersona));

DROP TABLE tabla_estudiante;
CREATE TABLE tabla_estudiante OF tipo_estudiante
(PRIMARY KEY (idpersona));
    
-- Inserción en tabla_profesor
INSERT INTO tabla_profesor VALUES (1, '44444444A', 'Javier', 'Lopez', TO_DATE('01/01/1992', 'DD/MM/YYYY'), 'Matemáticas', 2000);
INSERT INTO tabla_profesor VALUES (2, '55555555B', 'Carlos', 'Gomez', TO_DATE('15/03/1985', 'DD/MM/YYYY'), 'Física', 1800);
INSERT INTO tabla_profesor VALUES (3, '66666666C', 'Ana', 'Martinez', TO_DATE('20/05/1978', 'DD/MM/YYYY'), 'Historia', 2200);
INSERT INTO tabla_profesor VALUES (4, '77777777D', 'Luisa', 'Rodriguez', TO_DATE('10/10/1990', 'DD/MM/YYYY'), 'Química', 1900);
INSERT INTO tabla_profesor VALUES (5, '88888888E', 'María', 'González', TO_DATE('05/08/1983', 'DD/MM/YYYY'), 'Biología', 2100);

-- Inserción en tabla_estudiante
INSERT INTO tabla_estudiante VALUES (1, '99999999F', 'Elena', 'López', TO_DATE('01/09/2001', 'DD/MM/YYYY'), 'DAM', 100);
INSERT INTO tabla_estudiante VALUES (2, '11111111G', 'Luis', 'Pérez', TO_DATE('15/07/1999', 'DD/MM/YYYY'), 'DAW', 150);
INSERT INTO tabla_estudiante VALUES (3, '22222222H', 'Ana', 'García', TO_DATE('20/11/2000', 'DD/MM/YYYY'), 'DAW', 825);
INSERT INTO tabla_estudiante VALUES (4, '33333333I', 'Carlos', 'Sánchez', TO_DATE('05/03/2002', 'DD/MM/YYYY'), 'DAM', 250);
INSERT INTO tabla_estudiante VALUES (5, '44444444J', 'Laura', 'Fernández', TO_DATE('10/12/1998', 'DD/MM/YYYY'), 'DAM', 450);
/

SET SERVEROUTPUT ON

DECLARE
    CURSOR profesor_cursor IS
        SELECT *
        FROM tabla_PROFESOR t;
        
    CURSOR estudiante_cursor IS
        SELECT *
        FROM tabla_estudiante t;
        
    profesor_rec profesor_cursor%ROWTYPE;
    estudiante_rec estudiante_cursor%ROWTYPE;
BEGIN
    -- Mostrar datos de profesores
    DBMS_OUTPUT.PUT_LINE('Datos de Profesores:');
    DBMS_OUTPUT.PUT_LINE('------------------------');
    OPEN profesor_cursor;
    LOOP
        FETCH profesor_cursor INTO profesor_rec;
        EXIT WHEN profesor_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || profesor_rec.idpersona);
        DBMS_OUTPUT.PUT_LINE('DNI: ' || profesor_rec.dni);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || profesor_rec.nombre);
        DBMS_OUTPUT.PUT_LINE('Apellidos: ' || profesor_rec.apellidos);
        DBMS_OUTPUT.PUT_LINE('Fecha de Nacimiento: ' || TO_CHAR(profesor_rec.fecha_nac, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Especialidad: ' || profesor_rec.especialidad);
        DBMS_OUTPUT.PUT_LINE('Sueldo: ' || profesor_rec.sueldo);
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;
    CLOSE profesor_cursor;
    
    -- Mostrar datos de estudiantes
    DBMS_OUTPUT.PUT_LINE('Datos de Estudiantes:');
    DBMS_OUTPUT.PUT_LINE('------------------------');
    OPEN estudiante_cursor;
    LOOP
        FETCH estudiante_cursor INTO estudiante_rec;
        EXIT WHEN estudiante_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || estudiante_rec.idpersona);
        DBMS_OUTPUT.PUT_LINE('DNI: ' || estudiante_rec.dni);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || estudiante_rec.nombre);
        DBMS_OUTPUT.PUT_LINE('Apellidos: ' || estudiante_rec.apellidos);
        DBMS_OUTPUT.PUT_LINE('Fecha de Nacimiento: ' || TO_CHAR(estudiante_rec.fecha_nac, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Ciclo: ' || estudiante_rec.ciclo);
        DBMS_OUTPUT.PUT_LINE('Pagado: ' || estudiante_rec.pagado);
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;
    CLOSE estudiante_cursor;
END;
/
