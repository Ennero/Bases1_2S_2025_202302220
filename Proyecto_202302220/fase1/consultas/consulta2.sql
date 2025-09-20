-----------------------------------------
-- CONSULTA 2
-- ESTUDIANTES QUE HAN CERRADO CUALQUIER CARRERA
-----------------------------------------
SELECT -- Selecciona los datos necesarios 
    e.nombre AS nombre_estudiante,
    c.nombre AS nombre_carrera,
    rpc.promedio_aprobadas,
    rpc.creditos_ganados
FROM
    (
        -- Subconsulta que resume datos por estudiante y carrera
        SELECT -- La tablita en sí :)
            ca.ESTUDIANTE_carnet,
            ca.CARRERA_id_carrera,
            SUM(ca.creditos) AS creditos_ganados, -- Suma de créditos ganados
            AVG(ca.nota_final) AS promedio_aprobadas, -- Promedio de notas en cursos aprobados

            -- Conteo de cursos obligatorios aprobados
            COUNT(DISTINCT CASE WHEN p.obligatorio = 1 THEN ca.SECCION_id_curso END) AS obligatorios_aprobados
        FROM
            (
                -- SUBCONSULTA DE APROBACIONES COMPLETA
                SELECT
                    a.ESTUDIANTE_carnet, a.SECCION_id_curso, a.SECCION_anio,
                    a.SECCION_ciclo, a.SECCION_id_seccion, a.nota_final, p.creditos,
                    i.CARRERA_id_carrera, p.PLAN_id_plan,
                    CASE -- colocar cuando la nota sea mayor o igual a la aprovatoria así como la mínima
                        -- Y también en donde la suma de créditos de los obligatorios sea igual
                        WHEN a.nota_final >= p.nota_aprobacion AND a.zona >= p.zona_minima

                        AND ( -- Y tambien en donde la suma de créditos de los obligatorios sea igual
                            SELECT COALESCE(SUM(p2.creditos), 0) FROM ASIGNACION a2
                            JOIN PENSUM p2 ON a2.SECCION_id_curso = p2.CURSO_id_curso
                            JOIN INSCRIPCION i2 ON a2.ESTUDIANTE_carnet = i2.ESTUDIANTE_carnet AND p2.PLAN_CARRERA_id_carrera = i2.CARRERA_id_carrera
                            WHERE a2.ESTUDIANTE_carnet = a.ESTUDIANTE_carnet
                              AND (a2.SECCION_anio < a.SECCION_anio OR (a2.SECCION_anio = a.SECCION_anio AND a2.SECCION_ciclo < a.SECCION_ciclo))
                              AND a2.nota_final >= p2.nota_aprobacion
                        ) >= p.creditos_prerequisito
                        
                        -- Y también en donde no haya algún prerrequisito
                        AND NOT EXISTS (
                            SELECT 1 FROM PRERREQUISITO pr
                            WHERE pr.PENSUM_CURSO_id_curso = a.SECCION_id_curso
                              AND pr.PENSUM_PLAN_id_plan = p.PLAN_id_plan -- Y también en donde el plan sea el mismo
                              AND pr.PENSUM_PLAN_CARRERA_id_carrera = p.PLAN_CARRERA_id_carrera -- Y también en donde la carrera sea la misma
                              AND NOT EXISTS ( -- Y también en donde no haya algún prerrequisito aqui
                                  SELECT 1 FROM ASIGNACION a3
                                  JOIN PENSUM p3 ON a3.SECCION_id_curso = p3.CURSO_id_curso -- en realaciono tablas
                                  WHERE a3.ESTUDIANTE_carnet = a.ESTUDIANTE_carnet
                                    AND a3.SECCION_id_curso = pr.CURSO_id_curso -- Y también en donde el curso sea el mismo
                                    AND a3.nota_final >= p3.nota_aprobacion -- Y también en donde la nota sea mayor o igual a la aprovatoria
                              )
                        )
                        THEN 1 ELSE 0
                    END AS es_aprobado -- Y todo se guardaría como (Es aprobado)
                FROM ASIGNACION a
                JOIN INSCRIPCION i ON a.ESTUDIANTE_carnet = i.ESTUDIANTE_carnet -- Ahora los típicos join
                
                -- Y también el join con pensum
                JOIN PENSUM p ON a.SECCION_id_curso = p.CURSO_id_curso AND i.CARRERA_id_carrera = p.PLAN_CARRERA_id_carrera
            ) ca 
        JOIN PENSUM p ON ca.SECCION_id_curso = p.CURSO_id_curso AND p.PLAN_CARRERA_id_carrera = ca.CARRERA_id_carrera
        WHERE ca.es_aprobado = 1 -- Y también en donde es aprobado
        GROUP BY ca.ESTUDIANTE_carnet, ca.CARRERA_id_carrera -- Agrupando por carnet y carrera
    ) rpc
JOIN ESTUDIANTE e ON rpc.ESTUDIANTE_carnet = e.carnet -- Join con estudiante
JOIN CARRERA c ON rpc.CARRERA_id_carrera = c.id_carrera -- Join con carrera
JOIN PLAN pl ON rpc.CARRERA_id_carrera = pl.CARRERA_id_carrera -- Join con plan

-- Join con la subconsulta que cuenta los obligatorios por carrera
JOIN (SELECT PLAN_CARRERA_id_carrera, COUNT(*) AS total FROM PENSUM WHERE obligatorio = 1 GROUP BY PLAN_CARRERA_id_carrera) tob
    ON rpc.CARRERA_id_carrera = tob.PLAN_CARRERA_id_carrera
WHERE -- Condiciones para saber si ha cerrado la carrera
    rpc.creditos_ganados >= pl.creditos_cierre
    AND rpc.obligatorios_aprobados = tob.total;

