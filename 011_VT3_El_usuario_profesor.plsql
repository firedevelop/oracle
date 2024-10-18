ALTER SESSION SET "_ORACLE_SCRIPT" = true;

-- Eliminamos lo que vamos a crear por si lo tenemos ya creado
-- DROP USER Profesor_DAX_M02B CASCADE;
-- DROP ROLE Rol_profe;
-- DROP PROFILE perfil_profe;

-- Crear un nuevo usuario Profesor_DAX_M02B con contrase�a "p1234" sin tablespace
CREATE USER Profesor_DAX_M02B IDENTIFIED BY p1234;

-- Asignar privilegio para seleccionar y actualizar en la vista NOTAS_ALUMNOS_DAX_M02B
GRANT SELECT, UPDATE ON ONLINER.NOTAS_ALUMNOS_DAX_M02B TO Profesor_DAX_M02B;

-- Crear un nuevo rol de profesor "Rol_profe"
CREATE ROLE Rol_profe;

-- Asignar privilegio para crear sesi�n
GRANT CREATE SESSION TO Rol_profe;

-- Asignar privilegio para seleccionar en la tabla alumnos y en la tabla asignaturas
GRANT SELECT ON onliner.alumnos TO Rol_profe;0
GRANT SELECT ON onliner.asignaturas TO Rol_profe;

GRANT Rol_profe TO Profesor_DAX_M02B;

-- Crear un perfil "perfil_profe" que permita 2 intentos de contrase�a m�ximo
CREATE PROFILE perfil_profe LIMIT
  FAILED_LOGIN_ATTEMPTS 2;

-- Asociar el perfil "perfil_profe" al usuario Profesor_DAX_M02B
ALTER USER Profesor_DAX_M02B PROFILE perfil_profe;

-- Actualizar la nota de los alumnos en la vista NOTAS_ALUMNOS_DAX_M02B un 10%
-- Supongo que tienes una vista llamada NOTAS_ALUMNOS_DAX_M02B y quieres aumentar todas las notas en un 10%.
-- Esto se hace mediante una consulta de actualizaci�n. Aseg�rate de tener una vista con el nombre correcto.
CONN Profesor_DAX_M02B / p1234;

UPDATE ONLINER.NOTAS_ALUMNOS_DAX_M02B
SET nota = nota * 1.10;

SELECT * FROM ONLINER.NOTAS_ALUMNOS_DAX_M02B;
ROLLBACK;



   
    SET SERVEROUTPUT ON;
-- Declaración de una variable para almacenar el promedio calculado de cada asignatura.
DECLARE
    promedio_asig FLOAT;
    -- Declaración de una variable para almacenar el nombre de cada asignatura.
    nombre_asig VARCHAR(25);
    
    -- Declaración de un cursor. Un cursor es una estructura que permite recorrer las filas que devuelve una consulta SQL.
    -- Este cursor seleccionará el nombre de cada asignatura y el promedio de sus notas.
    CURSOR cursor_asignaturas IS
        SELECT a.nombre, AVG(n.nota) as promedio
        FROM notas n
        JOIN asignaturas a ON n.codigo_asig = a.codigo_asig
        GROUP BY a.nombre; 

BEGIN
    -- Apertura del cursor declarado anteriormente para comenzar a procesar sus filas.
    OPEN cursor_asignaturas;
    LOOP
        -- Recupera la siguiente fila del cursor. Si no hay más filas, el bucle terminará.
        FETCH cursor_asignaturas INTO nombre_asig, promedio_asig;
        -- Verifica si el cursor ha recorrido todas las filas. Si es así, sale del bucle.
        EXIT WHEN cursor_asignaturas%NOTFOUND;
        
        -- Condición que verifica si el promedio de la asignatura es mayor a 5.
        IF promedio_asig > 7 THEN
            -- Si la condición se cumple, imprime un mensaje indicando el nombre de la asignatura y su promedio.
            DBMS_OUTPUT.PUT_LINE('La asignatura ' || nombre_asig || ' tiene un promedio superior a 7: ' || promedio_asig);
        END IF;
    END LOOP;
    -- Cierra el cursor una vez que se han procesado todas las filas.
    CLOSE cursor_asignaturas;
EXCEPTION
    -- Sección de manejo de excepciones. Captura cualquier error que ocurra durante la ejecución del bloque.
    WHEN OTHERS THEN
        -- Imprime un mensaje de error utilizando la función SQLERRM que devuelve el mensaje de error del último error ocurrido.
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
