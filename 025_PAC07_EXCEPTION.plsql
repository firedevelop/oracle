-- Tenemos la estructura de la tabla employees que contiene la información de los empleados. Utilice un cursor explícito para recuperar y mostrar todos los nombres de los empleados

CREATE TABLE employees (
    employee_id NUMBER(6) PRIMARY KEY,
    employee_name VARCHAR2(50),
    hire_date DATE,
    job_title VARCHAR2(50),
    manager_id NUMBER(6),
    salary NUMBER(8, 2),
    department_id NUMBER(4)
);

