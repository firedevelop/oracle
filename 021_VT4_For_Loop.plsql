DECLARE

 suma NUMBER := 0; -- Inicializa una variable para almacenar la suma

BEGIN

 FOR i IN 1..10 LOOP  -- En blanco 1: LOOP

  IF i MOD 2 = 0 THEN  -- En blanco 2: THEN

   suma := suma + i; -- En blanco 3: :=

  END IF;

 END LOOP;  -- En blanco 4: END

 DBMS_OUTPUT.PUT_LINE('La suma de los números pares del 1 al 10 es: ' || suma); -- En blanco 5: DBMS_OUTPUT.PUT_LINE

END;
