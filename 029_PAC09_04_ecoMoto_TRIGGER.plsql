-- Trigger para actualizar ecoPuntos y disponibilidad

CREATE OR REPLACE TRIGGER actualiza_puntos_disp AFTER
    INSERT ON ecoalquileres FOR EACH ROW
DECLARE
    v_ecopuntos          NUMBER;
    v_nombre             ecoclientes.nombre%type;
    v_apellido           ecoclientes.apellido%type;
    v_ecopuntos_actuales ecoclientes.ecopuntos%type;
    v_ecopuntos_suma     ecoclientes.ecopuntos%type;
BEGIN
 
    -- Calcular los ecoPuntos obtenidos en este alquiler (1 punto por cada 10 euros)
    v_ecopuntos := floor(:new.precioalquiler / 10);
 
    -- Obtener el nombre, apellido y ecoPuntos actuales del cliente
    SELECT
        nombre,
        apellido,
        ecopuntos INTO v_nombre,
        v_apellido,
        v_ecopuntos_actuales
    FROM
        ecoclientes
    WHERE
        dni = :new.dni;
    v_ecopuntos_suma := v_ecopuntos_actuales + v_ecopuntos;
 
    -- Actualizar los ecoPuntos del cliente
    UPDATE ecoclientes
    SET
        ecopuntos = v_ecopuntos_suma
    WHERE
        dni = :new.dni;
 
    -- Actualizar la moto como no disponible
    UPDATE ecomotos
    
    SET
        disponible = 'NO'
    WHERE
        matricula = :new.matricula;
 
    -- Mostrar mensajes de confirmación
    dbms_output.put_line('El cliente con el nombre '
                         || v_nombre
                         || ' '
                         || v_apellido
                         || ' ahora tiene '
                         || v_ecopuntos_suma
                         || ' ecoPuntos.');
EXCEPTION
 
    -- Manejo de cualquier error durante la ejecución del trigger
    WHEN OTHERS THEN
        raise_application_error(-20001, 'No se pudo completar la actualización '
                                        || sqlerrm);
END actualiza_puntos_disp;