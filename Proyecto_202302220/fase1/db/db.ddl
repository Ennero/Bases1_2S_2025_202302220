-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2025-09-17 16:57:52 CST
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE ASIGNACION 
    ( 
     zona               INTEGER , 
     nota_final         INTEGER , 
     ESTUDIANTE_carnet  INTEGER  NOT NULL , 
     SECCION_anio       INTEGER  NOT NULL , 
     SECCION_id_seccion CHAR (1)  NOT NULL , 
     SECCION_ciclo      VARCHAR2 (100)  NOT NULL , 
     SECCION_id_curso   INTEGER  NOT NULL 
    ) 
;

ALTER TABLE ASIGNACION 
    ADD CONSTRAINT ASIGNACION_PK PRIMARY KEY ( ESTUDIANTE_carnet, SECCION_anio, SECCION_id_seccion, SECCION_ciclo, SECCION_id_curso ) ;

CREATE TABLE CARRERA 
    ( 
     id_carrera INTEGER  NOT NULL , 
     nombre     VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE CARRERA 
    ADD CONSTRAINT CARRERA_PK PRIMARY KEY ( id_carrera ) ;

CREATE TABLE CATEDRATICO 
    ( 
     id_catedratico INTEGER  NOT NULL , 
     nombre         VARCHAR2 (100)  NOT NULL , 
     sueldo_mensual NUMBER 
    ) 
;

ALTER TABLE CATEDRATICO 
    ADD CONSTRAINT CATEDRATICO_PK PRIMARY KEY ( id_catedratico ) ;

CREATE TABLE CURSO 
    ( 
     nombre   VARCHAR2 (100)  NOT NULL , 
     id_curso INTEGER  NOT NULL 
    ) 
;

ALTER TABLE CURSO 
    ADD CONSTRAINT CURSO_PK PRIMARY KEY ( id_curso ) ;

CREATE TABLE DIA 
    ( 
     id_dia INTEGER  NOT NULL , 
     nombre VARCHAR2 (1000)  NOT NULL 
    ) 
;

ALTER TABLE DIA 
    ADD CONSTRAINT DIA_PK PRIMARY KEY ( id_dia ) ;

CREATE TABLE ESTUDIANTE 
    ( 
     carnet           INTEGER  NOT NULL , 
     nombre           VARCHAR2 (100)  NOT NULL , 
     fecha_nacimiento DATE  NOT NULL , 
     ingreso_familiar NUMBER 
    ) 
;

ALTER TABLE ESTUDIANTE 
    ADD CONSTRAINT ESTUDIANTE_PK PRIMARY KEY ( carnet ) ;

CREATE TABLE HORARIO 
    ( 
     DIA_id_dia             INTEGER  NOT NULL , 
     PERIODO_id_periodo     INTEGER  NOT NULL , 
     SALON_id_edificio      VARCHAR2 (100)  NOT NULL , 
     SALON_id_salon         INTEGER  NOT NULL , 
     SECCION_anio           INTEGER  NOT NULL , 
     SECCION_id_seccion     CHAR (1)  NOT NULL , 
     SECCION_ciclo          VARCHAR2 (100)  NOT NULL , 
     SECCION_CURSO_id_curso INTEGER  NOT NULL 
    ) 
;

ALTER TABLE HORARIO 
    ADD CONSTRAINT HORARIO_PK PRIMARY KEY ( DIA_id_dia, PERIODO_id_periodo, SALON_id_edificio, SALON_id_salon, SECCION_anio, SECCION_id_seccion, SECCION_ciclo, SECCION_CURSO_id_curso ) ;

CREATE TABLE INSCRIPCION 
    ( 
     ESTUDIANTE_carnet  INTEGER  NOT NULL , 
     CARRERA_id_carrera INTEGER  NOT NULL , 
     fecha_inscripcion  DATE  NOT NULL 
    ) 
;

ALTER TABLE INSCRIPCION 
    ADD CONSTRAINT INSCRIPCION_PK PRIMARY KEY ( ESTUDIANTE_carnet, CARRERA_id_carrera ) ;

CREATE TABLE PENSUM 
    ( 
     obligatorio             NUMBER  NOT NULL , 
     creditos                INTEGER  NOT NULL , 
     nota_aprobacion         INTEGER  NOT NULL , 
     zona_minima             INTEGER  NOT NULL , 
     creditos_prerequisito   INTEGER  NOT NULL , 
     PLAN_id_plan            VARCHAR2 (100)  NOT NULL , 
     CURSO_id_curso          INTEGER  NOT NULL , 
     PLAN_CARRERA_id_carrera INTEGER  NOT NULL 
    ) 
;

ALTER TABLE PENSUM 
    ADD CONSTRAINT PENSUM_PK PRIMARY KEY ( PLAN_id_plan, PLAN_CARRERA_id_carrera, CURSO_id_curso ) ;

CREATE TABLE PERIODO 
    ( 
     id_periodo  INTEGER  NOT NULL , 
     hora_inicio VARCHAR2 (100)  NOT NULL , 
     hora_fin    VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE PERIODO 
    ADD CONSTRAINT PERIODO_PK PRIMARY KEY ( id_periodo ) ;

CREATE TABLE PLAN 
    ( 
     id_plan            VARCHAR2 (100)  NOT NULL , 
     nombre             VARCHAR2 (100)  NOT NULL , 
     anio_inicial       INTEGER  NOT NULL , 
     ciclo_inicial      VARCHAR2 (100)  NOT NULL , 
     anio_final         INTEGER  NOT NULL , 
     ciclo_final        VARCHAR2 (100)  NOT NULL , 
     creditos_cierre    INTEGER  NOT NULL , 
     CARRERA_id_carrera INTEGER  NOT NULL 
    ) 
;

ALTER TABLE PLAN 
    ADD CONSTRAINT PLAN_PK PRIMARY KEY ( id_plan, CARRERA_id_carrera ) ;

CREATE TABLE PRERREQUISITO 
    ( 
     CURSO_id_curso                 INTEGER  NOT NULL , 
     PENSUM_PLAN_id_plan            VARCHAR2 (100)  NOT NULL , 
     PENSUM_CURSO_id_curso          INTEGER  NOT NULL , 
     PENSUM_PLAN_CARRERA_id_carrera INTEGER  NOT NULL 
    ) 
;

ALTER TABLE PRERREQUISITO 
    ADD CONSTRAINT PRERREQUISITO_PK PRIMARY KEY ( CURSO_id_curso, PENSUM_PLAN_id_plan, PENSUM_CURSO_id_curso, PENSUM_PLAN_CARRERA_id_carrera ) ;

CREATE TABLE SALON 
    ( 
     id_edificio VARCHAR2 (100)  NOT NULL , 
     id_salon    INTEGER  NOT NULL , 
     capacidad   INTEGER  NOT NULL 
    ) 
;

ALTER TABLE SALON 
    ADD CONSTRAINT SALON_PK PRIMARY KEY ( id_edificio, id_salon ) ;

CREATE TABLE SECCION 
    ( 
     id_seccion                 CHAR (1)  NOT NULL , 
     anio                       INTEGER  NOT NULL , 
     ciclo                      VARCHAR2 (100)  NOT NULL , 
     CURSO_id_curso             INTEGER  NOT NULL , 
     CATEDRATICO_id_catedratico INTEGER  NOT NULL 
    ) 
;

ALTER TABLE SECCION 
    ADD CONSTRAINT SECCION_PK PRIMARY KEY ( anio, id_seccion, ciclo, CURSO_id_curso ) ;

ALTER TABLE ASIGNACION 
    ADD CONSTRAINT ASIGNACION_ESTUDIANTE_FK FOREIGN KEY 
    ( 
     ESTUDIANTE_carnet
    ) 
    REFERENCES ESTUDIANTE 
    ( 
     carnet
    ) 
;

ALTER TABLE ASIGNACION 
    ADD CONSTRAINT ASIGNACION_SECCION_FK FOREIGN KEY 
    ( 
     SECCION_anio,
     SECCION_id_seccion,
     SECCION_ciclo,
     SECCION_id_curso
    ) 
    REFERENCES SECCION 
    ( 
     anio,
     id_seccion,
     ciclo,
     CURSO_id_curso
    ) 
;

ALTER TABLE HORARIO 
    ADD CONSTRAINT HORARIO_DIA_FK FOREIGN KEY 
    ( 
     DIA_id_dia
    ) 
    REFERENCES DIA 
    ( 
     id_dia
    ) 
;

ALTER TABLE HORARIO 
    ADD CONSTRAINT HORARIO_PERIODO_FK FOREIGN KEY 
    ( 
     PERIODO_id_periodo
    ) 
    REFERENCES PERIODO 
    ( 
     id_periodo
    ) 
;

ALTER TABLE HORARIO 
    ADD CONSTRAINT HORARIO_SALON_FK FOREIGN KEY 
    ( 
     SALON_id_edificio,
     SALON_id_salon
    ) 
    REFERENCES SALON 
    ( 
     id_edificio,
     id_salon
    ) 
;

ALTER TABLE HORARIO 
    ADD CONSTRAINT HORARIO_SECCION_FK FOREIGN KEY 
    ( 
     SECCION_anio,
     SECCION_id_seccion,
     SECCION_ciclo,
     SECCION_CURSO_id_curso
    ) 
    REFERENCES SECCION 
    ( 
     anio,
     id_seccion,
     ciclo,
     CURSO_id_curso
    ) 
;

ALTER TABLE INSCRIPCION 
    ADD CONSTRAINT INSCRIPCION_CARRERA_FK FOREIGN KEY 
    ( 
     CARRERA_id_carrera
    ) 
    REFERENCES CARRERA 
    ( 
     id_carrera
    ) 
;

ALTER TABLE INSCRIPCION 
    ADD CONSTRAINT INSCRIPCION_ESTUDIANTE_FK FOREIGN KEY 
    ( 
     ESTUDIANTE_carnet
    ) 
    REFERENCES ESTUDIANTE 
    ( 
     carnet
    ) 
;

ALTER TABLE PENSUM 
    ADD CONSTRAINT PENSUM_CURSO_FK FOREIGN KEY 
    ( 
     CURSO_id_curso
    ) 
    REFERENCES CURSO 
    ( 
     id_curso
    ) 
;

ALTER TABLE PENSUM 
    ADD CONSTRAINT PENSUM_PLAN_FK FOREIGN KEY 
    ( 
     PLAN_id_plan,
     PLAN_CARRERA_id_carrera
    ) 
    REFERENCES PLAN 
    ( 
     id_plan,
     CARRERA_id_carrera
    ) 
;

ALTER TABLE PLAN 
    ADD CONSTRAINT PLAN_CARRERA_FK FOREIGN KEY 
    ( 
     CARRERA_id_carrera
    ) 
    REFERENCES CARRERA 
    ( 
     id_carrera
    ) 
;

ALTER TABLE PRERREQUISITO 
    ADD CONSTRAINT PRERREQUISITO_CURSO_FK FOREIGN KEY 
    ( 
     CURSO_id_curso
    ) 
    REFERENCES CURSO 
    ( 
     id_curso
    ) 
;

ALTER TABLE PRERREQUISITO 
    ADD CONSTRAINT PRERREQUISITO_PENSUM_FK FOREIGN KEY 
    ( 
     PENSUM_PLAN_id_plan,
     PENSUM_PLAN_CARRERA_id_carrera,
     PENSUM_CURSO_id_curso
    ) 
    REFERENCES PENSUM 
    ( 
     PLAN_id_plan,
     PLAN_CARRERA_id_carrera,
     CURSO_id_curso
    ) 
;

ALTER TABLE SECCION 
    ADD CONSTRAINT SECCION_CATEDRATICO_FK FOREIGN KEY 
    ( 
     CATEDRATICO_id_catedratico
    ) 
    REFERENCES CATEDRATICO 
    ( 
     id_catedratico
    ) 
;

ALTER TABLE SECCION 
    ADD CONSTRAINT SECCION_CURSO_FK FOREIGN KEY 
    ( 
     CURSO_id_curso
    ) 
    REFERENCES CURSO 
    ( 
     id_curso
    ) 
;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             0
-- ALTER TABLE                             29
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
