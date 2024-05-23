-- Connect as SYSDBA
connect sys/oracle@localhost:1521/XEPDB1 as sysdba;

-- Grant debug privileges to user
GRANT DEBUG CONNECT SESSION TO SYSTEM;
GRANT DEBUG ANY PROCEDURE TO SYSTEM;

-- Set up ACL to allow the database to connect back to Visual Studio Code
-- IP address and ports are those used for debugging on local VS Code machine
-- This needs to be done once for the machine.
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
  HOST => 'localhost',
  LOWER_PORT => 65000,  -- Starting port number for Oracle database
  UPPER_PORT => 65535,  -- Ending port number for Oracle database (same as starting for single port)
  ACE => XS$ACE_TYPE(PRIVILEGE_LIST => XS$NAME_LIST('jdwp'),
    PRINCIPAL_NAME =>'SYSTEM',
    PRINCIPAL_TYPE => XS_ACL.PTYPE_DB));
END;
/
