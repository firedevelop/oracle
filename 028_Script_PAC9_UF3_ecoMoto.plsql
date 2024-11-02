DROP TABLE ecoAlquileres;
DROP TABLE ecoClientes;
DROP TABLE ecoMotos;

-- Crear tabla Clientes_eco
CREATE TABLE ecoClientes (
    Dni VARCHAR2(9) PRIMARY KEY,
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    ecoPuntos NUMBER DEFAULT 0
);

-- Crear tabla Motos_eco
CREATE TABLE ecoMotos (
    Matricula VARCHAR2(10) PRIMARY KEY,
    Modelo VARCHAR2(50),
    PrecioDia NUMBER(10, 2),
    Disponible CHAR(2)DEFAULT 'SI' CHECK (Disponible IN ('SI', 'NO')) 
);

-- Crear tabla Alquileres_eco
CREATE TABLE ecoAlquileres (
    Dni VARCHAR2(20),
    FechaIni DATE,
    Matricula VARCHAR2(10) NOT NULL,
    FechaFin DATE NOT NULL,
    DiasAlquiler NUMBER,
    PrecioAlquiler NUMBER(10, 2) NOT NULL,
    PRIMARY KEY (Dni, FechaIni),
    FOREIGN KEY (Dni) REFERENCES ecoClientes(Dni),
    FOREIGN KEY (Matricula) REFERENCES ecoMotos(Matricula)
);

-- Insertar 10 registros en la tabla ecoClientes
INSERT INTO ecoClientes (Dni, Nombre, Apellido)
VALUES ('12345678A', 'Juan', 'Pérez');

INSERT INTO ecoClientes (Dni, Nombre, Apellido)
VALUES ('87654321B', 'María', 'González');

INSERT INTO ecoClientes (Dni, Nombre, Apellido)
VALUES ('11223344C', 'Carlos', 'López');

INSERT INTO ecoClientes (Dni, Nombre, Apellido)
VALUES ('33445566D', 'Laura', 'Fernández');

INSERT INTO ecoClientes (Dni, Nombre, Apellido)
VALUES ('99887766E', 'Ana', 'Martínez');

INSERT INTO ecoClientes (Dni, Nombre, Apellido)
VALUES ('44556677F', 'David', 'Ramírez');

INSERT INTO ecoClientes (Dni, Nombre, Apellido)
VALUES ('55667788G', 'Sofía', 'Sánchez');

INSERT INTO ecoClientes (Dni, Nombre, Apellido)
VALUES ('66778899H', 'Miguel', 'García');

INSERT INTO ecoClientes (Dni, Nombre, Apellido)
VALUES ('77889900I', 'Lucía', 'Morales');

INSERT INTO ecoClientes (Dni, Nombre, Apellido)
VALUES ('88990011J', 'José', 'Ruiz');



-- Insertar 10 registros en la tabla ecoMotos
INSERT INTO ecoMotos (Matricula, Modelo, PrecioDia)
VALUES ('XYZ123', 'Yamaha MT-07', 50);

INSERT INTO ecoMotos (Matricula, Modelo, PrecioDia)
VALUES ('ABC456', 'Honda CBR500R', 60);

INSERT INTO ecoMotos (Matricula, Modelo, PrecioDia)
VALUES ('DEF789', 'Kawasaki Z650', 55);

INSERT INTO ecoMotos (Matricula, Modelo, PrecioDia)
VALUES ('GHI101', 'Suzuki GSX-S750', 65);

INSERT INTO ecoMotos (Matricula, Modelo, PrecioDia)
VALUES ('JKL202', 'Ducati Monster 821', 70);

INSERT INTO ecoMotos (Matricula, Modelo, PrecioDia)
VALUES ('MNO303', 'BMW F800R', 75);

INSERT INTO ecoMotos (Matricula, Modelo, PrecioDia)
VALUES ('PQR404', 'Harley-Davidson Iron 883', 80);

INSERT INTO ecoMotos (Matricula, Modelo, PrecioDia)
VALUES ('STU505', 'Triumph Street Triple', 72);

INSERT INTO ecoMotos (Matricula, Modelo, PrecioDia)
VALUES ('VWX606', 'Aprilia Shiver 900', 68);

INSERT INTO ecoMotos (Matricula, Modelo, PrecioDia)
VALUES ('YZA707', 'KTM 790 Duke', 76);