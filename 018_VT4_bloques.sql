-- Si ya los tenemos creados los podemos elimina
DROP PROCEDURE saludar;
DROP FUNCTION calcular_cuadrado;

-- Ejemplo Bloques Anónimos:
DECLARE
    v_nombre VARCHAR2(50) := 'Emilio';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hola, ' || v_nombre || '!');
END;
/
-- Ejemplo de un procedimiento:
CREATE OR REPLACE PROCEDURE saludar (p_nombre VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('¡Hola, ' || p_nombre || '!');
END saludar;
/
EXECUTE saludar('Emilio');
/
-- Ejemplo de un función:
CREATE OR REPLACE FUNCTION calcular_cuadrado (p_numero NUMBER) RETURN NUMBER IS
    v_cuadrado NUMBER;
BEGIN
    v_cuadrado := p_numero * p_numero;
    RETURN v_cuadrado;
END calcular_cuadrado;
/
-- Ejemplo Bloques Anónimos:
DECLARE
    v_number NUMBER := 4;
    v_cuadrado NUMBER;
BEGIN
    v_cuadrado := calcular_cuadrado(v_number);
    DBMS_OUTPUT.PUT_LINE('Cuadrado de ' || v_number || ' = ' || v_cuadrado );
END;


