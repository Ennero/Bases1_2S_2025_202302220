-- CONSULTA 2: Notas de evaluaciones APROBADAS en un rango de fechas.
-- Muestra los datos generales y las notas de quienes aprobaron.
-- APROBADO = Nota teórica >= 70 Y Nota práctica >= 70.

-- Se utiliza la misma lógica de la Consulta 1 para calcular notas.
WITH
  NOTAS_TEORICAS AS (
    SELECT
      e.ID_EXAMEN,
      (
        COUNT(
          CASE
            WHEN ru.RES = p.RES
            THEN 1
          END
        ) * 100.0 / COUNT(p.ID_PREG)
      ) AS NOTA_TEORICA
    FROM EXAMEN e
      JOIN RES_USU ru
      ON e.ID_EXAMEN = ru.EXAMEN_ID_EXAMEN
      JOIN PREG p
      ON ru.PREG_ID_PREG = p.ID_PREG
    GROUP BY
      e.ID_EXAMEN
  ),
  NOTAS_PRACTICAS AS (
    SELECT
      e.ID_EXAMEN,
      SUM(rpu.NOTA) AS NOTA_PRACTICA
    FROM EXAMEN e
      JOIN RES_PRACT_USU rpu
      ON e.ID_EXAMEN = rpu.EXAMEN_ID_EXAMEN
    GROUP BY
      e.ID_EXAMEN
  )
-- Consulta principal
SELECT
  r.ID_REGISTRO,
  r.FECHA,
  r.NOMBRE_COMPLETO,
  nt.NOTA_TEORICA,
  np.NOTA_PRACTICA,
  'APROBADO' AS ESTADO
FROM REGISTRO r
  JOIN EXAMEN e
  ON r.ID_REGISTRO = e.REGISTRO_ID_REGISTRO
  JOIN NOTAS_TEORICAS nt
  ON e.ID_EXAMEN = nt.ID_EXAMEN
  JOIN NOTAS_PRACTICAS np
  ON e.ID_EXAMEN = np.ID_EXAMEN
WHERE
  -- Condición para filtrar solo los aprobados
  nt.NOTA_TEORICA >= 70
  AND np.NOTA_PRACTICA >= 70
  -- IMPORTANTE: Reemplaza las fechas para definir tu rango de consulta.
  AND TRUNC(r.FECHA) BETWEEN TO_DATE('01-08-2022', 'DD-MM-YYYY') AND TO_DATE('31-08-2025', 'DD-MM-YYYY')
ORDER BY
  r.FECHA DESC;
