SELECT employee_id, first_name, last_name,
  CASE WHEN salary >= 10000 THEN 'High Earner'
       WHEN salary >= 5000 THEN 'Mid-Range'
       ELSE 'Low Earner'
  END AS grade
FROM employees;
