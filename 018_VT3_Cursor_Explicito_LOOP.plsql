SET SERVEROUTPUT ON;

DECLARE
    v_nombre VARCHAR2(50);
    v_dni    VARCHAR2(50);
    CURSOR c IS
    SELECT
        nombre,
        dni
    FROM
        profesores;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_nombre, v_dni;
        EXIT WHEN c%notfound;
        dbms_output.put_line('Nombre: '
                             || v_nombre
                             || ' Apellido: '
                             || v_dni);
    END LOOP;

    CLOSE c;
END;
/