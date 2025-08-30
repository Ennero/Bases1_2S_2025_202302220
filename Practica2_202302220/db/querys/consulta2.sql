-- ====================================================================================
-- CONSULTA 2: Notas de evaluaciones APROBADAS en un rango de fechas.
-- ====================================================================================

SELECT
  -- Datos que voy a mostrar
  r.ID_REGISTRO,
  r.FECHA,
  r.NOMBRE_COMPLETO,
  nt.NOTA_TEORICA,
  np.NOTA_PRACTICA,
  'APROBADO' AS ESTADO

-- Tabla del registro
FROM REGISTRO r

-- Se une el registro con su examen correspondiente (lo tipico de siempre :)
JOIN EXAMEN e ON r.ID_REGISTRO = e.REGISTRO_ID_REGISTRO

-- Consulta para la nota teorica
JOIN (
  SELECT
    -- Tengo el id del examen
    e.ID_EXAMEN,
    
    -- Y la nota teorica calculada contando las respuestas correctas multiplicado por 100 dividido entre las repuestas
    (COUNT(CASE WHEN ru.RES = p.RES THEN 1 END) * 100.0 / COUNT(p.ID_PREG)) AS NOTA_TEORICA
    
  -- Ahora esto viene de la tabla examen
  FROM EXAMEN e
    
    -- ru es la tabla res_usu en donde tenga el mismo id de examen tanto en examen como en esa tabla
    JOIN RES_USU ru ON e.ID_EXAMEN = ru.EXAMEN_ID_EXAMEN
    
    -- lo mismo pero con las preguntas
    JOIN PREG p ON ru.PREG_ID_PREG = p.ID_PREG
    
-- Agrupado por los examenes con el mismo id
  GROUP BY e.ID_EXAMEN
) nt ON e.ID_EXAMEN = nt.ID_EXAMEN

-- Consulta para la nota practica del examen
JOIN (
  SELECT
  
    -- Lo que tendrá la tabla
    e.ID_EXAMEN,
    SUM(rpu.NOTA) AS NOTA_PRACTICA
    
  -- Viene de examen
  FROM EXAMEN e
    -- rpu es la tabla res_pract_usu en donde se tenga el mismo id de examen
    JOIN RES_PRACT_USU rpu ON e.ID_EXAMEN = rpu.EXAMEN_ID_EXAMEN
    
  -- Agrupando todo lo que tenga el mismo id de examen
  GROUP BY e.ID_EXAMEN
) np ON e.ID_EXAMEN = np.ID_EXAMEN

-- Filtro
WHERE
  
  -- Muestra solo en donde la nota teorica sea >=70 e igual la práctica
  nt.NOTA_TEORICA >= 70
  AND np.NOTA_PRACTICA >= 70
  
  -- Se filtra por el rango de fechas especificado.
  AND TRUNC(r.FECHA) BETWEEN TO_DATE('01-08-2022', 'DD-MM-YYYY') AND TO_DATE('31-08-2025', 'DD-MM-YYYY')

-- Se ordenan los resultados por fecha, del más reciente al más antiguo.
ORDER BY
  r.FECHA DESC;