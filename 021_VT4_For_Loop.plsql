-- Sum pair number from 1 to 10
DECLARE
    suma NUMBER := 0;
BEGIN
    FOR i IN 1..10 LOOP 
        IF i MOD 2 = 0 THEN 
            suma := suma + i;
        END IF;
    END LOOP;
    dbms_output.put_line('La suma de los números pares del 1 al 10 es: ' || suma); -- 30
END;
-- 30