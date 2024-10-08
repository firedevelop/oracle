
v$PWFILE_USERS;

-- create user user
CREATE USER user1 IDENTIFIED BY oracle;
SHOW user;
grant select, update(name) on a to user1;


-- Add grant permission to user1 (to allow access in Oracle XE)
GRANT CREATE SESSION TO user1;
conn user1 / oracle;
show user;

drop user user1 CASCADE;
drop user user1 CASCADE;

-- 1.  Install the apps Oracle XE and Oracle SQL Developer 

-- 2. Create SYSDBA user from SQL Developer
Name: SYSDBA
Username: sys
Password: oracle
Role: SYSDBA
Host: localhost
Port: 1521
Service name: XEPDB1

-- 3. Create user1 from and grant permission
create user1 IDENTIFIED by oracle;
GRANT CREATE SESSION TO user1;

-- 4. The user1 is ready. Create new connection on Oracle SQL Developer with the user1 details
Name: user1
Username: user1
Password: oracle
Role: Default
Host: localhost
Port: 1521
Service name: XEPDB1
 
-- 5. PRIVILEGIES TO CREATE TABLE (login as sys)
GRANT CREATE table to user1;
-- 5.1 login as user1 and you can create tables but not insert data
create table table1 (REGISTERID int PRIMARY key);
-- 5.2 login as sys and grant insert data to user1
grant UNLIMITED tablespace to user1; 
grant insert on table1 to user1;

insert into table1 values (1);
insert into table1 values(5);
show table1;


-- Log in as SYSDBA
GRANT SELECT, INSERT, UPDATE, DELETE ON table1 TO user1;
GRANT CREATE TABLE TO user1;
-- Check granted privileges
SELECT * FROM user_tab_privs WHERE grantee = 'USER1';
SELECT * FROM user_tab_privs;



-- Insert a row into table1 as user1
INSERT INTO table1 (REGISTERID) VALUES (7);

-- Check tables owned by all users
SELECT owner, table_name 
FROM all_tables 
WHERE table_name = 'TABLE1';
-- Grant select, insert, update, and delete privileges to user1
GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.table1 TO user1;
GRANT ALL PRIVILEGES TO user1;

-- Login as user1 and create the table
CREATE TABLE table1 (REGISTERID INT PRIMARY KEY);

-- Insert into the table as user1
INSERT INTO table1 (REGISTERID) VALUES (15);
insert into user1.table1 VALUES (16);
select * from user1.table1;


CONNECT user1/oracle@localhost:1521/XEPDB1;
GRANT SELECT, INSERT, UPDATE, DELETE ON table1 TO SYSOPER;



