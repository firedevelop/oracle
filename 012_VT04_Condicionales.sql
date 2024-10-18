SET SERVEROUTPUT ON

-- Uso de IF:
-- En este bloque, estamos declarando una variable llamada edad. 
-- Luego, mediante una estructura IF-ELSE, verificamos si la persona es mayor de edad (es decir, si tiene 18 años o más). 
-- Dependiendo del resultado, se imprime un mensaje adecuado.

DECLARE
    v_edad NUMBER; -- Declaración de una variable 'edad' 
BEGIN

    v_edad := &edad; -- entrada por pantalla y asignación del valor
    -- Comprueba si la 'edad' es mayor o igual a 18
    IF v_edad >= 18 THEN
        dbms_output.put_line('Mayor de edad.'); -- Si es verdadero, imprime 'Mayor de edad.'
    ELSE
        dbms_output.put_line('Menor de edad.'); -- Si es falso, imprime 'Menor de edad.'
    END IF;
END;
/

-- Uso de IF con ELSIF:
-- Aquí, se declara una variable llamada calificación y se le asigna un valor de 85. 
-- A través de la estructura IF-ELSIF-ELSE, se verifica el rango de la calificación para determinar y mostrar la letra correspondiente.

DECLARE
    v_calificación NUMBER := 85; -- Declaración de una variable 'calificación' y asignación del valor 85
BEGIN
    -- Evaluamos la 'calificación' para determinar la letra correspondiente
    IF v_calificación >= 90 THEN
        dbms_output.put_line('A'); -- Si la 'calificación' es 90 o más, imprime 'A'
    ELSIF v_calificación >= 80 THEN
        dbms_output.put_line('B'); -- Si la 'calificación' está entre 80 y 89, imprime 'B'
    ELSIF v_calificación >= 70 THEN
        dbms_output.put_line('C'); -- Si la 'calificación' está entre 70 y 79, imprime 'C'
    ELSE
        dbms_output.put_line('D'); -- Para cualquier otra 'calificación', imprime 'D'
    END IF;
END;
/

-- Uso de CASE:
-- En este bloque, se declara una variable día con por entrada y otra variable nombre_del_día para almacenar el nombre del día correspondiente. 
-- Luego, utilizando la estructura CASE, se verifica el valor de día para asignar el nombre del día adecuado a nombre_del_día. 
-- Finalmente, se imprime el resultado.

DECLARE
    v_dia            NUMBER; --Declaración de una variable 'dia'
    v_nombre_del_dia VARCHAR2(20); -- Declaración de la variable 'nombre_del_día' para almacenar el nombre del día
BEGIN
    v_dia  := &dia;
    -- Se evalúa el valor de 'día' para determinar el nombre del día correspondiente
    CASE v_dia
        WHEN 1 THEN
            v_nombre_del_dia := 'Lunes';
        WHEN 2 THEN
            v_nombre_del_dia := 'Martes';
        WHEN 3 THEN
            v_nombre_del_dia := 'Miércoles';
        WHEN 4 THEN
            v_nombre_del_dia := 'Jueves';
        WHEN 5 THEN
            v_nombre_del_dia := 'Viernes';
        WHEN 6 THEN
            v_nombre_del_dia := 'Sábado';
        WHEN 7 THEN
            v_nombre_del_dia := 'Domingo';
        ELSE
            v_nombre_del_dia := 'Día inválido'; -- Si 'dia' no está entre 1 y 7, se considera inválido
    END CASE;

    dbms_output.put_line(v_nombre_del_dia); -- Imprime el 'nombre_del_día' determinado
END;
/

-- Uso de WHILE:
-- Escriba un bloque que imprima los números del 1 al 5 usando un bucle WHILE.
DECLARE
    v_cont NUMBER := 1; -- Inicializa contador
BEGIN
    WHILE v_cont <= 5 LOOP
        dbms_output.put_line(v_cont); -- Imprime el valor del contador
        v_cont := v_cont + 1; -- Incrementa el contador
    END LOOP;
END;
/

-- Uso de LOOP con IF para controlar la salida:
--  Imprime los primeros cinco números pares usando un bucle LOOP
DECLARE
    v_cont    NUMBER := 1; -- Inicializa contador
    v_pares_impr  NUMBER := 0; -- Cuenta los números pares impresos
BEGIN
    LOOP
        IF MOD(v_cont, 2) = 0 THEN -- Verifica si el número es par
            dbms_output.put_line(v_cont); -- Imprime el número
            v_pares_impr := v_pares_impr + 1; -- Incrementa el contador de pares impresos
        END IF;

        EXIT WHEN v_pares_impr = 5; -- Sale del bucle después de imprimir 5 números pares

        v_cont := v_cont + 1; -- Incrementa el contador
    END LOOP;
END;
/

-- Uso de FOR en orden inverso:
-- Imprimir los números del 5 al 1 en orden decreciente usando un bucle FOR.
BEGIN
    FOR contador IN REVERSE 1..5 LOOP
        dbms_output.put_line(contador); -- Imprime el valor del contador
    END LOOP;
END;
/
-- Uso combinado de FOR y IF:
-- Imprime solo los números impares entre 1 y 10 usando un bucle FOR y un IF.
BEGIN
    FOR contador IN 1..10 LOOP
        IF MOD(contador, 2) <> 0 THEN -- Verifica si el número es impar
            dbms_output.put_line(contador); -- Imprime el número
        END IF;
    END LOOP;
END;
/

-- Uso combinado de WHILE y IF:
-- Imprime la tabla del 3 hasta 10 usando un bucle WHILE.
DECLARE
    v_cont      NUMBER := 1; -- Inicializa contador
    v_multiplos NUMBER := 1; -- Cuenta los múltiplos impresos
BEGIN
    WHILE v_multiplos <= 10 LOOP
        IF MOD(v_cont, 3) = 0 THEN -- Verifica si el número es múltiplo de 3
            dbms_output.put_line(v_cont); -- Imprime el número
            v_multiplos := v_multiplos + 1; -- Incrementa el contador de múltiplos
        END IF;

        v_cont := v_cont + 1; -- Incrementa el contador
    END LOOP;
END;
/