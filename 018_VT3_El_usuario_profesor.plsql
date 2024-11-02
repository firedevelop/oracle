ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

SET SERVEROUTPUT ON;

-- Declaración de una variable para almacenar el promedio calculado de cada asignatura.
DECLARE
    promedio_asig FLOAT;
 
    -- Declaración de una variable para almacenar el nombre de cada asignatura.
    nombre_asig   VARCHAR(25);
 
    -- Declaración de un cursor. Un cursor es una estructura que permite recorrer las filas que devuelve una consulta SQL.
    -- Este cursor seleccionará el nombre de cada asignatura y el promedio de sus notas.
    CURSOR cursor_asignaturas IS
    SELECT
        a.nombre,
        avg(n.nota) AS promedio
    FROM
        notas       n
        JOIN asignaturas a
        ON n.codigo_asig = a.codigo_asig
    GROUP BY
        a.nombre;
BEGIN
 
    -- Apertura del cursor declarado anteriormente para comenzar a procesar sus filas.
    OPEN cursor_asignaturas;
    LOOP

        -- Recupera la siguiente fila del cursor. Si no hay más filas, el bucle terminará.
        FETCH cursor_asignaturas INTO nombre_asig, promedio_asig;
        
 
        -- Verifica si el cursor ha recorrido todas las filas. Si es así, sale del bucle.
        EXIT WHEN cursor_asignaturas%notfound;
 
        -- Condición que verifica si el promedio de la asignatura es mayor a 5.
        IF promedio_asig > 7 THEN
 
            -- Si la condición se cumple, imprime un mensaje indicando el nombre de la asignatura y su promedio.
            dbms_output.put_line('La asignatura '
                                 || nombre_asig
                                 || ' tiene un promedio superior a 7: '
                                 || promedio_asig);
        END IF;
    END LOOP;

    -- Cierra el cursor una vez que se han procesado todas las filas.
    CLOSE cursor_asignaturas;
EXCEPTION
 
    -- Sección de manejo de excepciones. Captura cualquier error que ocurra durante la ejecución del bloque.
    WHEN OTHERS THEN
 
        -- Imprime un mensaje de error utilizando la función SQLERRM que devuelve el mensaje de error del último error ocurrido.
        dbms_output.put_line('Error: '
                             || sqlerrm);
END;