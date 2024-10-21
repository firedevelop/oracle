-- 0. DESCRIPTION
-- Practice user administration


-- 1. CLEAN OLD DATA
------------------------------------
drop tablespace ts including contents and datafiles;
drop user u cascade;
drop table u.clients;
drop table u.cities;
drop rol u_role;
drop profile u_profile;


-- 2. CREATE TABLESPACE, USER, TABLES
------------------------------------
CREATE USER c##u IDENTIFIED BY oracle;
DROP USER c##u CASCADE;
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

create tablespace ts datafile 'ts.dbf' size 10M;
create user u identified by oracle default tablespace ts;
alter user u identified by oracle default tablespace ts;
grant create session, create table to u;
grant UNLIMITED tablespace to u; 
create table u.clients (id number primary key, name varchar(10));
create table u.cities (id number, name varchar(10));


-- 3. ROLE
------------------------------------
create role u_role;
grant select, insert, update, delete on u.clients to u_role;
grant select, insert, update, delete on u.cities to u_role;
grant select any table to u_role;
grant u_role to u;

revoke update on u.clients from u_role;
revoke update on u.cities from u_role;
drop role u_role;


-- 3. PROFILE
------------------------------------
CREATE PROFILE u_profile LIMIT
    SESSIONS_PER_USER 3
    CONNECT_TIME 3
    FAILED_LOGIN_ATTEMPTS 3;

ALTER PROFILE u_profile LIMIT
    IDLE_TIME 4
    FAILED_LOGIN_ATTEMPTS 4;

ALTER USER u PROFILE u_profile;

ALTER USER u PROFILE DEFAULT;
DROP PROFILE u_profile CASCADE;


-- 4. TEST
------------------------------------
connect sys/oracle;
connect u/oracle;
select user from dual;
SELECT * FROM DBA_USERS WHERE USERNAME = 'U'; -- username in capital letters


-- 5. Lock / UnLock user
------------------------------------
connect u/1111;
connect u/1111;
connect u/1111;
connect u/1111;
connect u/1111;
alter user u account unlock;
SELECT * FROM onliner.clientes; --Si debe poder consultar
UPDATE onliner.clientes set edad = 27 WHERE  dni = '12345678A'; -- No debe 
