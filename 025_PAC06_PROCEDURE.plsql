CREATE OR REPLACE PROCEDURE obtener_nombre_apellido(
    empleado_id_param IN NUMBER
) AS
    v_nombre   empleados.nombre%type;
    v_apellido empleados.apellido%type;
BEGIN
    SELECT
        nombre,
        apellido INTO v_nombre,
        v_apellido
    FROM
        empleados
    WHERE
        empleado_id = empleado_id_param;
    dbms_output.put_line('Nombre: '
                         || v_nombre);
    dbms_output.put_line('Apellido: '
                         || v_apellido);
END obtener_nombre_apellido;
/