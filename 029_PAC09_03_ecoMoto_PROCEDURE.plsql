SET SERVEROUTPUT ON;

-- Procedimiento almacenado para registrar alquileres

CREATE OR REPLACE PROCEDURE registrar_alquiler (
    p_dni IN VARCHAR2,
    p_fechaini IN DATE,
    p_matricula IN VARCHAR2,
    p_fechafin IN DATE
) IS
    v_precio_dia    NUMBER;
    v_dias_alquiler NUMBER;
    v_precio_total  NUMBER;
    v_disponible    CHAR(2);
    v_modelo        VARCHAR2(50);
    no_disponible exception;
    dias_alquiler exception;
BEGIN
 
    -- Calcular el número de días de alquiler
    v_dias_alquiler := p_fechafin - p_fechaini;
 
    -- Si el alquiler es menor a 2 días, lanzar excepción
    IF v_dias_alquiler < 2 THEN
        RAISE dias_alquiler;
    END IF;
 

    -- Verificar si la moto existe y obtener sus datos (precio por día y disponibilidad)
    SELECT
        preciodia,
        disponible,
        modelo INTO v_precio_dia,
        v_disponible,
        v_modelo
    FROM
        ecomotos
    WHERE
        matricula = p_matricula;
 
    -- Si la moto no está disponible, lanzar excepción
    IF v_disponible = 'NO' THEN
        RAISE no_disponible;
    END IF;
 

    -- Calcular el precio total del alquiler
    v_precio_total := v_dias_alquiler * v_precio_dia;
 
    -- Insertar el nuevo alquiler en la tabla ecoAlquileres
    INSERT INTO ecoalquileres (
        dni,
        fechaini,
        matricula,
        fechafin,
        diasalquiler,
        precioalquiler
    ) VALUES (
        p_dni,
        p_fechaini,
        p_matricula,
        p_fechafin,
        v_dias_alquiler,
        v_precio_total
    );
    dbms_output.put_line('El Alquiler de la moto '
                         || v_modelo
                         || ' ha sido registrado correctamente');
EXCEPTION
    WHEN dias_alquiler THEN
        raise_application_error(-20001, 'El Alquiler ha de ser mínimo de 2 días');
    WHEN no_data_found THEN
        raise_application_error(-20002, 'La moto con matricula '
                                        || p_matricula
                                        || ' no se ha podido encontrar');
    WHEN no_disponible THEN
        raise_application_error(-20003, 'La moto con matricula '
                                        || p_matricula
                                        || ' y modelo '
                                        || v_modelo
                                        || ' no está disponible en estos momentos');
    WHEN OTHERS THEN
        raise_application_error(-20004, 'Se ha producido un error inesperado: '
                                        || sqlerrm);


END registrar_alquiler;
/


-- Call to the procedure.
--    EXECUTE registrar_alquiler('87654321B', TO_DATE('2024-11-05', 'YYYY-MM-DD'), 'JKL202', TO_DATE('2024-11-07', 'YYYY-MM-DD'));
-- EXECUTE registrar_alquiler('33445566D', TO_DATE('2024-11-05', 'YYYY-MM-DD'), 'JKL202', TO_DATE('2024-11-07', 'YYYY-MM-DD'));
