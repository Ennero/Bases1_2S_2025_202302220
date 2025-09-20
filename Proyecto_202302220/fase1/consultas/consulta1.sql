-----------------------------------------
-- CONSULTA 1
-- ESTUDIANTES QUE HAN CERRADO SISTEMAS
-----------------------------------------
SELECT
    -- Tabla principal
    e.nombre,
    res.promedio_aprobadas,
    res.creditos_ganados
FROM -- Lo necesario para obtener la tablita res
    (
        -- Subconsulta que resume los datos del estudiante
        SELECT
            ca.ESTUDIANTE_carnet,
            SUM(ca.creditos) AS creditos_ganados,
            AVG(ca.nota_final) AS promedio_aprobadas,
            COUNT(DISTINCT CASE WHEN p.obligatorio = 1 THEN ca.SECCION_id_curso END) AS obligatorios_aprobados
        FROM -- Lo necesario para obtener la tablitita ca
            (
                -- SUBCONSULTA DE APROBACIONES
                SELECT
                    a.ESTUDIANTE_carnet, a.SECCION_id_curso, a.SECCION_anio,
                    a.SECCION_ciclo, a.SECCION_id_seccion, a.nota_final, p.creditos,
                    i.CARRERA_id_carrera,
                    p.PLAN_id_plan, -- Se necesita para la subconsulta de prerrequisitos
                    CASE
                        -- Selecciona solo los casos en los que la nota de aprobación y la zona cumplen
                        WHEN a.nota_final >= p.nota_aprobacion AND a.zona >= p.zona_minima
                        AND ( -- Y también en donde la suma de créditos de los obligatorios sea igual 
                            -- Y tambien en donde 
                            SELECT COALESCE(SUM(p2.creditos), 0) FROM ASIGNACION a2 -- Tabla de asignaciones
                            JOIN PENSUM p2 ON a2.SECCION_id_curso = p2.CURSO_id_curso -- en realaciono tablas

                            -- Y la tabla de inscripciones
                            JOIN INSCRIPCION i2 ON a2.ESTUDIANTE_carnet = i2.ESTUDIANTE_carnet AND p2.PLAN_CARRERA_id_carrera = i2.CARRERA_id_carrera
                            -- En donde el carnet del estudiante sea el mismo que el de la suma de todos su créditos.
                            WHERE a2.ESTUDIANTE_carnet = a.ESTUDIANTE_carnet -- Y también en donde la fecha sea menor
                              AND (a2.SECCION_anio < a.SECCION_anio OR (a2.SECCION_anio = a.SECCION_anio AND a2.SECCION_ciclo < a.SECCION_ciclo))
                              AND a2.nota_final >= p2.nota_aprobacion
                        ) >= p.creditos_prerequisito
                        AND NOT EXISTS ( -- Y también en donde no haya algún prerrequisito
                            SELECT 1 FROM PRERREQUISITO pr
                            WHERE pr.PENSUM_CURSO_id_curso = a.SECCION_id_curso -- Y también en donde el curso sea el mismo
                              AND pr.PENSUM_PLAN_id_plan = p.PLAN_id_plan -- Y también en donde el plan sea el mismo
                              AND pr.PENSUM_PLAN_CARRERA_id_carrera = p.PLAN_CARRERA_id_carrera -- Y también en donde la carrera sea la misma
                              AND NOT EXISTS (
                                  SELECT 1 FROM ASIGNACION a3 -- Tabla de asignaciones
                                  JOIN PENSUM p3 ON a3.SECCION_id_curso = p3.CURSO_id_curso -- en realaciono tablas
                                  WHERE a3.ESTUDIANTE_carnet = a.ESTUDIANTE_carnet -- Y también en donde el carnet del estudiante sea el mismo
                                    AND a3.SECCION_id_curso = pr.CURSO_id_curso -- Y también en donde el curso sea el mismo
                                    AND a3.nota_final >= p3.nota_aprobacion -- Y también en donde la nota sea mayor o igual a la aprovatoria
                              )
                        )
                        THEN 1 ELSE 0
                    END AS es_aprobado
                FROM ASIGNACION a -- Tabla de asignaciones
                JOIN INSCRIPCION i ON a.ESTUDIANTE_carnet = i.ESTUDIANTE_carnet -- Ahora los típicos join
                -- Y también el join con pensum
                JOIN PENSUM p ON a.SECCION_id_curso = p.CURSO_id_curso AND i.CARRERA_id_carrera = p.PLAN_CARRERA_id_carrera
            ) ca
        -- El JOIN y el GROUP BY se aplican sobre 'ca'
        JOIN PENSUM p ON ca.SECCION_id_curso = p.CURSO_id_curso AND p.PLAN_CARRERA_id_carrera = 9
        WHERE ca.es_aprobado = 1 AND ca.CARRERA_id_carrera = 9
        GROUP BY ca.ESTUDIANTE_carnet -- Agrupando por carnet
    ) res
JOIN ESTUDIANTE e ON res.ESTUDIANTE_carnet = e.carnet -- El estudiante con el carnet de la tabla previamente creada
JOIN PLAN pl ON pl.CARRERA_id_carrera = 9 -- Carrera con el ID = 9 (Sistemas)
WHERE
    res.creditos_ganados >= pl.creditos_cierre -- En donde se tengan los créditos para el cierre y se tengan los cursos obligatorios aprobados
    AND res.obligatorios_aprobados = (SELECT COUNT(*) FROM PENSUM WHERE PLAN_CARRERA_id_carrera = 9 AND obligatorio = 1);