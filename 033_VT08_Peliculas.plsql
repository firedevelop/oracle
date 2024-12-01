/*
Aclaración Ejercicio VT Con error en los Triggers


En PL/SQL, técnicamente puedes crear dos triggers (disparadores) con lógica parecida pero con nombres diferentes en una misma tabla.

Sin embargo, esto no es recomendable y puede llevar a problemas de rendimiento y, en algunos casos, a errores de mutación de tabla.

¿Qué es un error de mutación de tabla?
Un error de mutación de tabla ocurre cuando un trigger intenta consultar o modificar la misma tabla sobre la cual está actuando en ese momento.

Esto puede pasar, por ejemplo, cuando:

Un trigger de tipo BEFORE INSERT o AFTER INSERT intenta hacer una consulta o manipulación en la tabla en la que está configurado.
Múltiples triggers en la misma tabla intentan realizar consultas o manipulaciones que se interrelacionan, lo que puede provocar un bucle o una dependencia circular.
Si los triggers intentan modificar la misma tabla en la que se disparan, esto genera un error de mutación de tabla. En PL/SQL, los triggers no pueden realizar operaciones DML (como INSERT, UPDATE o DELETE) en la misma tabla sobre la que se están ejecutando, ya que esto crearía una dependencia circular. Esto aplica incluso si los triggers tienen nombres diferentes.

Solución: Usar un mismo triggers: Combinar la lógica en un solo trigger en lugar de dividirla en varios.
*/

-- Creaci�n de la tabla Pel�culas
DROP TABLE peliculas;
CREATE TABLE peliculas (
    id_pelicula      NUMBER PRIMARY KEY,
    titulo           VARCHAR2(255),
    director         VARCHAR2(255),
    anio_estreno     NUMBER,
    duracion_minutos NUMBER,
    genero           VARCHAR2(100)
);



-- Inserciones en la tabla Pel�culas
INSERT INTO Peliculas VALUES (1, 'Inception', 'Christopher Nolan', 2010, 148, 'Ciencia Ficci�n');
INSERT INTO Peliculas VALUES (2, 'The Matrix', 'Lana y Lilly Wachowski', 1999, 136, 'Acci�n');
INSERT INTO Peliculas VALUES (3, 'Interstellar', 'Christopher Nolan', 2014, 169, 'Ciencia Ficci�n');
INSERT INTO Peliculas VALUES (4, 'The Godfather', 'Francis Ford Coppola', 1972, 175, 'Crimen');
INSERT INTO Peliculas VALUES (5, 'Pulp Fiction', 'Quentin Tarantino', 1994, 154, 'Crimen');
INSERT INTO Peliculas VALUES (6, 'The Shawshank Redemption', 'Frank Darabont', 1994, 142, 'Drama');
INSERT INTO Peliculas VALUES (7, 'The Dark Knight', 'Christopher Nolan', 2008, 152, 'Acci�n');
INSERT INTO Peliculas VALUES (8, 'Forrest Gump', 'Robert Zemeckis', 1994, 142, 'Drama');
INSERT INTO Peliculas VALUES (9, 'Gladiator', 'Ridley Scott', 2000, 155, 'Acci�n');
INSERT INTO Peliculas VALUES (10, 'The Lion King', 'Roger Allers y Rob Minkoff', 1994, 88, 'Animaci�n');

/

-- ACTUALIZAR GENERO
/*
Procedimiento "ActualizarGenero"
Desarrolla un procedimiento almacenado llamado ActualizarGenero que permita actualizar el g�nero de una pel�cula dado su id_pelicula y un nuevo g�nero como par�metros. 
El procedimiento debe verificar si la pel�cula existe y manejar adecuadamente los errores en caso de que no se encuentre o surjan otros problemas durante la actualizaci�n.
*/
CREATE OR REPLACE PROCEDURE actualizargenero (
    p_id_pelicula  IN peliculas.id_pelicula%TYPE,
    p_nuevo_genero IN peliculas.genero%TYPE
) IS
    v_genero_actual peliculas.genero%TYPE;
BEGIN

 -- Intentar obtener el g�nero actual de la pel�cula
    SELECT  genero
    INTO v_genero_actual
    FROM  peliculas
    WHERE  id_pelicula = p_id_pelicula;

 -- Si la pel�cula existe, actualizar el g�nero
    UPDATE peliculas
    SET
        genero = p_nuevo_genero
    WHERE
        id_pelicula = p_id_pelicula;

 -- Mostrar un mensaje de confirmaci�n
    dbms_output.put_line('G�nero actualizado correctamente para la pel�cula con ID ' || p_id_pelicula);
EXCEPTION
 -- Si la pel�cula no se encuentra, manejar la excepci�n
    WHEN no_data_found THEN                             
      RAISE_APPLICATION_ERROR(-20000, 'La pel�cula con el ID '
                             || p_id_pelicula
                             || ' no existe.');                       
 -- Gesti�n de excepciones en caso de cualquier otro error
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001, 'Error al actualizar el g�nero: ' || sqlerrm); 
  -- Se podr�a incluir un ROLLBACK si es necesario
END actualizargenero;

/

-- DURACION PELICULA
/*
Funci�n "DuracionPelicula"
Crea una funci�n llamada DuracionPelicula que devuelva la duraci�n de una pel�cula dado su id_pelicula. 
Si la pel�cula no existe, la funci�n debe manejar la excepci�n NO_DATA_FOUND y retornar NULL.
*/
CREATE OR REPLACE FUNCTION duracionpelicula (
    p_id_pelicula IN peliculas.id_pelicula%TYPE
) RETURN NUMBER IS
    v_duracion NUMBER;
BEGIN

 -- Intentar obtener la duraci�n de la pel�cula con el ID proporcionado
    SELECT
        duracion_minutos
    INTO v_duracion
    FROM
        peliculas
    WHERE
        id_pelicula = p_id_pelicula;


 -- Devolver la duraci�n obtenida
    RETURN v_duracion;
EXCEPTION

 -- Si la pel�cula no se encuentra, manejar la excepci�n
    WHEN no_data_found THEN

      RETURN NULL; -- O podr�as elegir devolver un valor especial como 0
      RAISE_APPLICATION_ERROR(-20002, 'La pel�cula con el ID '
                             || p_id_pelicula
                             || ' no existe.'); 


 -- Gesti�n de excepciones en caso de cualquier otro error
    WHEN OTHERS THEN
    RETURN NULL; -- O podr�as elegir devolver un valor especial como 0
      RAISE_APPLICATION_ERROR(-20003, 'Error al obtener la duraci�n: ' || sqlerrm); 

END duracionpelicula;

/

-- VERIFICAR DURACION
/*
Trigger "VerificarDuracion"
Implementa un trigger llamado VerificarDuracion que se active antes de insertar o actualizar registros en la tabla Peliculas. 
Este trigger debe verificar que la duraci�n de las pel�culas no exceda los 240 minutos.
Si se intenta exceder este l�mite, el trigger debe impedir la operaci�n y mostrar un mensaje de error.
*/
CREATE OR REPLACE TRIGGER verificarduracion BEFORE
    INSERT OR UPDATE ON peliculas
    FOR EACH ROW
BEGIN

  -- Verificar si la duraci�n de la pel�cula es mayor a 240 minutos
    IF :NEW.duracion_minutos > 240 THEN
    -- Si la duraci�n excede 240 minutos, se lanza un error
        raise_application_error(-20004, 'La duraci�n de la pel�cula no puede ser superior a 240 minutos.');
    END IF;
END;

/

-- LIMITAR GENERO PELICULAS
/*
Trigger "LimitarGeneroPeliculas"
Desarrolla otro trigger llamado LimitarGeneroPeliculas que impida la inserci�n o actualizaci�n de una pel�cula si ya existen 10 pel�culas del mismo g�nero en la base de datos.
*/
CREATE OR REPLACE TRIGGER LimitarGeneroPeliculas
BEFORE INSERT OR UPDATE ON Peliculas
FOR EACH ROW
DECLARE
    contador_genero NUMBER;
BEGIN
    -- Contar cu�ntas pel�culas existen ya con el mismo g�nero que la pel�cula que se intenta insertar o actualizar
    SELECT COUNT(*)
    INTO contador_genero
    FROM Peliculas
    WHERE genero = :NEW.genero;

    -- Si ya hay 10 o m�s pel�culas con ese g�nero, no permitir la inserci�n o actualizaci�n
    IF contador_genero >= 10 THEN
        RAISE_APPLICATION_ERROR(-20005, 'No se puede insertar o actualizar la pel�cula porque ya existen 10 o m�s pel�culas del g�nero ' || :NEW.genero);
    END IF;
END LimitarGeneroPeliculas;


/
-- BLOQUE ANONIMO
/*
Bloque An�nimo
Escribe un bloque an�nimo PL/SQL que muestre un mensaje para cada pel�cula con una duraci�n mayor a 150 minutos. 
Utiliza un cursor expl�cito y un bucle LOOP para iterar sobre las pel�culas y mostrar los mensajes. 
Aseg�rate de manejar cualquier excepci�n que pueda ocurrir.
*/
SET SERVEROUTPUT ON
DECLARE

 -- Definici�n del cursor para seleccionar pel�culas con duraci�n mayor a 150 minutos
 CURSOR peliculas_largas IS
  SELECT titulo, duracion_minutos FROM Peliculas WHERE duracion_minutos > 150;

 -- Variable para almacenar la fila actual del cursor
 pelicula peliculas_largas%ROWTYPE;
BEGIN

 -- Abrir el cursor
 OPEN peliculas_largas;

 -- Bucle para recorrer todas las filas del cursor
 LOOP
  -- Recuperar la siguiente fila del cursor
  FETCH peliculas_largas INTO pelicula;
  
  -- Salir del bucle cuando no haya m�s filas
  EXIT WHEN peliculas_largas%NOTFOUND;
  
  -- Mostrar el mensaje con el t�tulo de la pel�cula y su duraci�n
  DBMS_OUTPUT.PUT_LINE('La pel�cula "' || pelicula.titulo || '" tiene una duraci�n de ' || pelicula.duracion_minutos || ' minutos y es considerada larga.');
 END LOOP;

 -- Cerrar el cursor

 CLOSE peliculas_largas;

END;
