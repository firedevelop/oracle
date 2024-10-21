-- Create tableSpace
CREATE TABLESPACE tbs6
DATAFILE 'tbs6_data.dbf' 
SIZE 10M;


-- Check new tableSpace
SELECT * FROM dba_data_files;


select file_name, bytes /1024 /1024 from dba_data_files;


-- use table on specific tableSpace
create table a2 (ID int primary key, Name varchar2(25)) tablespace tbs1;
-- Check database and tablespace used
FROM dba_data_files;

-- remove complete
DROP TABLESPACE tbs6 INCLUDING CONTENTS AND DATAFILES;
