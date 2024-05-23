DECLARE
    V_AGE NUMBER := 19;

BEGIN
    IF V_AGE >= 18 THEN
        DBMS_OUTPUT.PUT_LINE('acceso permitido.');
    ELSE V_AGE < 18 THEN
        DBMS_OUTPUT.PUT_LINE('acceso prohibido.');
    END IF;
END;