DECLARE

 contador NUMBER := 0; -- Inicializa un contador

 es_primo BOOLEAN; -- Variable para verificar si un número es primo

BEGIN

 FOR num IN 1..20 LOOP -- Itera del 1 al 20

  es_primo := TRUE; -- Suponemos que el número es primo hasta que se demuestre lo contrario

  IF num <= 1 THEN -- 1 y números negativos no son primos

   es_primo := FALSE;

  ELSE

   FOR divisor IN 2..TRUNC(SQRT(num)) LOOP -- Itera para verificar si el número es divisible por otros números

    IF num MOD divisor = 0 THEN -- Si es divisible, no es primo

     es_primo := FALSE;

     EXIT; -- Sal del bucle interno

    END IF;

   END LOOP;

  END IF;

  IF es_primo THEN -- Si sigue siendo primo, aumenta el contador

   contador := contador + 1;

  END IF;

 END LOOP;

 DBMS_OUTPUT.PUT_LINE('La cantidad de números primos del 1 al 20 es: ' || contador); -- Muestra el resultado

END;
