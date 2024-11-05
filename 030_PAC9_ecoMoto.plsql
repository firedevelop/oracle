-- Descripción Script: función llamada "categoria_cliente", que reciba como parámetro de entrada un DNI de cliente y devuelva la categoría del cliente en función de los ecoPuntos que lleva acumulados. Crear categorías basadas en puntos.

----------- 1. CREAMOS DATA RANDOM PARA COLUMNA ECOPUNTOS
----------- 2. FUNCION
----------- 3. LLAMADA A FUNCION


SET SERVEROUTPUT ON;

----------- 1. CREAMOS DATA RANDOM PARA COLUMNA ECOPUNTOS
BEGIN
    -- Inicialización de random usando la hora actual
    DBMS_RANDOM.INITIALIZE(TO_NUMBER(TO_CHAR(SYSDATE, 'SSSSS')));
    
    -- actualizamos columna ecoPuntos
    UPDATE ecoClientes
    SET ecoPuntos = ROUND(DBMS_RANDOM.VALUE(0, 1100));
    
    COMMIT;
    
    -- Finalización de random
    DBMS_RANDOM.TERMINATE;
END;
/


----------- 2. FUNCION
CREATE OR REPLACE FUNCTION categoria_cliente (dni_cliente IN VARCHAR2)
RETURN VARCHAR2
IS
    v_nombre ecoClientes.Nombre%TYPE;
    v_ecoPuntos ecoClientes.ecoPuntos%TYPE;
    v_categoria VARCHAR2(50);
    
BEGIN
    -- Buscar puntos basado en DNI
    SELECT nombre, ecoPuntos INTO v_nombre, v_ecoPuntos
    FROM ecoClientes
    WHERE dni = dni_cliente;

    -- Categorías basadas en puntos
    v_categoria := CASE
                      WHEN v_ecoPuntos BETWEEN 0 AND 100 THEN 'BRONZE'
                      WHEN v_ecoPuntos BETWEEN 101 AND 500 THEN 'SILVER'
                      WHEN v_ecoPuntos BETWEEN 501 AND 1000 THEN 'GOLD'
                      ELSE 'PLATINIUM' 
                   END;

    -- Mensaje de saludo y muestra de puntos
    DBMS_OUTPUT.PUT_LINE(
                        'Hola ' 
                        || v_nombre 
                        || ', tu categoría es ' 
                        || v_categoria 
                        || '.');

    RETURN v_categoria;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- DNI no existe
        RAISE_APPLICATION_ERROR(-20001, 'El cliente con DNI ' || dni_cliente || ' no existe.');
    WHEN OTHERS THEN
        -- otro error
        RAISE_APPLICATION_ERROR(-20002, 'Se ha producido un error inesperado en la categoría del cliente: ' || SQLERRM);
END categoria_cliente;
/


----------- 3. LLAMADA A FUNCION
DECLARE
    v_categoria VARCHAR2(50);
BEGIN
    v_categoria := categoria_cliente('12345678A');
    v_categoria := categoria_cliente('88990011J');    
    -- v_categoria := categoria_cliente(''); -- ejemplo error dni no existe 
END;
/
