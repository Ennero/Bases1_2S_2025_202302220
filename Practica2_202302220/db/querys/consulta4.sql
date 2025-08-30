-- ====================================================================================
-- CONSULTA 4: Preguntas con más aciertos en rango de fechas.
-- ====================================================================================

SELECT

  -- Los datos que voy a mostrar
  ID_PREG,
  PREG_TEXTO,
  NUMERO_ACIERTOS
  
FROM (

  -- cuenta los aciertos y asigna un ranking a cada pregunta.
  SELECT
  
    -- Los datitos de la tabla
    p.ID_PREG,
    p.PREG_TEXTO,
    COUNT(*) AS NUMERO_ACIERTOS,
    
    -- Ranking basado en el número de aciertos (de mayor a menor)
    RANK() OVER (ORDER BY COUNT(*) DESC) AS RANK_ACIERTOS
    
  -- Obtendria las cosas de la tabla registros|
  FROM REGISTRO r
  
    -- Y de estas cositas en donde se tenga la clave foránea y esas cosas
    JOIN EXAMEN e ON r.ID_REGISTRO = e.REGISTRO_ID_REGISTRO
    JOIN RES_USU ru ON e.ID_EXAMEN = ru.EXAMEN_ID_EXAMEN
    JOIN PREG p ON ru.PREG_ID_PREG = p.ID_PREG
    
  WHERE
    -- Se cuentan solo las respuestas correctas
    ru.RES = p.RES
    
    -- Se filtra por el rango de fechas
    AND TRUNC(r.FECHA) BETWEEN TO_DATE('01-08-2022', 'DD-MM-YYYY') AND TO_DATE('31-08-2025', 'DD-MM-YYYY')
    
  -- Se agrupa por pregunta para que el conteo de aciertos sea por cada una (las dos por si acaso)
  GROUP BY
    p.ID_PREG,
    p.PREG_TEXTO
) CONTEO_ACIERTOS -- Es obligatorio darle un nombre (alias) a la subconsulta.

-- Se filtra el resultado de la subconsulta para mostrar solo las preguntas
WHERE
  RANK_ACIERTOS = 1;