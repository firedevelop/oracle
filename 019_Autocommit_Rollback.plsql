-- 1. AUTOCOMMIT ROLLBACK
------------------------------------
/*  SET AUTOCOMMIT OFF; -- you cannot use ROLLBACK
    SET AUTOCOMMIT ON;  -- you can use ROLLBACK

    COMMIT = after commit ROLLBACK doesn't apply changes.

    If some query is commit you cannot rollback.
*/
SHOW AUTOCOMMIT;
SET AUTOCOMMIT OFF;
SET AUTOCOMMIT ON;
update notas set nota = 10 where nota = 9;
ROLLBACK;

select * from notas;



