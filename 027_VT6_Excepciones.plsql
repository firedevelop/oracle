SET SERVEROUTPUT ON;


-- Diferencia DBMS vs RAISE_EXCEPTION
DECLARE
    v_num NUMBER;
BEGIN
    v_num := 'A';
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: No se realizar esta asignación');
    -- La ejecución del código continúa aquí
END;

/

DECLARE
    v_num NUMBER;
BEGIN
    v_num := 'A';
EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error: No se realizar esta asignación');
    -- La ejecución del código continúa aquí
END;
/


-- 1. Excepciones Oracle predefinidas (ZERO_DIVIDE)
-- La excepción ZERO_DIVIDE es predefinida y se lanza cuando intentas dividir entre cero.

DECLARE
    v_num NUMBER := 10;
    v_denom NUMBER := 0;
    v_result NUMBER;
BEGIN
    -- Intentamos dividir un número entre cero
    v_result := v_num / v_denom;
    DBMS_OUTPUT.PUT_LINE('El resultado es: ' || v_result);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se puede dividir entre cero.');
END;
/

-- 2. Excepciones Oracle NO-predefinidas (ORA-01722 y PRAGMA EXCEPTION_INIT)
-- Las excepciones no predefinidas pueden manejarse utilizando PRAGMA EXCEPTION_INIT para asignar un nombre a un código de error específico, en este caso, ORA-01722 que se lanza al intentar convertir una cadena no válida en un número.

DECLARE
    v_value VARCHAR2(10) := 'ABC';
    v_num NUMBER;
    ExcepcionConversionInvalida EXCEPTION;
    PRAGMA EXCEPTION_INIT(ExcepcionConversionInvalida, -1722);
BEGIN
    -- Intentamos convertir una cadena no numérica a un número
    v_num := TO_NUMBER(v_value);
EXCEPTION
    WHEN ExcepcionConversionInvalida THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se puede convertir ' || v_value || ' a un número.');
END;
/

-- 3. Errores definidos por el usuario
-- Los errores definidos por el usuario se manejan utilizando RAISE_APPLICATION_ERROR para lanzar excepciones personalizadas.
DECLARE
    v_saldo NUMBER := -100;
BEGIN
    -- Comprobamos si el saldo es negativo
    IF v_saldo < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El saldo no puede ser negativo.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- 4. Ejemplo sencillo que utiliza WHEN OTHERS
-- El bloque WHEN OTHERS captura cualquier excepción que no haya sido manejada de forma explícita.

DECLARE
    v_num NUMBER := 10;
    v_denom NUMBER := 0;
    v_result NUMBER;
BEGIN
    -- Intentamos dividir un número entre cero (lo cual causará un error)
    v_result := v_num / v_denom;
    DBMS_OUTPUT.PUT_LINE('El resultado es: ' || v_result);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Ha ocurrido un error no esperado. Código de error: ' || SQLCODE || ', Mensaje: ' || SQLERRM);
END;
/


