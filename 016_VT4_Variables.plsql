set serveroutput on;

create table promedio_asignatura(
    codigo_asig varchar2(10) primary key,
    nombre varchar2(25),
    promedio decimal(5,2)
);

select a.codigo_asig, a.nombre, round(avg(n.nota),2) as promedio
    from notas n
    join asignaturas a on n.codigo_asig = a.codigo_asig
    group by a.codigo_asig, a.nombre;



declare
v_codigo_asig varchar2(10);
v_promedio float;
v_nombre_asig varchar(25);
v_contador int := 0;
v_suma_promedios float := 0;
v_promedio_glob float;

cursor cursor_asignatura IS
select a.codigo_asig, a.nombre, round(avg(n.nota),2) as promedio
    from notas n
    join asignaturas a on n.cod_asig = a.codigo_asig
    group by a.codigo_asig, a.nombre;

begin

open cursor_asignatura;

loop
fetch cursor_asignatura into v_codigo_asig, v_nombre_asig, v_promedio;

exit when cursor_asignatura%notfound;

if v_promedio > 7 THEN
DBMS_OUTPUT.PUT_LINE('La asignatura ' || v_nombre_asig || ' tiene un promedio de: ' || v_promedio);
end if;
v_contador := v_contador + 1;
v_suma_promedios := v_suma_promedios + v_promedio;

-- INSERT INTO promedio_asignatura VALUES (v_codigo_asig, v_nombre_asig, v_promedio);

end loop;

v_promedio_glob := round(v_suma_promedios / v_contador, 2);

DBMS_OUTPUT.PUT_LINE('Promedio Global: ' || v_promedio_glob);

-- EXCEPTION

END;

/

Select * from promedio_asignatura;

