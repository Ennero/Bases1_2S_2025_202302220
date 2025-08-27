-- CREACIÓN DE TODAS LAS TABLAS

CREATE TABLE Centro_Evaluacion (
    centro_id INTEGER NOT NULL,
    nombre VARCHAR2(200) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    CONSTRAINT centro_evaluacion_pk PRIMARY KEY (centro_id)
);

CREATE TABLE Escuela_Automovilismo (
    escuela_id INTEGER NOT NULL,
    nombre VARCHAR2(200) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    num_autorizacion NUMBER NOT NULL,
    CONSTRAINT escuela_automovilismo_pk PRIMARY KEY (escuela_id)
);

CREATE TABLE Persona (
    persona_id INTEGER NOT NULL,
    nombre_completo VARCHAR2(200) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    identificacion VARCHAR2(200) NOT NULL,
    telefono VARCHAR2(200) NOT NULL,
    fotografia BLOB,
    tipo_licencia VARCHAR2(200) NOT NULL,
    tipo_tramite VARCHAR2(200) NOT NULL,
    departamento VARCHAR2(200) NOT NULL,
    municipio VARCHAR2(200) NOT NULL,
    genero VARCHAR2(200) NOT NULL,
    fecha_nacimiento DATE,
    escuela_id INTEGER NOT NULL,
    CONSTRAINT persona_pk PRIMARY KEY (persona_id)
);


        CREATE TABLE Datos_personales (
            nombre VARCHAR2 (200) NOT NULL,
            apellido VARCHAR2 (200) NOT NULL,
            edad INTEGER NOT NULL
        );

CREATE TABLE Personal_de_Centro (
    personal_id INTEGER NOT NULL,
    identificacion VARCHAR2(200) NOT NULL,
    nombre_completo VARCHAR2(200),
    CONSTRAINT personal_centro_pk PRIMARY KEY (personal_id)
);

CREATE TABLE Examen (
    examen_id INTEGER NOT NULL,
    correlativo_diario INTEGER NOT NULL,
    fecha DATE NOT NULL,
    resultado_teorico INTEGER,
    resultado_practico INTEGER,
    fecha_registro DATE NOT NULL,
    persona_id INTEGER NOT NULL,
    personal_id INTEGER NOT NULL,
    CONSTRAINT examen_pk PRIMARY KEY (examen_id)
);

CREATE TABLE Instructor (
    instructor_id INTEGER NOT NULL,
    nombre VARCHAR2(200) NOT NULL,
    identificacion VARCHAR2(200) NOT NULL,
    centro_id INTEGER NOT NULL,
    CONSTRAINT instructor_pk PRIMARY KEY (instructor_id)
);

CREATE TABLE Evaluacion_Practica (
    evaluacion_practica_id INTEGER NOT NULL,
    puntuacion INTEGER NOT NULL,
    examen_id INTEGER NOT NULL,
    instructor_id INTEGER NOT NULL,
    CONSTRAINT evaluacion_practica_pk PRIMARY KEY (evaluacion_practica_id),
    CONSTRAINT evaluacion_practica_uk UNIQUE (examen_id)
);

CREATE TABLE Pregunta_Teorica (
    pregunta_teorica_id INTEGER NOT NULL,
    texto VARCHAR2(500) NOT NULL,
    imagen_referencia BLOB,
    CONSTRAINT pregunta_teorica_pk PRIMARY KEY (pregunta_teorica_id)
);

CREATE TABLE Respuesta_Teorica (
    respuesta_teorica_id INTEGER NOT NULL,
    texto VARCHAR2(500),
    imagen BLOB,
    es_correcta NUMBER NOT NULL,
    puntuacion INTEGER NOT NULL,
    pregunta_teorica_id INTEGER NOT NULL,
    CONSTRAINT respuesta_teorica_pk PRIMARY KEY (respuesta_teorica_id),
    CONSTRAINT resp_teorica_uk UNIQUE (pregunta_teorica_id, respuesta_teorica_id)
);

CREATE TABLE Examen_Pregunta_Respuesta (
    examen_id INTEGER NOT NULL,
    pregunta_teorica_id INTEGER NOT NULL,
    respuesta_teorica_id INTEGER NOT NULL,
    CONSTRAINT examen_preg_resp_pk PRIMARY KEY (examen_id, pregunta_teorica_id, respuesta_teorica_id)
);

CREATE TABLE Operan (
    centro_id INTEGER NOT NULL,
    escuela_id INTEGER NOT NULL,
    CONSTRAINT operan_pk PRIMARY KEY (centro_id, escuela_id)
);

-- CLAVES FORÁNEAS

ALTER TABLE Persona ADD CONSTRAINT persona_escuela_fk FOREIGN KEY (escuela_id) REFERENCES Escuela_Automovilismo (escuela_id);

ALTER TABLE Examen ADD CONSTRAINT examen_persona_fk FOREIGN KEY (persona_id) REFERENCES Persona (persona_id);
ALTER TABLE Examen ADD CONSTRAINT examen_personal_fk FOREIGN KEY (personal_id) REFERENCES Personal_de_Centro (personal_id);

ALTER TABLE Instructor ADD CONSTRAINT instructor_centro_fk FOREIGN KEY (centro_id) REFERENCES Centro_Evaluacion (centro_id);

ALTER TABLE Evaluacion_Practica ADD CONSTRAINT eval_pract_examen_fk FOREIGN KEY (examen_id) REFERENCES Examen (examen_id);
ALTER TABLE Evaluacion_Practica ADD CONSTRAINT eval_pract_instructor_fk FOREIGN KEY (instructor_id) REFERENCES Instructor (instructor_id);

ALTER TABLE Respuesta_Teorica ADD CONSTRAINT resp_teorica_preg_fk FOREIGN KEY (pregunta_teorica_id) REFERENCES Pregunta_Teorica (pregunta_teorica_id);

ALTER TABLE Examen_Pregunta_Respuesta ADD CONSTRAINT exam_preg_resp_exam_fk FOREIGN KEY (examen_id) REFERENCES Examen (examen_id);
ALTER TABLE Examen_Pregunta_Respuesta ADD CONSTRAINT exam_preg_resp_preg_fk FOREIGN KEY (pregunta_teorica_id) REFERENCES Pregunta_Teorica (pregunta_teorica_id);
ALTER TABLE Examen_Pregunta_Respuesta ADD CONSTRAINT exam_preg_resp_resp_fk FOREIGN KEY (respuesta_teorica_id) REFERENCES Respuesta_Teorica (respuesta_teorica_id);

ALTER TABLE Operan ADD CONSTRAINT operan_centro_fk FOREIGN KEY (centro_id) REFERENCES Centro_Evaluacion (centro_id);
ALTER TABLE Operan ADD CONSTRAINT operan_escuela_fk FOREIGN KEY (escuela_id) REFERENCES Escuela_Automovilismo (escuela_id);



