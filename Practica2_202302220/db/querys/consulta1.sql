-- CONSULTA 1: Listado de evaluaciones realizadas en un día específico.
-- Muestra datos del evaluado, notas y si fue aprobado o reprobado.
-- APROBADO = Nota teórica >= 70 Y Nota práctica >= 70.

-- Se utiliza una cláusula WITH para calcular las notas de forma modular y clara.
WITH
  -- Subconsulta para calcular la nota teórica de cada examen
  NOTAS_TEORICAS AS (
    SELECT
      e.ID_EXAMEN,
      -- La nota es el porcentaje de respuestas correctas
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
  -- Subconsulta para calcular la nota práctica de cada examen
  NOTAS_PRACTICAS AS (
    SELECT
      e.ID_EXAMEN,
      -- La nota es la suma de los punteos obtenidos en cada pregunta práctica
      SUM(rpu.NOTA) AS NOTA_PRACTICA
    FROM EXAMEN e
      JOIN RES_PRACT_USU rpu
      ON e.ID_EXAMEN = rpu.EXAMEN_ID_EXAMEN
    GROUP BY
      e.ID_EXAMEN
  )
-- Consulta principal que une los datos del registro con las notas calculadas
SELECT
  r.ID_REGISTRO,
  r.FECHA,
  r.NOMBRE_COMPLETO,
  r.GENERO,
  r.TIPO_TRAMITE,
  r.TIPO_LICENCIA,
  d.NOMBRE AS DEPARTAMENTO,
  m.NOMBRE AS MUNICIPIO,
  es.NOMBRE AS ESCUELA,
  c.NOMBRE AS CENTRO_EVALUACION,
  nt.NOTA_TEORICA,
  np.NOTA_PRACTICA,
  -- Se determina el estado (APROBADO/REPROBADO) según las notas
  CASE
    WHEN nt.NOTA_TEORICA >= 70 AND np.NOTA_PRACTICA >= 70
    THEN 'APROBADO'
    ELSE 'REPROBADO'
  END AS ESTADO
FROM REGISTRO r
  JOIN EXAMEN e
  ON r.ID_REGISTRO = e.REGISTRO_ID_REGISTRO
  JOIN MUNICIPIO m
  ON r.MUNICIPIO_ID_MUNICIPIO = m.ID_MUNICIPIO
  JOIN DEPARTAMENTO d
  ON m.DEPARTAMENTO_ID_DEPARTAMENTO = d.ID_DEPARTAMENTO
  JOIN UBICACION u
  ON r.UBICACION_ESCUELA_ID = u.ESCUELA_ID_ESCUELA
  AND r.UBICACION_CENTRO_ID = u.CENTRO_ID_CENTRO
  JOIN ESCUELA es
  ON u.ESCUELA_ID_ESCUELA = es.ID_ESCUELA
  JOIN CENTRO c
  ON u.CENTRO_ID_CENTRO = c.ID_CENTRO
  LEFT JOIN NOTAS_TEORICAS nt
  ON e.ID_EXAMEN = nt.ID_EXAMEN
  LEFT JOIN NOTAS_PRACTICAS np
  ON e.ID_EXAMEN = np.ID_EXAMEN
WHERE
  -- El TRUNC es para ignorar la hora en la fecha.
  TRUNC(r.FECHA) = TO_DATE('13-03-2023', 'DD-MM-YYYY');
