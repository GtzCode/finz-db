DROP TABLE IF EXISTS PAGOS;
CREATE TABLE PAGOS (
    CONTROL   SERIAL        ,
    GASTO     VARCHAR(10)   ,
    FECHA     DATE          ,
    IMPORTE   NUMERIC       ,
    DETALLE   VARCHAR(100)  
);


ALTER TABLE PAGOS ADD CONSTRAINT PK_PAGOS              PRIMARY KEY (CONTROL);

ALTER TABLE PAGOS ADD CONSTRAINT NOTNULL_PAGOS_GASTO   CHECK (GASTO IS NOT NULL);
ALTER TABLE PAGOS ADD CONSTRAINT NOTNULL_PAGOS_FECHA   CHECK (FECHA IS NOT NULL);
ALTER TABLE PAGOS ADD CONSTRAINT NOTNULL_PAGOS_IMPORTE CHECK (IMPORTE IS NOT NULL);


ALTER TABLE PAGOS ADD CONSTRAINT EMPTY_PAGOS_GASTO   CHECK (GASTO != '');
ALTER TABLE PAGOS ADD CONSTRAINT EMPTY_PAGOS_IMPORTE CHECK (IMPORTE != 0);

CREATE INDEX INDEX_PAGOS_FK ON PAGOS (GASTO);

