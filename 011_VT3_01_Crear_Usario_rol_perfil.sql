ALTER SESSION SET "_ORACLE_SCRIPT" = true;

-- Eliminamos lo que vamos a crear
DROP TABLESPACE tablespace_test including contents and datafiles;
DROP USER usuario_test CASCADE;
DROP ROLE rol_test;
DROP PROFILE perfil_test;


-- Paso 1: Crear un Tablespace
CREATE TABLESPACE tablespace_test
  DATAFILE 'tablespace_test.dbf' SIZE 100M;

-- Paso 2: Crear un Usuario
CREATE USER usuario_test IDENTIFIED BY usuario1234
  DEFAULT TABLESPACE tablespace_test;

-- Paso 3: Modificar un Usuario
ALTER USER  usuario_test IDENTIFIED BY u1234;

-- Paso 4: Conceder Privilegios al Usuario nuevo 
GRANT CREATE SESSION, CREATE TABLE TO usuario_test;

-- Paso 5: Crear un Rol y Conceder Privilegios al Rol
CREATE ROLE rol_test;

-- GRANT SELECT, INSERT, UPDATE ON onliner.* TO rol_test; -- OJO PAGINA 50 el *.* no funciona
-- Para otorgar permisos a todas las tablas en Oracle como lo har�as en MySQL. Debes enumerar cada tabla individualmente en las sentencias GRANT.

GRANT SELECT, UPDATE ON onliner.clientes TO rol_test;
GRANT SELECT, UPDATE ON onliner.ciudades TO rol_test;
GRANT SELECT, UPDATE ON onliner.cliente_ciudad TO rol_test;

-- Paso 6: Quitar privilegios al Rol
REVOKE UPDATE ON onliner.clientes FROM rol_test;
REVOKE UPDATE ON onliner.ciudades FROM rol_test;
REVOKE UPDATE ON onliner.cliente_ciudad FROM rol_test;

-- Paso 7: Crear un Perfil y establece l�mites en varios aspectos de sesi�n para los usuarios que se asignen a este perfil. 
CREATE PROFILE perfil_test LIMIT
  SESSIONS_PER_USER 5
  CONNECT_TIME 30
  FAILED_LOGIN_ATTEMPTS 3;

-- Paso 8: Modficar el perfil
ALTER PROFILE perfil_test LIMIT
  IDLE_TIME 5
  FAILED_LOGIN_ATTEMPTS 5;
  
-- Paso 9: Asignar el rol y el perfil creados al usuario
ALTER USER usuario_test PROFILE perfil_test;
GRANT rol_test TO usuario_test;


-- Paso 10: Probar los privilegios y l�mites del usuario
-- Ver datos del usuario
SELECT * FROM DBA_USERS WHERE username = 'USUARIO_TEST';

CONN usuario_test / 1234; -- Probar 4 veces
-- Para desbloquear el usuario
ALTER USER usuario_test ACCOUNT UNLOCK; 

-- Ejecutar este trozo de c�digo todo junto para que sea con el usuario
CONN usuario_test / u1234; 
SELECT * FROM onliner.clientes; --Si debe poder consultar
UPDATE onliner.clientes set edad = 27 WHERE  dni = '12345678A'; -- No debe permitir 



