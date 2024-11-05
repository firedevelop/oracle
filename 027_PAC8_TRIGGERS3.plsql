/*
Pregunta 6
0,15
 puntos
Completa el siguiente código con las palabras adecuadas: 

Crea un trigger que se ejecute antes de intentar eliminar un productos, si el producto tiene un precio mayor a 1000, no permita la eliminación y muestre un mensaje de error. Si el producto tiene un precio de 1000 o menos, entonces se guardará el backup antes de eliminarlo en "products_backup" que tiene los mismos campos que la tabla "products" */

CREATE OR REPLACE TRIGGER backup_deleted_product
BEFORE DELETE ON products                             -- En blanco 1: DELETE
FOR EACH ROW                                          -- En blanco 2: ROW

BEGIN
  -- Si el producto tiene un precio mayor a 1000, no permitimos la eliminación
  IF :OLD.price > 1000 THEN                           -- En blanco 3: :OLD, En blanco 4: >
    RAISE_APPLICATION_ERROR(-20001, 'No se permite eliminar productos con un precio mayor a 1000.');

  ELSE                                                -- En blanco 5: ELSE
    -- Si el producto tiene un precio de 1000 o menos, guardamos el backup
    -- Insertamos el registro en la tabla de respaldo
    INSERT INTO products_backup                       -- En blanco 6: INSERT
    VALUES (:OLD.product_id, :OLD.product_name, :OLD.price, :OLD.last_modified);  -- En blanco 7: VALUES

  END IF;

END;
