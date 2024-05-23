DECLARE
    V_AGE NUMBER := 65;

BEGIN
    IF V_AGE >= 18 THEN
        DBMS_OUTPUT.PUT_LINE('descuento 0%');
    ELSIF V_AGE >= 40 THEN
        DBMS_OUTPUT.PUT_LINE('descuento 2%');
    ELSIF V_AGE >= 65 THEN
        DBMS_OUTPUT.PUT_LINE('descuento 5%');
    ELSE
        DBMS_OUTPUT.PUT_LINE('acceso prohibido.');
    END IF;
END;