SET SERVEROUTPUT ON;

-- Definición de Tipos de Objetos

-- Crear un tipo OBJETO DIRECCION
-- Es como crear una plantilla para la información de dirección que vamos a almacenar.

CREATE OR REPLACE TYPE direccion_obj AS OBJECT (
    calle       VARCHAR2(20),
    cp          VARCHAR2(5),
    poblacion   VARCHAR2(20),
    provincia   VARCHAR2(20)
);
/

-- Crear un tipo OBJETO PERSONA
-- crea una nueva plantilla para una 'Persona', con campos para el ID, DNI, nombre, etc.
CREATE OR REPLACE TYPE persona_obj AS OBJECT (
    idpersona   NUMBER,
    dni         VARCHAR2(9),
    nombre      VARCHAR2(15),
    apellidos   VARCHAR2(30),
    fecha_nac   DATE
);
/

/*
Adición de Funcionalidades a los Objetos
 Imagina que a nuestro formulario de 'Persona' le estamos añadiendo la capacidad de calcular algo;
en este caso, la edad. La función 'muestraedad' actúa como una calculadora incorporada en nuestro formulario que puede decirnos la edad de la persona.
*/
CREATE OR REPLACE TYPE persona_obj AS OBJECT (
    idpersona   NUMBER,
    dni         VARCHAR2(9),
    nombre      VARCHAR2(15),
    apellidos   VARCHAR2(30),
    fecha_nac   DATE,
    MEMBER FUNCTION muestraedad RETURN NUMBER, -- Añadir funcion que muestra la edad
    pragma      restrict_references(muestraedad, wnds) --evita que el método pueda modificar las tablas de la BD
);
/

/*
 Función de resta de años  para nuestra calculadora de edad. 
 Le estamos diciendo cómo calcular la edad tomando la fecha actual y restándole la fecha de nacimiento.
 */
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


-- Uso de Objetos en Bloques de Código
-- Vemos como funciona el metodo en un bloque anonimo

DECLARE
    v_trabajador1 persona_obj;
    v_trabajador2 persona_obj;
    v_trabajador3 persona_obj;
    v_edadmedia float;
    v_media int;
BEGIN
    v_trabajador1 := persona_obj(1, '11111111A', 'Alberto', 'Olivia', '22/01/1989');
    v_trabajador2 := persona_obj(2, '22222222B', 'Juan', 'Piris', '11/11/2002');
    v_trabajador3 := persona_obj(3, '33333333C', 'Sofia', 'Molina', '24/12/1990');

    v_edadmedia := ROUND((v_trabajador1.muestraedad() + v_trabajador2.muestraedad() + v_trabajador3.muestraedad()) / 3 ,2);
    
    
    dbms_output.put_line('La edad del trabajador 1 es: ' || v_trabajador1.muestraedad());
    
    
    dbms_output.put_line('La edad media de los empleados es de: ' || v_edadmedia || ' años');
END;
/

-- Creación y Manipulación de Tablas
-- Crear nueva tabla empleados usando los objetos creados anteriormente
CREATE TABLE empleados (
    datos_empleado   persona_obj,
    direc_empleado   direccion_obj
);
/


-- Añadimos clave primaria a la tabla
ALTER TABLE empleados ADD
CONSTRAINT pk_id PRIMARY KEY (datos_empleado.idpersona);

-- Agregamos valores a la tabla
INSERT INTO empleados VALUES (
    persona_obj(1, '11111111A', 'Alberto', 'Olivia', '22/01/1989'),
    direccion_obj('C/Bailen 169', '08041', 'Barcelona', 'Barcelona')
);

INSERT INTO empleados VALUES (
    persona_obj(2, '22222222B', 'Juan', 'Piris', '11/11/2002'),
    direccion_obj('C/Arago 120', '08041', 'Badalona', 'Barcelona')
);

INSERT INTO empleados VALUES (
    persona_obj(3, '33333333C', 'Sofia', 'Molina', '24/12/1990'),
    direccion_obj('C/Valencia 230', '08023', 'Molins de Rei', 'Barcelona')
);

-- Consultas y Actualizaciones

-- Como hacer un Select en este tipo de tablas
SELECT
    emple.datos_empleado.idpersona AS "ID",
    emple.datos_empleado.nombre AS "NOMBRE",
    emple.datos_empleado.muestraedad() AS "EDAD",
    emple.direc_empleado.calle AS "CALLE"
FROM
    empleados emple;

-- Como hacer un UPDATE en este tipo de tablas
UPDATE empleados e SET e.direc_empleado.calle = 'C/corcega 190' WHERE e.datos_empleado.idpersona = 3;

-- Como hacer un DELETE en este tipo de tablas

DELETE FROM empleados e
WHERE
    e.datos_empleado.idpersona = 1;   
    
    
    -- Modificar el tipo para incluir el umbral de presupuesto
CREATE OR REPLACE TYPE departamento_obj AS OBJECT (
    iddepto           NUMBER,
    nombre            VARCHAR2(30),
    presupuesto       NUMBER,
    fecha_creacion    DATE,
    MEMBER FUNCTION verificar_presupuesto RETURN VARCHAR2
);
/

-- Modificar el cuerpo del tipo para implementar la nueva lógica de verificación
CREATE OR REPLACE TYPE BODY departamento_obj AS
    MEMBER FUNCTION verificar_presupuesto RETURN VARCHAR2 IS
    v_presupuesto VARCHAR2(100);
    BEGIN
        IF presupuesto > 1000 THEN
            v_presupuesto := 'El presupuesto es suficiente.';
        ELSE
            v_presupuesto := 'Atención: El presupuesto está por debajo del umbral.';
        END IF;
        
        RETURN v_presupuesto;
        
    END verificar_presupuesto;
END;
/

CREATE TABLE Presupuestos (
datos_pres departamento_obj
);

INSERT INTO Presupuestos VALUES (
departamento_obj('1001', 'IT', 10000, '18/11/2024')); 

SELECT  p.datos_pres.nombre AS Nombre, 
        p.datos_pres.verificar_presupuesto() AS Pres 
    FROM Presupuestos p;
    