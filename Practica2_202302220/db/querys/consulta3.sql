-- ====================================================================================
-- CONSULTA 3: Conteo de evaluaciones por tipo de trámite y tipo de licencia en un rango de fechas.
-- ====================================================================================

SELECT

  -- Se selecciona el tipo de tramite y el tipo de licencia
  r.TIPO_TRAMITE,
  r.TIPO_LICENCIA,
  
  -- Cuento la cantidad de examenes 
  COUNT(e.ID_EXAMEN) AS CANTIDAD_EVALUACIONES
FROM REGISTRO r
  JOIN EXAMEN e
  ON r.ID_REGISTRO = e.REGISTRO_ID_REGISTRO
WHERE

  -- Trunc para que no esté la hora y entre las dos fechas que ahí dice :)
  TRUNC(FECHA) BETWEEN TO_DATE('01-08-2022', 'DD-MM-YYYY') AND TO_DATE('31-08-2025', 'DD-MM-YYYY')
  
  -- Todo agrupado por tipo de licencia y tramite
GROUP BY
  r.TIPO_TRAMITE,
  r.TIPO_LICENCIA
ORDER BY
  CANTIDAD_EVALUACIONES DESC;

