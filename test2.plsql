CREATE OR REPLACE PROCEDURE REGISTRAR_ALQUILER (
    P_DNI IN VARCHAR2,
    P_FECHAINI IN DATE,
    P_MATRICULA IN VARCHAR2,
    P_FECHAFIN IN DATE
) IS
    v_precio_dia    NUMBER;
    v_dias_alquiler NUMBER;
    v_precio_total  NUMBER;
    v_disponible    CHAR(2);
    v_modelo        VARCHAR2(50);
    no_disponible EXCEPTION;
    dias_alquiler EXCEPTION;
    other_error EXCEPTION;
    v_dias_alquiler := P_FECHAFIN - P_FECHAINI;
    if              V_DIAS_ALQUILER < 2 THEN
        RAISE DIAS_ALQUILER;
    END IF;
    select          PRECIODIA, DISPONIBLE, MODELO INTO V_PRECIO_DIA, V_DISPONIBLE, V_MODELO FROM ECOMOTOS WHERE MATRICULA = P_MATRICULA;
    if              V_DISPONIBLE = 'NO' THEN
        RAISE NO_DISPONIBLE;
    END IF;
    v_precio_total  := V_DIAS_ALQUILER * V_PRECIO_DIA;
    insert          INTO ECOALQUILERES (DNI, FECHAINI, MATRICULA, FECHAFIN, DIASALQUILER, PRECIOALQUILER) VALUES (P_DNI, P_FECHAINI, P_MATRICULA, P_FECHAFIN, V_DIAS_ALQUILER, V_PRECIO_TOTAL);
    dbms_output     .PUT_LINE('El Alquiler de la moto '
                              || V_MODELO
                              || ' ha sido registrado correctamente');
    exception       WHEN DIAS_ALQUILER THEN
        RAISE_APPLICATION_ERROR(-20001, 'El Alquiler ha de ser mínimo de 2 días');
        when            NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'La moto con matricula '
                                            || P_MATRICULA
                                            || ' no se ha podido encontrar');
            when            NO_DISPONIBLE THEN
                RAISE_APPLICATION_ERROR(-20003, 'La moto con matricula '
                                                || P_MATRICULA
                                                || ' y modelo '
                                                || V_MODELO
                                                || ' no está disponible en estos momentos');
                when            OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20004, 'Se ha producido un error inesperado: '
                                                    || SQLERRM);
                END registrar_alquiler;