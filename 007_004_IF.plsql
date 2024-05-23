DECLARE
  v_salary_range VARCHAR2(50);
BEGIN
  DBMS_OUTPUT.PUT_LINE('EMPLOYEE_ID  |  FIRST_NAME  |  SALARY_CATEGORY');
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
  
  FOR emp IN (
    SELECT EMPLOYEE_ID, FIRST_NAME, SALARY,
           CASE 
             WHEN SALARY < 1000 THEN 1
             WHEN SALARY >= 1000 AND SALARY <= 2000 THEN 2
             ELSE 3
           END AS SALARY_RANGE_ORDER
    FROM HR.EMPLOYEES
    ORDER BY SALARY_RANGE_ORDER
  ) LOOP
    IF emp.SALARY < 1000 THEN
      v_salary_range := 'SALARY < 1000';
    ELSIF emp.SALARY >= 1000 AND emp.SALARY <= 2000 THEN
      v_salary_range := 'SALARY between 1000 and 2000';
    ELSE
      v_salary_range := 'SALARY > 2000';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(emp.EMPLOYEE_ID || '  |  ' || emp.FIRST_NAME || '  |  ' || v_salary_range);
  END LOOP;
END;
/
