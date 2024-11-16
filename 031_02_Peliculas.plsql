-- Creación de la tabla Películas
CREATE TABLE Peliculas (
    id_pelicula NUMBER PRIMARY KEY,
    titulo VARCHAR2(255),
    director VARCHAR2(255),
    anio_estreno NUMBER,
    duracion_minutos NUMBER,
    genero VARCHAR2(100)
);

-- Inserciones en la tabla Películas
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

-- Procedimiento ActualizarGenero
CREATE OR REPLACE PROCEDURE ActualizarGenero(
    p_id_pelicula IN NUMBER,
    p_nuevo_genero IN VARCHAR2
) IS
BEGIN
    -- Intenta actualizar el género de la película
    UPDATE Peliculas
    SET genero = p_nuevo_genero
    WHERE id_pelicula = p_id_pelicula;
    
    -- Si no se actualizó ninguna fila, NO_DATA_FOUND se lanzará automáticamente
    IF SQL%NOTFOUND THEN
        RAISE NO_DATA_FOUND;
    END IF;
    
    -- Si la actualización fue exitosa, muestra mensaje de éxito
    DBMS_OUTPUT.PUT_LINE('Género actualizado exitosamente para la película ID: ' || p_id_pelicula);
    
    COMMIT;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se encontró la película con ID: ' || p_id_pelicula);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
        ROLLBACK;
END ActualizarGenero;
/

-- Función DuracionPelicula
CREATE OR REPLACE FUNCTION DuracionPelicula(
    p_id_pelicula IN NUMBER
) RETURN NUMBER IS
    v_duracion NUMBER;
BEGIN
    -- Intenta obtener la duración de la película
    SELECT duracion_minutos 
    INTO v_duracion
    FROM Peliculas
    WHERE id_pelicula = p_id_pelicula;
    
    RETURN v_duracion;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se encontró la película con ID: ' || p_id_pelicula);
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
        RETURN NULL;
END DuracionPelicula;
/

-- Trigger VerificarDuracion
CREATE OR REPLACE TRIGGER VerificarDuracion
BEFORE INSERT OR UPDATE ON Peliculas
FOR EACH ROW
BEGIN
    -- Verifica si la duración excede los 240 minutos
    IF :NEW.duracion_minutos > 240 THEN
        RAISE_APPLICATION_ERROR(-20002, 
            'La duración de la película no puede ser superior a 240 minutos.');
    END IF;
END VerificarDuracion;
/

-- Trigger LimitarGeneroPeliculas
CREATE OR REPLACE TRIGGER LimitarGeneroPeliculas
BEFORE INSERT OR UPDATE ON Peliculas
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Cuenta cuántas películas existen del mismo género
    SELECT COUNT(*)
    INTO v_count
    FROM Peliculas
    WHERE genero = :NEW.genero
    AND id_pelicula != NVL(:NEW.id_pelicula, 0); -- Excluye la película actual en caso de UPDATE
    
    -- Si ya hay 10 o más películas del mismo género, lanza un error
    IF v_count >= 10 THEN
        RAISE_APPLICATION_ERROR(-20003, 
            'No se pueden tener más de 10 películas del género ' || :NEW.genero);
    END IF;
END LimitarGeneroPeliculas;
/

-- Bloque Anónimo para mostrar películas con duración mayor a 180 minutos
DECLARE
    -- Declaración del cursor explícito
    CURSOR c_peliculas_largas IS
        SELECT titulo, duracion_minutos
        FROM Peliculas
        WHERE duracion_minutos > 180;
    
    -- Variables para almacenar los datos del cursor
    v_titulo Peliculas.titulo%TYPE;
    v_duracion Peliculas.duracion_minutos%TYPE;
BEGIN
    -- Abre el cursor
    OPEN c_peliculas_largas;
    
    -- Bucle para procesar cada película
    LOOP
        FETCH c_peliculas_largas INTO v_titulo, v_duracion;
        EXIT WHEN c_peliculas_largas%NOTFOUND;
        
        -- Muestra el mensaje para cada película
        DBMS_OUTPUT.PUT_LINE('La película ' || v_titulo || 
            ' tiene una duración extensa de más de 180 minutos.');
    END LOOP;
    
    -- Cierra el cursor
    CLOSE c_peliculas_largas;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        -- Asegura que el cursor se cierre en caso de error
        IF c_peliculas_largas%ISOPEN THEN
            CLOSE c_peliculas_largas;
        END IF;
END;
/

-- Respuestas a las preguntas:

-- 1. El procedimiento "ActualizarGenero" verifica primero si existe la película...
-- Respuesta: Verdadero
-- El procedimiento verifica la existencia de la película mediante el UPDATE y SQL%NOTFOUND

-- 2. La función "DuracionPelicula" si la película no se encuentra devuelve 0...
-- Respuesta: Falso
-- La función devuelve NULL cuando no encuentra la película, no 0

-- 3. El trigger "VerificarDuracion" permite duraciones de exactamente 240 minutos...
-- Respuesta: Falso
-- El trigger solo permite duraciones menores a 240 minutos (usa >)

-- 4. El trigger "LimitarGeneroPeliculas" se dispara con un AFTER...
-- Respuesta: Falso
-- El trigger usa BEFORE, no AFTER

-- 5. El bloque anónimo utiliza un cursor implícito...
-- Respuesta: Falso
-- El bloque anónimo utiliza un cursor explícito declarado como c_peliculas_largas