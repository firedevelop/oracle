SET SERVEROUTPUT ON;
drop table promedio_asignatura;
CREATE TABLE promedio_asignatura(
    codigo_asig VARCHAR2(10) PRIMARY KEY,
    nombre VARCHAR2(25),
    promedio DECIMAL(5, 2) -- 5= number of digits like 100.99 o --100.99
);

SELECT
    a.codigo_asig,
    a.nombre,
    ROUND(AVG(n.nota), 2) AS promedio
FROM
    notas n
    JOIN asignaturas a
    ON n.codigo_asig = a.codigo_asig
GROUP BY
    a.codigo_asig,
    a.nombre; -- you must add 2 because in select you use 2

DECLARE
    v_codigo_asig VARCHAR2(10); 
    v_nombre_asig VARCHAR2(25);
    v_promedio FLOAT;
    v_contador INT := 0;
    v_suma_promedios FLOAT := 0; 
    v_promedio_global FLOAT;
    CURSOR c IS SELECT
        a.codigo_asig,
        a.nombre,
        ROUND(AVG(n.nota), 2) AS promedio
    FROM
        notas n
        JOIN asignaturas a
        ON n.codigo_asig = a.codigo_asig  -- Corrección realizada aquí
    GROUP BY
        a.codigo_asig,
        a.nombre;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_codigo_asig, v_nombre_asig, v_promedio;
        EXIT WHEN c%NOTFOUND;
        
        IF v_promedio > 7 THEN
            DBMS_OUTPUT.PUT_LINE('La asignatura '
                                 || v_nombre_asig
                                 || ' tiene un promedio de: '
                                 || v_promedio);
        END IF;

        v_contador := v_contador + 1;
        v_suma_promedios := v_suma_promedios + v_promedio;

        INSERT INTO promedio_asignatura VALUES (v_codigo_asig, v_nombre_asig, v_promedio);  -- Descomentar esta línea para la inserción
    END LOOP;
    
    v_promedio_global := ROUND(v_suma_promedios / v_contador, 2);
    DBMS_OUTPUT.PUT_LINE('Promedio Global: '
                         || v_promedio_global);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END;
/
