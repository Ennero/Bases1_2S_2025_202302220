-----------------------------------------
-- CONSULTA 3
-- ESTUDIANTES QUE GANARON CURSOS CON CATEDRÁTICOS EN ESPECÍFICO
-----------------------------------------
SELECT DISTINCT
    e.nombre
FROM
    (
        -- SUBCONSULTA DE APROBACIONES COMPLETA
        SELECT
            -- La tablita en sí :)
            a.ESTUDIANTE_carnet, a.SECCION_id_curso, a.SECCION_anio,
            a.SECCION_ciclo, a.SECCION_id_seccion, a.nota_final, p.creditos,
            i.CARRERA_id_carrera, p.PLAN_id_plan,
            CASE -- colocar cuando la nota sea mayor o igual a la aprovatoria así como la mínima
                WHEN a.nota_final >= p.nota_aprobacion AND a.zona >= p.zona_minima -- Y también en donde la suma de créditos de los obligatorios sea igual
                AND ( -- Y tambien en donde la suma de créditos de los obligatorios sea igual
                    SELECT COALESCE(SUM(p2.creditos), 0) FROM ASIGNACION a2 -- Tabla de asignaciones
                    JOIN PENSUM p2 ON a2.SECCION_id_curso = p2.CURSO_id_curso -- en realaciono tablas
                    -- Y la tabla de inscripciones
                    JOIN INSCRIPCION i2 ON a2.ESTUDIANTE_carnet = i2.ESTUDIANTE_carnet AND p2.PLAN_CARRERA_id_carrera = i2.CARRERA_id_carrera
                    WHERE a2.ESTUDIANTE_carnet = a.ESTUDIANTE_carnet -- Y también en donde la fecha sea menor
                        -- Y también en donde la fecha sea menor
                      AND (a2.SECCION_anio < a.SECCION_anio OR (a2.SECCION_anio = a.SECCION_anio AND a2.SECCION_ciclo < a.SECCION_ciclo))
                      AND a2.nota_final >= p2.nota_aprobacion -- Y también en donde la nota sea mayor o igual a la aprovatoria
                ) >= p.creditos_prerequisito -- Y también en donde la suma de créditos de los obligatorios sea igual
                AND NOT EXISTS ( -- Y también en donde no haya algún prerrequisito
                    SELECT 1 FROM PRERREQUISITO pr -- Tabla de prerrequisitos
                    WHERE pr.PENSUM_CURSO_id_curso = a.SECCION_id_curso -- Y también en donde el curso sea el mismo
                      AND pr.PENSUM_PLAN_id_plan = p.PLAN_id_plan -- Y también en donde el plan sea el mismo
                      AND pr.PENSUM_PLAN_CARRERA_id_carrera = p.PLAN_CARRERA_id_carrera -- Y también en donde la carrera sea la misma
                      AND NOT EXISTS ( -- Y también en donde no haya algún prerrequisito aqui
                          SELECT 1 FROM ASIGNACION a3 -- Tabla de asignaciones
                          JOIN PENSUM p3 ON a3.SECCION_id_curso = p3.CURSO_id_curso -- en realaciono tablas
                          WHERE a3.ESTUDIANTE_carnet = a.ESTUDIANTE_carnet -- Y también en donde el carnet del estudiante sea el mismo
                            AND a3.SECCION_id_curso = pr.CURSO_id_curso -- Y también en donde el curso sea el mismo
                            AND a3.nota_final >= p3.nota_aprobacion -- Y también en donde la nota sea mayor o igual a la aprovatoria
                      )
                )
                THEN 1 ELSE 0 -- Y todo se guardaría como (Es aprobado)
            END AS es_aprobado
        FROM ASIGNACION a
        JOIN INSCRIPCION i ON a.ESTUDIANTE_carnet = i.ESTUDIANTE_carnet -- Ahora los típicos join
        -- Y también el join con pensum
        JOIN PENSUM p ON a.SECCION_id_curso = p.CURSO_id_curso AND i.CARRERA_id_carrera = p.PLAN_CARRERA_id_carrera
    ) ca
JOIN ESTUDIANTE e ON ca.ESTUDIANTE_carnet = e.carnet -- Join con estudiante
JOIN SECCION s ON ca.SECCION_anio = s.anio -- Join con sección
               AND ca.SECCION_id_seccion = s.id_seccion -- Y también en donde el id de sección sea el mismo
               AND ca.SECCION_ciclo = s.ciclo -- Y también en donde el ciclo sea el mismo
               AND ca.SECCION_id_curso = s.CURSO_id_curso -- Y también en donde el curso sea el mismo
WHERE -- Condiciones para saber si ganó el curso
    ca.es_aprobado = 1 -- Y también en donde es aprobado
    AND s.CATEDRATICO_id_catedratico IN ( --- Aquí van los catedráticos específicos
        SELECT DISTINCT s2.CATEDRATICO_id_catedratico
        FROM SECCION s2
        JOIN PENSUM p2 ON s2.CURSO_id_curso = p2.CURSO_id_curso
        WHERE p2.PLAN_CARRERA_id_carrera = 9 -- Sistemas
          -- AND s2.anio = 2014 -- Año
          AND s2.ciclo = 'CICLO10' -- Ciclo
    );
    
    
    