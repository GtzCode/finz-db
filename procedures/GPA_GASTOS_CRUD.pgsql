DROP PROCEDURE IF EXISTS GPA_GASTOS_CRUD;
CREATE OR REPLACE PROCEDURE GPA_GASTOS_CRUD (
    IN VPDATA JSON,
    IN VPCRUD VARCHAR
) AS $$
DECLARE

-- INFO. PORCEDURE
    INFSISTEMA   VARCHAR := 'GPA';
    INFPROCESO   VARCHAR := '00000';
    INFPROCEDURE VARCHAR := 'GPA_GASTOS_CRUD';
    INFVERSION   VARCHAR := '2024.02.24';

-- VARIABLES
    VLERROR BOOLEAN := FALSE;
    VLGASTO GASTOS%ROWTYPE;
BEGIN

    INFPROCESO := '00100';
    IF NOT LIB_CRUD_CHECK(VPCRUD) THEN
        RAISE EXCEPTION 'No es una operacion de CRUD Valida';
    END IF;

    INFPROCESO := '00200';
    SELECT CLAVE,CATEGORIA,GASTO,NECESARIO 
      INTO VLGASTO.CLAVE,VLGASTO.CATEGORIA,VLGASTO.GASTO,VLGASTO.NECESARIO
    FROM JSON_POPULATE_RECORD(NULL::GASTOS, VPDATA);

    INFPROCESO := '00300';
    IF VPCRUD != 'D' THEN
        SELECT COUNT(1) = 0 INTO VLERROR FROM CATEGORIAS WHERE CLAVE = VLGASTO.CATEGORIA;
        IF VLERROR THEN
            RAISE EXCEPTION 'La categoria no existe';
        END IF;
    END IF;

    INFPROCESO := '00400';
    IF VPCRUD != 'C' THEN
        SELECT COUNT(1) = 0 INTO VLERROR FROM GASTOS WHERE CLAVE = VLGASTO.CLAVE;
        IF VLERROR THEN
            RAISE EXCEPTION 'El gasto no existe';
        END IF;
    END IF;

    INFPROCESO := '00500';
    IF VPCRUD = 'C' THEN
        INSERT INTO GASTOS (CLAVE,CATEGORIA,GASTO)
            VALUES (VLGASTO.CLAVE,VLGASTO.CATEGORIA,VLGASTO.GASTO);
    END IF;

    INFPROCESO := '00600';
    IF VPCRUD = 'U' THEN
        UPDATE GASTOS SET (CATEGORIA,GASTO,NECESARIO)
            = (VLGASTO.CATEGORIA,VLGASTO.GASTO,VLGASTO.NECESARIO
        ) WHERE CLAVE = VLGASTO.CLAVE;
    END IF;

    INFPROCESO := '00700'; 
    IF VPCRUD = 'D' THEN

        INFPROCESO := '00710';
        SELECT COUNT(1) > 0 INTO VLERROR FROM PAGOS WHERE GASTO = VLGASTO.CLAVE;
        IF VLERROR THEN
            RAISE EXCEPTION 'No es posible eliminar la Gasto' ;
        END IF;

        INFPROCESO := '00720';
        DELETE FROM GASTOS WHERE CLAVE = VLGASTO.CLAVE;
    END IF;


EXCEPTION WHEN OTHERS THEN
    RAISE EXCEPTION '%', 
        LIB_ERROR_MSG(INFSISTEMA,INFPROCEDURE,INFVERSION,INFPROCESO, SQLERRM);

END
$$ LANGUAGE PLPGSQL;