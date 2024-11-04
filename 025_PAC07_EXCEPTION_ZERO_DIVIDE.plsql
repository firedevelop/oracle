-- BLOQUE PL/SQL QUE INTENTE DIVIDIR DOS NÚMEROS. SI EL DENOMINADOR ES CERO, CAPTURE LA EXCEPCIÓN Y MUESTRE UN MENSAJE PERSONALIZADO.

DECLARE
    num1   NUMBER := 10;
    num2   NUMBER := 0;
    result NUMBER;
BEGIN
    result := num1 / num2;
EXCEPTION
    WHEN zero_divide THEN
        dbms_output.put_line('Error: División por cero.');
END;
/