alter session set "_ORACLE_SCRIPT" = true;
set serveroutput on;

declare
    promedio_asignatura float;
    nombre_asignaturas varchar(25);

    cursor cursor_asignaturas IS
    select
        a.nombre
        avg(n.nota) as promedio
    FROM
        nota n
        join asignaturas a on n.codigo_asig = a.codigo_asig
    group by a.nombre;



