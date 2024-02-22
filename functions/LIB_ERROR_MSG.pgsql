DROP FUNCTION IF EXISTS LIB_ERROR_MSG;
CREATE OR REPLACE FUNCTION LIB_ERROR_MSG (
    VPSISTEMA     VARCHAR(10),
    VPPROCEDURE   VARCHAR(50),
    VPVERSION     VARCHAR(25),
    VPPROCESO     VARCHAR(25),
    VPERROR       TEXT
    
) RETURNS VARCHAR
 AS $$
DECLARE

BEGIN

    RETURN '{>dbError>:{'       || 
            '>sistema>:>'       || VPSISTEMA               || '>,' ||
            '>procedimiento>:>' || VPPROCEDURE             || '>,' ||
            '>version>:>'       || VPVERSION               || '>,' ||
            '>proceso>:>'       || VPPROCESO               || '>,' ||
            '>error>:>'         || REPLACE(VPERROR,'"','') || '>}}';

END
$$ LANGUAGE plpgsql;
