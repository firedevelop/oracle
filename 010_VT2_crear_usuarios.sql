/*
C�digo para eliminar lo que creamos y empezar de nuevo todo
DROP USER cliente_emilio CASCADE;
DROP USER onliner CASCADE;
DROP ROLE ver_tablas;
DROP PROFILE limitar_usuario CASCADE;
*/

-- Por defecto para crear un usuario debes comenzar con el prefijo C## antes del nombre del usuario pero con el siguiente comando evitas tener que poner C##
-- Crea un nuevo usuario llamado "C##onliner" con el password  'o1234'.
CREATE USER C##onliner IDENTIFIED BY o1234;

-- Eliminar usuarios
DROP USER C##onliner CASCADE;

-- Crea un nuevo usuario llamado 'Onliner' con el password  'o1234'.
CREATE USER onliner IDENTIFIED BY oracle;
drop user onliner cascade;

/* Si quer�as crear un usuario local sin ese prefijo, ten�as que establecer el par�metro _ORACLE_SCRIPT en true para que Oracle permitiera la creaci�n de un usuario 
sin el prefijo C## . este comando se utiliza para permitir la creaci�n de usuarios y esquemas sin la necesidad de cumplir con las reglas de nomenclatura  de Oracle */

ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- Concede todos los privilegios posibles a 'onliner'.
-- Esto otorga control total sobre la base de datos.
GRANT ALL PRIVILEGES TO onliner;

-- Revoca el privilegio de crear una sesi�nn de 'onliner'.
-- Esto revoca el derecho del usuario 'onliner' para iniciar sesi?n en la base de datos.
REVOKE ALL PRIVILEGES FROM onliner;

-- Crea un nuevo usuario llamado 'cliente' con el password  'c1234'.
CREATE USER cliente_emilio IDENTIFIED BY oracle;

ALTER USER cliente_emilio IDENTIFIED BY oracle;

--  Conceder privilegios b�sicos a un usuario:
GRANT CREATE SESSION TO cliente_emilio;

-- Conceder un rol a un usuario

-- Primero, se crea un rol con ciertos privilegios
CREATE ROLE ver_tablas;

-- Se otorgan privilegios al rol de ver cualquier tabla
GRANT SELECT any table TO ver_tablas;

-- Luego, se asigna el rol al usuario 'onliner'
GRANT ver_tablas TO cliente_emilio;

-- Conceder un perfil a un usuario:
CREATE PROFILE limitar_usuario LIMIT
  CONNECT_TIME 1; --Tiempo m�ximo de conexi�n de 1 minuto.

ALTER USER cliente_emilio PROFILE limitar_usuario;
