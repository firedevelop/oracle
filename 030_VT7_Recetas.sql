SET SERVEROUTPUT ON

drop table recetas;
create table recetas (
   receta_id          int primary key,
   nombre             varchar(255) not null,
   ingredientes       varchar(255) not null,
   instrucciones      varchar(255) not null,
   tiempo_preparacion int not null
);

insert into recetas (
   receta_id,
   nombre,
   ingredientes,
   instrucciones,
   tiempo_preparacion
) values ( 1,
           'Torta de Chocolate',
           'Chocolate, harina, az�car, huevos, mantequilla',
           'Mezclar ingredientes y hornear por 45 minutos.',
           60 );
insert into recetas (
   receta_id,
   nombre,
   ingredientes,
   instrucciones,
   tiempo_preparacion
) values ( 2,
           'Ensalada C�sar',
           'Lechuga, crutones, queso parmesano, aderezo C�sar',
           'Mezclar todos los ingredientes en un taz�n.',
           15 );
insert into recetas (
   receta_id,
   nombre,
   ingredientes,
   instrucciones,
   tiempo_preparacion
) values ( 3,
           'Sopa de Tomate',
           'Tomates, cebolla, ajo, caldo de verduras',
           'Cocinar todos los ingredientes y licuar.',
           30 );
insert into recetas (
   receta_id,
   nombre,
   ingredientes,
   instrucciones,
   tiempo_preparacion
) values ( 4,
           'Arroz con Pollo',
           'Arroz, pollo, guisantes, zanahorias',
           'Cocinar el pollo, luego a�adir arroz y verduras.',
           45 );
insert into recetas (
   receta_id,
   nombre,
   ingredientes,
   instrucciones,
   tiempo_preparacion
) values ( 5,
           'Gazpacho',
           'Tomates, pimientos, pepino, cebolla, ajo',
           'Licuar los ingredientes y refrigerar antes de servir.',
           120 );


/*
Bloque An�nimo
Un bloque que muestra todas las recetas con un tiempo de preparaci�n menor o igual a 30 minutos, nombre y tiempo.
Este bloque recorre todas las recetas que se pueden preparar en menos de 30 minutos y las muestra.
*/

declare
    -- Definir un cursor para seleccionar las recetas con tiempo de preparaci�n <= 30
   cursor c_recetas_rapidas is
   select *
     from recetas
    where tiempo_preparacion <= 30;
    -- Variable para almacenar el nombre de la receta
   vc_recetas c_recetas_rapidas%rowtype;
begin
    -- Abrir el cursor
   open c_recetas_rapidas;

    -- Bucle para iterar sobre cada receta
   loop
        -- Fetch una receta del cursor
      fetch c_recetas_rapidas into vc_recetas;

        -- Salir del bucle si no hay m�s recetas
      exit when c_recetas_rapidas%notfound;

        -- Mostrar el nombre de la receta
      dbms_output.put_line('Receta r�pida: '
                           || vc_recetas.nombre
                           || ' --> '
                           || vc_recetas.tiempo_preparacion
                           || ' minutos');
   end loop;

    -- Cerrar el cursor
   close c_recetas_rapidas;
end;
/
/*
Procedimiento
Un procedimiento para a�adir una nueva receta.
Este procedimiento inserta una nueva receta en la tabla Recetas con los detalles proporcionados.
En caso de error saca un excepcion de que hay un error al insertar la receta
*/
create or replace procedure agregarreceta (
   p_id            int,
   p_nombre        varchar,
   p_ingredientes  varchar,
   p_instrucciones varchar,
   p_tiempo        int
) as
begin
   insert into recetas (
      receta_id,
      nombre,
      ingredientes,
      instrucciones,
      tiempo_preparacion
   ) values ( p_id,
              p_nombre,
              p_ingredientes,
              p_instrucciones,
              p_tiempo );

exception
   when dup_val_on_index then
      raise_application_error(
         -20001,
         p_id || ' Como Id de reserva ya existe.'
      );
   when others then
      raise_application_error(
         -20002,
         'Error al intentar insertar la receta ' || p_id
      );
end;
/
/*
Funci�n
Una funci�n que devuelve el tiempo de preparaci�n de una receta y le a�ade 5 minutos mas de tiempo
Esta funci�n devuelve el tiempo de preparaci�n de una receta bas�ndose en su ID. 
Si la receta no existe, devuelve -1 y una excepci�n.
*/
create or replace function obtenertiempopreparacion (
   p_id int
) return int as
   tiempo      int;
   extratiempo int := 5;
begin
   select tiempo_preparacion
     into tiempo
     from recetas
    where receta_id = p_id;
   tiempo := tiempo + extratiempo;
   return tiempo;
exception
   when no_data_found then
      raise_application_error(
         -20001,
         'La receta '
         || p_id
         || ' NO existe'
      );
      return -1;
end;
/
/*
Trigger
Un trigger que verifica si el tiempo de preparaci�n es razonable (no m�s de 120 minutos).
Este disparador se ejecuta antes de insertar o actualizar una nueva receta y valida que el tiempo no sea mayor a 120 minutos
*/
create or replace trigger verificartiempopreparacion before
   insert or update on recetas
   for each row
begin
-- Tanto para INSERTING como UPDATING ser� con el campo NEW
   if :new.tiempo_preparacion > 120 then
      raise_application_error(
         -20001,
         'Tiempo de preparaci�n demasiado largo'
      );
   end if;
end;

/*
Bloque an�nimo que primero use el procedimiento AgregarReceta para insertar una nueva receta 
Luego use la funci�n ObtenerTiempoPreparacion para obtener el tiempo de preparaci�n de esa receta.
Se muestre todo y si hay una excepci�n se puda ver con un mensaje de error
*/
/

delete from recetas
 where receta_id = 6;
/
declare
   p_id            int := 6;
   p_nombre        varchar2(255) := 'Paella';
   p_ingredientes  varchar2(255) := 'Arroz, mariscos, guisantes, pimiento';
   p_instrucciones varchar2(255) := 'Cocinar los mariscos, luego a�adir arroz y verduras.';
   p_tiempo        int := 45;
   v_tiempo        int;
begin

    -- Leer valores de entrada del usuario desde la consola
    -- A�adir una nueva receta usando el procedimiento AgregarReceta
   agregarreceta(
      p_id,
      p_nombre,
      p_ingredientes,
      p_instrucciones,
      p_tiempo
   );
    
    -- Mostrar mensaje confirmando la inserci�n
   dbms_output.put_line('Nueva receta a�adida: ' || p_nombre);

    -- Comprobar el tiempo de preparaci�n de la nueva receta usando la funci�n ObtenerTiempoPreparacion
   v_tiempo := obtenertiempopreparacion(p_id);
   dbms_output.put_line('Tiempo total de preparaci�n de: '
                        || p_nombre
                        || ' es de '
                        || v_tiempo
                        || ' minutos');
exception
   when others then
      raise_application_error(
         -20001,
         'Error durante la ejecuci�n del bloque: ' || sqlerrm
      );
end;