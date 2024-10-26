-- Habilitar la salida del servidor para que los mensajes de DBMS_OUTPUT se muestren en la ventana de resultados.
SET SERVEROUTPUT ON

/* Descripción general del bloque:
Este es un bloque anónimo en PL/SQL. El propósito de este bloque es recorrer la tabla "productos" y 
mostrar el nombre de cada producto junto con la cantidad de letras que contiene ese nombre.
Se demostrarán tres tipos diferentes de bucles (loops) en PL/SQL: WHILE, FOR y LOOP simple. */

DECLARE
    -- Crear un cursor para seleccionar nombres de la tabla productos.
    CURSOR c_productos IS
        SELECT nombre
        FROM productos;
        
    -- Definir una variable basada en el tipo de fila del cursor. Esta variable se usará para almacenar 
    -- los valores extraídos del cursor en los bucles WHILE y LOOP simple.
    v_producto c_productos%rowtype;

BEGIN
    -- Demostración del bucle WHILE:
    DBMS_OUTPUT.PUT_LINE('--------- Usando WHILE:');
    -- Abrir el cursor para empezar a leer los datos.
    OPEN c_productos;
    -- Extraer el primer registro del cursor y almacenarlo en la variable v_producto.
    FETCH c_productos INTO v_producto;
    -- Si el registro fue extraído correctamente, c_productos%FOUND será TRUE. El bucle continuará mientras haya registros.
    WHILE c_productos%FOUND LOOP
        -- Mostrar el nombre del producto y la cantidad de letras que contiene.
        DBMS_OUTPUT.PUT_LINE(v_producto.nombre || ' tiene ' || LENGTH(v_producto.nombre) || ' letras.');
        -- Extraer el siguiente registro del cursor.
        FETCH c_productos INTO v_producto;
    END LOOP;
    -- Cerrar el cursor después de procesar todos los registros.
    CLOSE c_productos;

    -- Demostración del bucle FOR:
    DBMS_OUTPUT.PUT_LINE('---------- Usando FOR:');
    -- El bucle FOR de PL/SQL con cursor maneja automáticamente la apertura, la lectura y el cierre del cursor.
    FOR r_producto IN c_productos LOOP
        -- Mostrar el nombre del producto y la cantidad de letras que contiene.
        DBMS_OUTPUT.PUT_LINE(r_producto.nombre || ' tiene ' || LENGTH(r_producto.nombre) || ' letras.');
    END LOOP;  -- El cursor se cierra automáticamente al final del bucle FOR.

    -- Demostración del bucle LOOP simple:
    DBMS_OUTPUT.PUT_LINE('---------- Usando LOOP simple:');
    -- Abrir el cursor para empezar a leer los datos.
    OPEN c_productos;
    LOOP
        -- Extraer el siguiente registro del cursor.
        FETCH c_productos INTO v_producto;
        -- Si no hay más registros, c_productos%NOTFOUND será TRUE y el bucle se terminará.
        EXIT WHEN c_productos%NOTFOUND;
        
        -- Mostrar el nombre del producto y la cantidad de letras que contiene.
        DBMS_OUTPUT.PUT_LINE(v_producto.nombre || ' tiene ' || LENGTH(v_producto.nombre) || ' letras.');
    END LOOP;
    -- Cerrar el cursor después de procesar todos los registros.
    CLOSE c_productos;

-- Manejar cualquier error que pueda ocurrir durante la ejecución del bloque.
EXCEPTION
    WHEN OTHERS THEN
        -- Mostrar un mensaje indicando que ocurrió un error junto con la descripción del mismo.
        DBMS_OUTPUT.PUT_LINE('Se produjo un error: ' || SQLERRM);
END;  -- Fin del bloque anónimo.
/
