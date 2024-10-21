SET SERVEROUTPUT ON;

-- CREAR TABLA EMPLEADOS
CREATE TABLE empleados (
  empleado_id NUMBER PRIMARY KEY,
  nombre VARCHAR2(50),
  depto VARCHAR2(50),
  salario DECIMAL(10,2)
);

-- Insertar algunos registros de ejemplo
INSERT INTO empleados (empleado_id, nombre, depto, salario) VALUES (1, 'Empleado1', 'DepartamentoA', 1000);
INSERT INTO empleados (empleado_id, nombre, depto, salario) VALUES (2, 'Empleado2', 'DepartamentoB', 2992.50);
INSERT INTO empleados (empleado_id, nombre, depto, salario) VALUES (3, 'Empleado3', 'DepartamentoA', 1500.55);
INSERT INTO empleados (empleado_id, nombre, depto, salario) VALUES (4, 'Empleado4', 'DepartamentoA', 1500.75);


/*Ejercicio 1 - Bloque An�nimo Simple:
Escribe un bloque an�nimo PL/ que declare una variable y la inicialice con un valor. Luego, muestra el valor de la variable.
*/

DECLARE
  v_valor NUMBER := 42;
BEGIN
  DBMS_OUTPUT.PUT_LINE('El valor de la variable es: ' || v_valor);
END;
/
/*Ejercicio 2 - Operadores Aritm�ticos:
Escribe un bloque an�nimo PL/ que use operadores aritm�ticos para realizar una serie de c�lculos simples (suma, resta, multiplicaci�n y divisi�n) e imprima los resultados.
*/
DECLARE
  v_numero1 NUMBER := 10;
  v_numero2 NUMBER := 5;
  v_suma NUMBER;
  v_resta NUMBER;
  v_multiplicacion NUMBER;
  v_division NUMBER;
BEGIN
  v_suma := v_numero1 + v_numero2;
  v_resta := v_numero1 - v_numero2;
  v_multiplicacion := v_numero1 * v_numero2;
  v_division := v_numero1 / v_numero2;
  
  DBMS_OUTPUT.PUT_LINE('Suma: ' || v_suma);
  DBMS_OUTPUT.PUT_LINE('Resta: ' || v_resta);
  DBMS_OUTPUT.PUT_LINE('Multiplicaci�n: ' || v_multiplicacion);
  DBMS_OUTPUT.PUT_LINE('Divisi�n: ' || v_division);
END;
/
?
/*Ejercicio 3 - Condicionales IF:
Escribe un bloque an�nimo PL/ que utilice una declaraci�n condicional IF para determinar si un n�mero es positivo, negativo o cero y mostrar un mensaje en consecuencia.
*/

DECLARE
  v_numero NUMBER := -8;
BEGIN
  IF v_numero > 0 THEN
    DBMS_OUTPUT.PUT_LINE('El n�mero es positivo.');
  ELSIF v_numero < 0 THEN
    DBMS_OUTPUT.PUT_LINE('El n�mero es negativo.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('El n�mero es cero.');
  END IF;
END;
/

/*Ejercicio 4 - Bucle FOR:
Escribe un bloque an�nimo PL/ que use un bucle FOR para mostrar los n�meros del 1 al 10.
*/
DECLARE
  v_numero NUMBER;
BEGIN
  FOR v_numero IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE('N�mero: ' || v_numero);
  END LOOP;
END;
/
/*Ejercicio 5 - Procedimiento Simple:
Crea un procedimiento PL/ que acepte dos n�meros como par�metros y devuelva la suma de esos n�meros.
*/
CREATE OR REPLACE PROCEDURE suma_numeros (
  p_numero1 NUMBER,
  p_numero2 NUMBER,
  p_resultado OUT NUMBER
) AS
BEGIN
  p_resultado := p_numero1 + p_numero2;
END suma_numeros;
/
?
/*Ejercicio 6 - Cursor Simple:
Escribe un bloque an�nimo PL/ que utilice un cursor para recorrer una tabla y mostrar los nombres de los empleados. (Crearse la tabla de empleados antes)
*/

DECLARE
  CURSOR empleados_cursor IS
    SELECT nombre FROM empleados;
  v_nombre empleados.nombre%TYPE;
BEGIN
  OPEN empleados_cursor;
  LOOP
    FETCH empleados_cursor INTO v_nombre;
    EXIT WHEN empleados_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre);
  END LOOP;
  CLOSE empleados_cursor;
END;
/

/*Ejercicio 7 - Excepciones Personalizadas:
Crea una excepci�n personalizada llamada mi_excepcion y escribe un bloque an�nimo PL/ que la levante y maneje.
*/
DECLARE
  mi_excepcion EXCEPTION;
BEGIN
  RAISE mi_excepcion;
EXCEPTION
  WHEN mi_excepcion THEN
    DBMS_OUTPUT.PUT_LINE('�Mi excepci�n personalizada ha sido atrapada!');
END;
/
?
/*Ejercicio 8 - Procedimiento con Manejo de Excepciones:
Crea un procedimiento PL/SQL que acepte un n�mero de empleado como par�metro y utilice un cursor para obtener informaci�n sobre ese empleado. Si el empleado no existe, levanta una excepci�n personalizada. (Crear la tabla)
*/

CREATE OR REPLACE PROCEDURE obtener_info_empleado(
  p_numero_empleado IN NUMBER
) AS
  CURSOR empleado_cursor IS
    SELECT nombre, salario
    FROM empleados
    WHERE empleado_id = p_numero_empleado;
  v_nombre empleados.nombre%TYPE;
  v_salario empleados.salario%TYPE;
  empleado_no_encontrado EXCEPTION;
BEGIN
  OPEN empleado_cursor;
  FETCH empleado_cursor INTO v_nombre, v_salario;
  
  IF empleado_cursor%NOTFOUND THEN
    CLOSE empleado_cursor;
    RAISE empleado_no_encontrado;
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Nombre del empleado: ' || v_nombre);
  DBMS_OUTPUT.PUT_LINE('Salario del empleado: ' || v_salario);
  
  CLOSE empleado_cursor;
EXCEPTION
  WHEN empleado_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El empleado especificado no existe.');
END obtener_info_empleado;
/
?
/*Ejercicio 9 - Funci�n con Excepci�n Personalizada y Cursor:
Crea una funci�n PL/SQL que acepte un n�mero de empleado como par�metro y devuelva el salario de ese empleado. Si el empleado no existe, levanta una excepci�n personalizada. (Crear la tabla)
*/
CREATE OR REPLACE FUNCTION salario_empleado(
  p_numero_empleado NUMBER
) RETURN NUMBER AS
  v_salario empleados.salario%TYPE;
  empleado_no_encontrado EXCEPTION;
BEGIN
  SELECT salario INTO v_salario
  FROM empleados
  WHERE empleado_id = p_numero_empleado;
  
  IF SQL%NOTFOUND THEN
    RAISE empleado_no_encontrado;
  END IF;
  
  RETURN v_salario;
  
EXCEPTION
  WHEN empleado_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El empleado especificado no existe.');
    RETURN NULL;
END salario_empleado;
/
/*Ejercicio 10  - Trigger:
Crea un trigger PL/ que se active antes de insertar un nuevo registro en una tabla e imprima un mensaje que indique el valor que se est� insertando. (Crear la tabla)
*/
CREATE OR REPLACE TRIGGER before_insert_empleado_trigger
BEFORE INSERT ON empleados
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Insertando valor: ' || :NEW.empleado_id || ' , ' || :NEW.nombre || ' , ' ||  :NEW.depto || ' , ' ||   :NEW.salario);
END;
/

/* EXTRA PARA COMPROBAR PROCEDIMEINTO, FUNCION Y TRIGGER*/

Ejercicio 8a � Comprobar el procedimiento:
Crea un bloque Anonimo para comprobar que funciona el procedimiento
Ejercicio 9a � Comprobar la funci�n:
Crea un bloque Anonimo para comprobar que funciona la funci�n


/* Ejercicio 8a � Comprobar el procedimiento:
Crea un bloque Anonimo para comprobar que funciona el procedimiento
*/

DECLARE
  v_salario_empleado NUMBER;
  v_id_emp NUMBER := 2;
BEGIN
  -- Prueba del procedimiento "obtener_info_empleado"
  DBMS_OUTPUT.PUT_LINE('Obteniendo informaci�n del empleado:');
  obtener_info_empleado(v_id_emp);
END;
/

/*Ejercicio 9a � Comprobar la funci�n:
Crea un bloque Anonimo para comprobar que funciona la funci�n 
*/
DECLARE
  v_salario_empleado NUMBER;
  v_id_emp NUMBER := 2;
BEGIN
  -- Prueba de la funci�n "salario_empleado"
  v_salario_empleado := salario_empleado(v_id_emp);
  
  IF v_salario_empleado IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE('El salario del empleado es: ' || v_salario_empleado);
  END IF;
END;
/
   DELETE FROM empleados where empleado_id = 5;

/* Ejercicio 10a � Comprobar el trigger
Crea un bloque Anonimo para comprobar que funciona el trigger
*/
BEGIN
 DELETE FROM empleados where empleado_id = 5;
 INSERT INTO empleados (empleado_id, nombre, depto, salario)
  VALUES (5, 'NuevoEmpleado', 'DepartamentoC', 70000);
END;
/