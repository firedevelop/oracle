SET SERVEROUTPUT ON;

DECLARE
    CURSOR c IS
    SELECT
        nombre
    FROM
        profesores FOR UPDATE; -- declaracion del cursor con update
    v_nombre VARCHAR2(50);
BEGIN
    dbms_output.put_line('Valores antes de actualizarse');
    OPEN c;
    FETCH c INTO v_nombre; --This initial FETCH retrieves the first row of the result set into v_nombre. It’s necessary to execute this FETCH before the loop starts so that we can check if there’s data in the cursor. If there’s data, c%FOUND will be TRUE, allowing the loop to start.
    WHILE c%found LOOP
        dbms_output.put_line('Nombre: '
                             || v_nombre);
        UPDATE profesores
        SET
            nombre = nombre
                     || '.' -- nombre=nombre+. Aqui esta la clave, en estos  || pues permite concatenar o conservar el valor previo y añadirle un punto nuevo.
        WHERE
            CURRENT OF c; --se actualiza solo la fila específica sin que los datos previos se pierdan.
        FETCH c INTO v_nombre;
    END LOOP;

    CLOSE c;
    COMMIT;
    dbms_output.put_line('');
    dbms_output.put_line('Valores después de actualizarse');
    OPEN c;
    FETCH c INTO v_nombre; -- This initial FETCH retrieves the first row of the result set into v_nombre. It’s necessary to execute this FETCH before the loop starts so that we can check if there’s data in the cursor. If there’s data, c%FOUND will be TRUE, allowing the loop to start.
    WHILE c%found LOOP
        dbms_output.put_line('Nombre: '
                             || v_nombre);
        FETCH c INTO v_nombre; -- his second FETCH inside the WHILE loop retrieves the next row in each iteration.
    END LOOP;

    CLOSE c;
END;
/