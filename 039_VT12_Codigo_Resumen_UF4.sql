/*
Ejercicio FINAL: Sistema de Gestión de Vehículos y Propietarios
Sistema de gestión de vehículos en una base de datos objeto-relacional. El sistema maneja diferentes tipos de vehículos, propietarios
*/

SET SERVEROUTPUT ON

DROP TABLE coches;
DROP TABLE motocicletas;
DROP TABLE propietarios;

DROP TYPE type_motocicleta;
DROP TYPE type_coche;
DROP TYPE  type_vehiculo;
DROP TYPE  type_TelefonosVarray;
DROP TYPE  HijosTabla;
DROP TYPE  type_hijos;


-- Creación del supertipo Vehiculo
CREATE OR REPLACE TYPE type_vehiculo AS OBJECT (
  id_vehiculo NUMBER,
  marca VARCHAR2(100),
  modelo VARCHAR2(100),
  año NUMBER,
  MEMBER FUNCTION get_antiguedad RETURN NUMBER
) NOT FINAL;
/

-- Implementación de la función get_antiguedad para Coche
CREATE OR REPLACE TYPE BODY type_vehiculo AS
  MEMBER FUNCTION get_antiguedad RETURN NUMBER IS
  BEGIN
    -- Calcula la antigüedad del coche restando el año actual al año de fabricación del coche.
    RETURN EXTRACT(YEAR FROM SYSDATE) - año;
  END;
END;
/

-- Creación del subtipo Coche
CREATE TYPE type_coche UNDER type_vehiculo (
  num_pasajeros NUMBER,
  tipo_transmision VARCHAR2(50) -- Ejemplo: 'Manual', 'Automático'
);
/

-- Creación del subtipo Motocicleta
CREATE OR REPLACE TYPE type_motocicleta UNDER type_vehiculo (
  cilindrada NUMBER,
  tiene_sidecar VARCHAR2(2)
);
/

-- Crear VARRAY de teléfonos con capacidad para 2 números
CREATE OR REPLACE TYPE type_TelefonosVarray AS VARRAY(2) OF NUMBER;
/
-- Crear el tipo de objeto para un hijo
CREATE OR REPLACE  TYPE type_hijos AS OBJECT (
  nombre VARCHAR2(100),
  edad NUMBER
);
/

-- Crear una tabla anidada de hijos
CREATE OR REPLACE TYPE HijosTabla AS TABLE OF type_hijos;
/

-- Crear una tabla de objetos de motos
CREATE TABLE motocicletas OF type_motocicleta (
  PRIMARY KEY (id_vehiculo),
  CONSTRAINT tiene_sidecar_check CHECK (tiene_sidecar IN ('Si','No'))
) OBJECT IDENTIFIER IS PRIMARY KEY;

-- Crear una tabla de objetos de Coche
CREATE TABLE coches OF type_coche (
  PRIMARY KEY (id_vehiculo)
) OBJECT IDENTIFIER IS PRIMARY KEY;

-- Crear una tabla de propietarios
CREATE TABLE Propietarios (
  id_propietario NUMBER PRIMARY KEY,
  nombre         VARCHAR2(100),
  coche_ref     REF type_coche SCOPE IS coches,-- La referencia debe apuntar a un objeto en la tabla Coches
  moto_ref      REF type_motocicleta SCOPE IS motocicletas,-- La referencia debe apuntar a un objeto en la tabla Motocicleta
  telefonos              type_TelefonosVarray, -- Columna para almacenar la VARRAY de teléfonos
  hijos                       hijosTabla           -- Columna para almacenar la tabla anidada de hijos
) NESTED TABLE hijos STORE AS hijos_tabla; -- Especifica cómo almacenar la tabla anidada de hijos
/

/*
La cláusula SCOPE IS es útil para mantener la integridad de los datos en diseños de bases de datos objeto-relacionales, 
ya que asegura que las referencias siempre apunten a objetos válidos y específicos dentro de una tabla definida.
Sin esta cláusula, Oracle no restringiría las referencias de coche_ref a una tabla específica, lo que podría llevar a situaciones donde una referencia apunte a un objeto que no existe o que no es un type_coche.
*/

-- Insertar registros en la tabla Motocicletas
BEGIN
  INSERT INTO motocicletas VALUES (type_motocicleta(1, 'Harley-Davidson', 'Chopper', 2020, 1800, 'Si'));
  INSERT INTO motocicletas VALUES (type_motocicleta(2, 'Yamaha', 'MT-09', 2019, 847, 'No'));
  INSERT INTO motocicletas VALUES (type_motocicleta(3, 'Honda', 'CBR500R', 2018, 471, 'No'));
  INSERT INTO motocicletas VALUES (type_motocicleta(4, 'Ducati', 'Panigale V4', 2020, 1103, 'No'));
  INSERT INTO motocicletas VALUES (type_motocicleta(5, 'BMW', 'R1200GS', 2021, 1170, 'No'));
END;
/

-- Insertar registros en la tabla Coches
BEGIN
  INSERT INTO coches VALUES (type_coche(6, 'Toyota', 'Corolla', 2020, 5, 'Automático'));
  INSERT INTO coches VALUES (type_coche(7, 'Honda', 'Civic', 2019, 5, 'Manual'));
  INSERT INTO coches VALUES (type_coche(8, 'Ford', 'Mustang', 2018, 4, 'Manual'));
  INSERT INTO coches VALUES (type_coche(9, 'Tesla', 'Model S', 2021, 5, 'Automático'));
  INSERT INTO coches VALUES (type_coche(10, 'Chevrolet', 'Camaro', 2020, 4, 'Automático'));
 END;
/

-- Insertar registros en la tabla Propietarios
DECLARE
  coche_ref_p1 REF type_coche;
  moto_ref_p2 REF type_motocicleta;
  moto_ref_p4 REF type_motocicleta;
  coche_ref_p3 REF type_coche;
  coche_ref_p4 REF type_coche;
BEGIN
  -- Obtener referencias a vehículos específicos
  -- propietario 1 tiene el coche 10 
  SELECT REF(c) INTO coche_ref_p1 FROM coches c WHERE c.id_vehiculo = 10;
  
  -- propietario 2 tiene la moto 1 
  SELECT REF(m) INTO moto_ref_p2 FROM motocicletas m WHERE m.id_vehiculo = 1;

  -- propietario 3 tiene el coche 2 
  SELECT REF(c) INTO coche_ref_p3 FROM coches c WHERE c.id_vehiculo = 6;
  
    -- propietario 4 tiene el coche 3
  SELECT REF(c) INTO coche_ref_p4 FROM coches c WHERE c.id_vehiculo = 7;
  
    -- propietario 4 tiene la moto 4 
  SELECT REF(m) INTO moto_ref_p4 FROM motocicletas m WHERE m.id_vehiculo = 4;
  
  -- Insertar propietarios con diferentes combinaciones de teléfonos y hijos
  INSERT INTO Propietarios VALUES (
    1, 
    'Juan Carlos Miranda', 
    coche_ref_p1, 
    NULL, 
    type_TelefonosVarray(111111111, 222222222), 
    HijosTabla(type_hijos('Juan', 10), type_hijos('Toni', 8))
  );


  -- Repetir para otros propietarios con diferentes referencias y datos
  INSERT INTO Propietarios VALUES (
    2, 
    'Lina Soler', 
    NULL, 
    moto_ref_p2, 
    type_TelefonosVarray(333333333, 444444444), 
    HijosTabla(type_hijos('Roberto', 5), type_hijos('Silvia', 3))
  );

  -- Insertar otro propietario
  INSERT INTO Propietarios VALUES (
    3, 
    'Emilia Oltra', 
    coche_ref_p3, 
    NULL, 
    type_TelefonosVarray(555555555, 666666666), 
    HijosTabla(type_hijos('Emilio', 12))
  );

  -- Insertar otro propietario
  INSERT INTO Propietarios VALUES (
    4, 
    'Olivia Vidal', 
    coche_ref_p4, 
    moto_ref_p4, 
    type_TelefonosVarray(777777777, 888888888), 
    HijosTabla(type_hijos('Sonia', 4), type_hijos('Oscar', 2), type_hijos('Maria', 2))
  );
    
END;
/

-- No puedes realizar directamente un SELECT sobre una tabla anidada almacenada internamente
SELECT * FROM hijos_tabla;

-- Para acceder a los datos de una tabla anidada es a través de la tabla principal utilizando la cláusula TABLE() en la consulta
SELECT p.id_propietario, p.nombre AS Nombre_propietario, h.nombre, h.edad
FROM Propietarios p, TABLE(p.hijos) h;

/*PROCEDIMIENTO MOSTRAR DETALLE*/
-- Procedimiento almacenado donde se pueda pasar el número de propietario como parámetro y nos muestre los datos
CREATE OR REPLACE PROCEDURE MostrarDetallesPropietario (p_id_propietario IN NUMBER) AS
    v_coche_ref type_coche;
    v_moto_ref type_motocicleta;

    -- Cursor para obtener información de los hijos del propietario
    CURSOR hijos_cursor IS
        SELECT t.nombre, t.edad FROM Propietarios p, TABLE(p.hijos) t WHERE p.id_propietario = p_id_propietario;

    v_hijos_cursor hijos_cursor%ROWTYPE;
    v_nombre VARCHAR2(100);
    v_telefonos type_TelefonosVarray;
BEGIN
    -- Recuperar información del propietario
    SELECT nombre, telefonos INTO v_nombre, v_telefonos FROM Propietarios WHERE id_propietario = p_id_propietario;

    DBMS_OUTPUT.PUT_LINE('---- PROPIETARIO ----');
    DBMS_OUTPUT.PUT_LINE(v_nombre);
    IF v_telefonos IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('---- TELEFONOS ----');
        FOR i IN 1..v_telefonos.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Teléfono ' || i || ': ' || v_telefonos(i));
        END LOOP;
    END IF;

    -- Recuperar y mostrar información de los hijos
    OPEN hijos_cursor;
    LOOP
        FETCH hijos_cursor INTO v_hijos_cursor;
        EXIT WHEN hijos_cursor%NOTFOUND;
        IF hijos_cursor%ROWCOUNT = 1 THEN
            DBMS_OUTPUT.PUT_LINE('---- HIJOS ----');
        END IF;
        DBMS_OUTPUT.PUT_LINE( hijos_cursor%ROWCOUNT || ' - Nombre: ' || v_hijos_cursor.nombre || ' --> Edad: ' || v_hijos_cursor.edad);
    END LOOP;
    CLOSE hijos_cursor;

    -- VER COCHE SI TIENE
    SELECT DEREF(p.coche_ref) INTO v_coche_ref FROM propietarios p WHERE id_propietario = p_id_propietario;
    IF v_coche_ref IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('---- COCHE ----');
        DBMS_OUTPUT.PUT_LINE('Marca: ' || v_coche_ref.marca);
        DBMS_OUTPUT.PUT_LINE('Modelo: ' || v_coche_ref.modelo);
        DBMS_OUTPUT.PUT_LINE('Año: ' || v_coche_ref.año);
        DBMS_OUTPUT.PUT_LINE('Antiguedad: ' || v_coche_ref.get_antiguedad());
        DBMS_OUTPUT.PUT_LINE('Num_pasajeros: ' || v_coche_ref.num_pasajeros);
        DBMS_OUTPUT.PUT_LINE('Tipo_transmision: ' || v_coche_ref.tipo_transmision);
    END IF;

    -- VER MOTO SI TIENE
    SELECT DEREF(p.moto_ref) INTO v_moto_ref FROM propietarios p WHERE id_propietario = p_id_propietario;
    IF v_moto_ref IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('---- MOTO ----');
        DBMS_OUTPUT.PUT_LINE('Marca: ' || v_moto_ref.marca);
        DBMS_OUTPUT.PUT_LINE('Modelo: ' || v_moto_ref.modelo);
        DBMS_OUTPUT.PUT_LINE('Año: ' || v_moto_ref.año);
        DBMS_OUTPUT.PUT_LINE('Antiguedad: ' || v_moto_ref.get_antiguedad());
        DBMS_OUTPUT.PUT_LINE('Cilindrada: ' || v_moto_ref.cilindrada);
        DBMS_OUTPUT.PUT_LINE('Tiene sidecar: ' || v_moto_ref.tiene_sidecar);
    END IF;
END MostrarDetallesPropietario;
/

-- Ver detalles de los propiestarios
EXECUTE MostrarDetallesPropietario(1);
EXECUTE MostrarDetallesPropietario(2);
EXECUTE MostrarDetallesPropietario(3);
EXECUTE MostrarDetallesPropietario(4);
