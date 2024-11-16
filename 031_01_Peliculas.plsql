-- Creación de la tabla Peliculas
CREATE TABLE Peliculas (
    id_pelicula NUMBER PRIMARY KEY,
    titulo VARCHAR2(255),
    director VARCHAR2(255),
    anio_estreno NUMBER,
    duracion_minutos NUMBER,
    genero VARCHAR2(100)
);

-- Inserción de datos en la tabla Peliculas
INSERT INTO Peliculas VALUES (1, 'Inception', 'Christopher Nolan', 2010, 148, 'Ciencia Ficción');
INSERT INTO Peliculas VALUES (2, 'The Matrix', 'Lana y Lilly Wachowski', 1999, 136, 'Acción');
INSERT INTO Peliculas VALUES (3, 'Interstellar', 'Christopher Nolan', 2014, 169, 'Ciencia Ficción');
INSERT INTO Peliculas VALUES (4, 'The Godfather', 'Francis Ford Coppola', 1972, 175, 'Crimen');
INSERT INTO Peliculas VALUES (5, 'Pulp Fiction', 'Quentin Tarantino', 1994, 154, 'Crimen');
INSERT INTO Peliculas VALUES (6, 'The Shawshank Redemption', 'Frank Darabont', 1994, 142, 'Drama');
INSERT INTO Peliculas VALUES (7, 'The Dark Knight', 'Christopher Nolan', 2008, 152, 'Acción');
INSERT INTO Peliculas VALUES (8, 'Forrest Gump', 'Robert Zemeckis', 1994, 142, 'Drama');
INSERT INTO Peliculas VALUES (9, 'Gladiator', 'Ridley Scott', 2000, 155, 'Acción');
INSERT INTO Peliculas VALUES (10, 'The Lion King', 'Roger Allers y Rob Minkoff', 1994, 88, 'Animación');

COMMIT;

-- Procedimiento ActualizarGenero
CREATE OR REPLACE PROCEDURE ActualizarGenero (
    p_id_pelicula IN NUMBER,
    p_nuevo_genero IN VARCHAR2
) IS
BEGIN
    UPDATE Peliculas
    SET genero = p_nuevo_genero
    WHERE id_pelicula = p_id_pelicula;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'La película con el ID especificado no existe.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El género de la película ha sido actualizado exitosamente.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: La película no existe.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Ocurrió un problema al actualizar el género.');
END ActualizarGenero;

-- Función DuracionPelicula
CREATE OR REPLACE FUNCTION DuracionPelicula (
    p_id_pelicula IN NUMBER
) RETURN NUMBER IS
    v_duracion NUMBER;
BEGIN
    SELECT duracion_minutos INTO v_duracion
    FROM Peliculas
    WHERE id_pelicula = p_id_pelicula;

    RETURN v_duracion;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: La película no existe.');
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Ocurrió un problema al obtener la duración.');
        RETURN NULL;
END DuracionPelicula;

-- Trigger VerificarDuracion
CREATE OR REPLACE TRIGGER VerificarDuracion
BEFORE INSERT OR UPDATE ON Peliculas
FOR EACH ROW
BEGIN
    IF :NEW.duracion_minutos > 240 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: La duración no puede ser superior a 240 minutos.');
    END IF;
END VerificarDuracion;

-- Trigger LimitarGeneroPeliculas
CREATE OR REPLACE TRIGGER LimitarGeneroPeliculas
BEFORE INSERT OR UPDATE ON Peliculas
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Peliculas
    WHERE genero = :NEW.genero;

    IF v_count >= 10 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error: No se puede añadir más películas de este género, ya existen 10.');
    END IF;
END LimitarGeneroPeliculas;

-- Bloque Anónimo
DECLARE
    CURSOR c_peliculas IS
        SELECT titulo, duracion_minutos
        FROM Peliculas
        WHERE duracion_minutos > 180;
    v_titulo Peliculas.titulo%TYPE;
    v_duracion Peliculas.duracion_minutos%TYPE;
BEGIN
    OPEN c_peliculas;
    LOOP
        FETCH c_peliculas INTO v_titulo, v_duracion;
        EXIT WHEN c_peliculas%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('La película ' || v_titulo || ' tiene una duración extensa de más de 180 minutos.');
    END LOOP;
    CLOSE c_peliculas;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
