DECLARE
  total_sales NUMBER := 0;
BEGIN
  SELECT SUM(SALARY) INTO total_sales FROM HR.EMPLOYEES;
  IF total_sales > 100000 THEN
    DBMS_OUTPUT.PUT_LINE('Total sales in EMPLOYEES exceed 100K: ' || total_sales);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Total sales in EMPLOYEES do not exceed 100K: ' || total_sales);
  END IF;
END;
/
