EXECUTE registrar_alquiler('77889900I', TO_DATE('2024-11-11', 'YYYY-MM-DD'), 'JKL202', TO_DATE('2024-11-25', 'YYYY-MM-DD'));

EXECUTE registrar_alquiler('11223344C', TO_DATE('2024-11-05', 'YYYY-MM-DD'), 'DEF789', TO_DATE('2024-11-15', 'YYYY-MM-DD'));

EXECUTE registrar_alquiler('33445566D', TO_DATE('2024-11-05', 'YYYY-MM-DD'), 'GHI101', TO_DATE('2024-11-20', 'YYYY-MM-DD'));

EXECUTE registrar_alquiler('12345678A', TO_DATE('2024-11-01', 'YYYY-MM-DD'), 'XYZ123', TO_DATE('2024-11-05', 'YYYY-MM-DD'));

EXECUTE registrar_alquiler('12345678A', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'STU505', TO_DATE('2024-12-06', 'YYYY-MM-DD'));

EXECUTE registrar_alquiler('87654321B', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'VWX606', TO_DATE('2024-12-08', 'YYYY-MM-DD'));    

EXECUTE registrar_alquiler('87654321B', TO_DATE('2024-11-03', 'YYYY-MM-DD'), 'YZA707', TO_DATE('2024-11-04', 'YYYY-MM-DD'));    -- ERROR El Alquiler ha de ser mínimo de 2 días

EXECUTE registrar_alquiler('87654321B', TO_DATE('2024-11-01', 'YYYY-MM-DD'), 'XYZ123', TO_DATE('2024-11-12', 'YYYY-MM-DD'));

EXECUTE registrar_alquiler('77889900I', TO_DATE('2024-11-11', 'YYYY-MM-DD'), 'PQR404', TO_DATE('2024-11-15', 'YYYY-MM-DD'));    -- Se ha producido un error inesperado. El dni ya ha alquilado una moto