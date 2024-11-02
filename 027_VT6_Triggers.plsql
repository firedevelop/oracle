-- EJERCICIOS TRIGGERS
DROP TABLE auditoria_productos;
DROP TABLE productos_infor;

-- Tabla productos_infor
CREATE TABLE productos_infor (
    producto_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    precio NUMBER,
    fecha_alta DATE
);

-- Tabla auditoria de productos
CREATE TABLE auditoria_productos (
    producto_id NUMBER,
    precio_anterior NUMBER,
    precio_nuevo NUMBER,
    fecha_modificacion DATE,
    tipo_modificacion VARCHAR2(50),
    CONSTRAINT fk_auditoria_productos
    FOREIGN KEY (producto_id) REFERENCES productos_infor(producto_id)
);



/* Crear trigger que automáticamente asigne la fecha actual a una columna fecha_alta cuando se inserte un nuevo registro en la tabla productos.*/
CREATE OR REPLACE TRIGGER trg_fecha_alta
BEFORE INSERT ON productos_infor
FOR EACH ROW
BEGIN
    :NEW.fecha_alta := SYSDATE;
END;
/

--Comprobar TRIGGER trg_fecha_alta
INSERT INTO productos_infor (producto_id, nombre, precio) VALUES (1, 'Laptop', 1000);
INSERT INTO productos_infor (producto_id, nombre, precio) VALUES (2, 'Mouse', 25);
INSERT INTO productos_infor (producto_id, nombre, precio) VALUES (3, 'Teclado', 50);
INSERT INTO productos_infor (producto_id, nombre, precio) VALUES (4, 'Monitor', 200);
INSERT INTO productos_infor (producto_id, nombre, precio) VALUES (5, 'Impresora', 150);
INSERT INTO productos_infor (producto_id, nombre, precio) VALUES (6, 'Webcam', 70);
INSERT INTO productos_infor (producto_id, nombre, precio) VALUES (7, 'Altavoces', 60);
INSERT INTO productos_infor (producto_id, nombre, precio) VALUES (8, 'Micrófono', 40);
INSERT INTO productos_infor (producto_id, nombre, precio) VALUES (9, 'Router', 90);
INSERT INTO productos_infor (producto_id, nombre, precio) VALUES (10, 'Disco duro externo', 80);

SELECT * FROM productos_infor;

/*Trigger que registre en una tabla auditoria cada vez que se modifique el precio de un producto en la tabla productos.*/
CREATE OR REPLACE TRIGGER trg_auditoria_precio
AFTER UPDATE OF precio ON productos_infor
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_productos (producto_id, precio_anterior, precio_nuevo,tipo_modificacion, fecha_modificacion)
    VALUES (:OLD.producto_id, :OLD.precio,:NEW.precio,'Nuevo Precio', SYSDATE);
END;
/

--Comprobar TRIGGER trg_auditoria_precio, tambien podremos comprobar el "autoincrement"
UPDATE productos_infor set precio = 45 WHERE producto_id = 2;
SELECT * FROM auditoria_productos;


/*Trigger que registre en una tabla auditoria cada vez que se elimina un producto de la tabla productos.*/
CREATE OR REPLACE TRIGGER trg_baja_producto
AFTER DELETE ON productos_infor
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_productos (producto_id, precio_anterior, tipo_modificacion, fecha_modificacion)
    VALUES (:OLD.producto_id,:OLD.precio, 'Baja Producto', SYSDATE);
END;
/
--Comprobar TRIGGER trg_baja_producto
DELETE FROM productos_infor WHERE producto_id = 10;

/

-- Trigger para evitar la eliminación de productos recientes (con manejo de excepciones)
CREATE OR REPLACE TRIGGER trg_evitar_baja_reciente
BEFORE DELETE ON productos_infor
FOR EACH ROW
DECLARE
e_fecha_reciente EXCEPTION;
BEGIN
    IF :OLD.fecha_alta > SYSDATE - 30 THEN
        RAISE e_fecha_reciente;
    END IF;
EXCEPTION
    WHEN e_fecha_reciente THEN
        RAISE_APPLICATION_ERROR(-20003, 'No se puede eliminar un producto dado de alta en los últimos 30 días');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20012, 'Error inesperado en el trigger trg_evitar_baja_reciente: ' || SQLERRM);
END;
/
