DECLARE
  v_employee_id NUMBER;
  v_first_name VARCHAR2(20);
  v_salary NUMBER;
  v_commission_pct NUMBER;
  v_message VARCHAR2(100);
BEGIN
  SELECT employee_id, first_name, salary, commission_pct
    INTO v_employee_id, v_first_name, v_salary, v_commission_pct
    FROM hr.employees
    WHERE employee_id = 107; -- Replace with your desired employee ID

  IF v_commission_pct IS NULL THEN
    v_message := v_first_name || ' earns a fixed salary of ' || v_salary;
  ELSIF v_commission_pct > 10 THEN
    v_message := v_first_name || ' earns a salary of ' || v_salary ||
                 ' and a high commission of ' || v_commission_pct || '%';
  ELSE
    v_message := v_first_name || ' earns a salary of ' || v_salary ||
                 ' and a commission of ' || v_commission_pct || '%';
  END IF;

  DBMS_OUTPUT.PUT_LINE(v_message);
END;
/
