DECLARE
    V_SALARY_RANGE VARCHAR2(50);
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE_ID  |  FIRST_NAME  |  SALARY_CATEGORY');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    FOR EMP IN (
        SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            SALARY
        FROM
            HR.EMPLOYEES
    ) LOOP
        IF EMP.SALARY < 10000 THEN
            V_SALARY_RANGE := 'SALARY < 10000';
        ELSIF EMP.SALARY >= 10000 AND EMP.SALARY <= 20000 THEN
            V_SALARY_RANGE := 'SALARY between 10000 and 20000';
        ELSE
            V_SALARY_RANGE := 'SALARY > 20000';
        END IF;

        DBMS_OUTPUT.PUT_LINE(EMP.EMPLOYEE_ID
                             || '  |  '
                             || EMP.FIRST_NAME
                             || '  |  '
                             || V_SALARY_RANGE);
    END LOOP;
END;
/