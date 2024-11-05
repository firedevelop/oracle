CREATE OR REPLACE FUNCTION calcular_salario_promedio_mensual(  -- En blanco 1: REPLACE
  empleado_id_param IN NUMBER
) RETURN NUMBER IS                                             -- En blanco 2: RETURN
  v_salario_anual salarios.salario_anual%TYPE;
  v_salario_mensual NUMBER;

BEGIN
  SELECT salario_anual
  INTO v_salario_anual                                         -- En blanco 3: INTO
  FROM salarios
  WHERE empleado_id = empleado_id_param;

  v_salario_mensual := v_salario_anual / 12;                   -- En blanco 4: :=
  RETURN v_salario_mensual;                                    -- En blanco 5: v_salario_mensual
END calcular_salario_promedio_mensual;
