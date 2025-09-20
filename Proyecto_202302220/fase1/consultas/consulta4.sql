-----------------------------------------
-- CONSULTA 4
-- COMPAÑERO QUE LLEVARON TODOS LOS CURSOS JUNTOS
-----------------------------------------
SELECT
    -- Carnet y nombre del compañero
    e.nombre AS nombre_companero
FROM
    ASIGNACION a
JOIN
    -- Join con estudiante
    ESTUDIANTE e ON a.ESTUDIANTE_carnet = e.carnet
WHERE
    (a.SECCION_anio, a.SECCION_id_seccion, a.SECCION_ciclo, a.SECCION_id_curso) IN (
        -- Subconsulta que obtiene las secciones del estudiante objetivo
        SELECT SECCION_anio, SECCION_id_seccion, SECCION_ciclo, SECCION_id_curso
        FROM ASIGNACION
        WHERE ESTUDIANTE_carnet = 1001 -- Reemplaza este carnet
    )
    AND a.ESTUDIANTE_carnet != 1001 -- Excluimos al propio estudiante
GROUP BY
    a.ESTUDIANTE_carnet, e.nombre
HAVING
    -- Verificamos que la cantidad de cursos en común sea idéntica
    COUNT(*) = (
        SELECT COUNT(*)
        FROM ASIGNACION
        WHERE ESTUDIANTE_carnet = 1001 -- Reemplaza este carnet
    );