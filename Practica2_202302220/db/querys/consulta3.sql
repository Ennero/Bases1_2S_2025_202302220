-- CONSULTA 3: Conteo de evaluaciones por tipo de trámite y tipo de licencia en un rango de fechas.
-- Es una consulta de agrupación simple para obtener estadísticas.

SELECT
  r.TIPO_TRAMITE,
  r.TIPO_LICENCIA,
  COUNT(e.ID_EXAMEN) AS CANTIDAD_EVALUACIONES
FROM REGISTRO r
  JOIN EXAMEN e
  ON r.ID_REGISTRO = e.REGISTRO_ID_REGISTRO
WHERE
  TRUNC(FECHA) BETWEEN TO_DATE('01-08-2022', 'DD-MM-YYYY') AND TO_DATE('31-08-2025', 'DD-MM-YYYY')
GROUP BY
  r.TIPO_TRAMITE,
  r.TIPO_LICENCIA
ORDER BY
  CANTIDAD_EVALUACIONES DESC;

