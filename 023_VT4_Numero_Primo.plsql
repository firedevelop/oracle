-- un número es primo si sólo tiene dos divisores: el 1 y él mismo.
DECLARE
    contador NUMBER := 0; -- Inicializa un contador
    es_primo BOOLEAN; -- Variable para verificar si un número es primo
BEGIN
    FOR num IN 1..7 LOOP -- Itera del 1 al 20
        dbms_output.put_line(num || ' working on');
        es_primo := true; -- Suponemos que el número es primo hasta que se demuestre lo contrario
        IF num <= 1 THEN -- 1 y números negativos no son primos
            es_primo := false;
            dbms_output.put_line(num || ' false');
        ELSE
            FOR divisor IN 2..trunc(sqrt(num)) LOOP -- Itera para verificar si el número es divisible por otros números
                IF num MOD divisor = 0 THEN -- Si es divisible, no es primo
                    es_primo := false;
                    dbms_output.put_line(num || ' false else');
                    exit; -- Sal del bucle interno
                END IF;
            END LOOP;
        END IF;

        IF es_primo THEN -- Si sigue siendo primo, aumenta el contador
            contador := contador + 1;
            dbms_output.put_line('contador = ' || contador);
        END IF;
    END LOOP;

    dbms_output.put_line('La cantidad de números primos del 1 al 7 es: '
                         || contador); -- Muestra el resultado
END;