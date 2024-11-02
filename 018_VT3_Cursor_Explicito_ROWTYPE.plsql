SET SERVEROUTPUT ON;
DECLARE
    CURSOR c IS
        SELECT
            nombre,
            dni
        FROM
            profesores;
    v_resultados c%ROWTYPE;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_resultados;
        EXIT WHEN c%NOTFOUND;

        dbms_output.put_line('Nombre: ' || v_resultados.nombre || ' DNI: ' || v_resultados.dni);
    END LOOP;
    CLOSE c;
END;
/