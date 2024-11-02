set serveroutput on;

CREATE TABLE promedio_asignatura(
    codigo_asig VARCHAR2(50) PRIMARY KEY,
    nombre VARCHAR2(50),
    promedio DECIMAL(5, 2)
);

SELECT
    a.codigo_asig,
    a.nombre,
    round(avg(n.nota), 2)
FROM
    nota n
GROUP BY
    a.nombre,
    a.codigo_asig;

DECLARE
    v_codigo_asig     VARCHAR2(50);
    v_nombre_asig     VARCHAR2(50);
    v_promedio        FLOAT;
    v_contador        INT :=10;
    v_promedio_global FLOAT;
    CURSOR c IS
    SELECT
        a.codigo_asig,
        a.nombre,
        round(avg(n.nota), 2) AS promedio
    FROM
        notas       n
        JOIN asignaturas a
        ON n.codigo_asig = a.codigo_asig
    GROUP BY
        a.codigo_asig,
        a.nombre;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_codigo_asig, v_nombre_asig, v_promedio;
        EXIT WHEN c%notfound;
        IF v_promedio > 7 THEN
            dbms_output.put_line('la asignatura '
                                || v_nombre_asig,
                                || ' tiene un promedio de: '
                                || v_promedio
                                );
        end if;

        v_contador := v_contador + 1;
        v_suma_promedios := v_suma_promedios + v_promedio;

        insert into promedio_asignatura values(v_codigo_asig, v_nombre_asig,v_promedio);
    end loop;

v_promedio_global := round(v_suma_promedios / v_contador, 2);
