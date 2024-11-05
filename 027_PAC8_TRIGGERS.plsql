-- TENEMOS LA TABLA "products" Y QUEREMOS UN TRIGGER QUE ACTUALICE LA FECHA DE ÚLTIMA MODIFICACIÓN DE CADA REGISTRO QUE SE HA MODIFICADO EN LA TABLA "products".

CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(50),
    price NUMBER,
    last_modified DATE
);

CREATE OR REPLACE TRIGGER update_last_modified BEFORE
    UPDATE ON products FOR EACH ROW
BEGIN
    :new.last_modified := sysdate;
END;
/