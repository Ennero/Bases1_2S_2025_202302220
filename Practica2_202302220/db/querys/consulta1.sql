-- ====================================================================================
-- CONSULTA: Listado de evaluaciones de un día específico con sus notas y resultado.
-- ====================================================================================

-- Inicia la consulta principal para seleccionar los datos que queremos mostrar.
SELECT
  -- Datos de identificación y personales del registro de la evaluación.
  r.ID_REGISTRO,
  r.FECHA,
  r.NOMBRE_COMPLETO,
  r.GENERO,
  r.TIPO_TRAMITE,
  r.TIPO_LICENCIA,
  
  -- Nombres de ubicaciones
  d.NOMBRE AS DEPARTAMENTO,
  m.NOMBRE AS MUNICIPIO,
  
  -- Nombres de las instituciones
  es.NOMBRE AS ESCUELA,
  c.NOMBRE AS CENTRO_EVALUACION,
  
  -- Notas que calcularemos
  nt.NOTA_TEORICA,
  np.NOTA_PRACTICA,

  -- Compara si ambas notas son mayores o iguales a 70.
  CASE
    WHEN nt.NOTA_TEORICA >= 70 AND np.NOTA_PRACTICA >= 70
    THEN 'APROBADO' -- Si se cumple APROBADO.
    ELSE 'REPROBADO' -- Si no REPROBADO.
  END AS ESTADO

-- Tabla registro
FROM REGISTRO r

-- Unimos con la tabla EXAMEN para vincular el registro con su examen correspondiente.
JOIN EXAMEN e ON r.ID_REGISTRO = e.REGISTRO_ID_REGISTRO

-- Uniones con Municipio y Departamento a partir de los IDs guardados en REGISTRO.
JOIN MUNICIPIO m ON r.MUNICIPIO_ID_MUNICIPIO = m.ID_MUNICIPIO
JOIN DEPARTAMENTO d ON m.DEPARTAMENTO_ID_DEPARTAMENTO = d.ID_DEPARTAMENTO

-- Más uniones :)
-- Se usa la tabla intermedia UBICACION que relaciona Registro, Escuela y Centro.
JOIN UBICACION u ON r.UBICACION_ESCUELA_ID = u.ESCUELA_ID_ESCUELA AND r.UBICACION_CENTRO_ID = u.CENTRO_ID_CENTRO
JOIN ESCUELA es ON u.ESCUELA_ID_ESCUELA = es.ID_ESCUELA
JOIN CENTRO c ON u.CENTRO_ID_CENTRO = c.ID_CENTRO

-- Usamos LEFT JOIN por si un examen no tuviera respuestas teóricas, para que no desaparezca del resultado.
LEFT JOIN (

  -- Esta subconsulta calcula el porcentaje de respuestas correctas para cada examen.
  SELECT
    e.ID_EXAMEN,
    
    -- Cuenta las respuestas correctas y lo multiplica por 100.0 para obtener un porcentaje, y lo divide por el total de preguntas.
    (COUNT(CASE WHEN ru.RES = p.RES THEN 1 END) * 100.0 / COUNT(p.ID_PREG)) AS NOTA_TEORICA
    
  -- Tabla de examen y mostrando las cosas esas de las keys
  FROM EXAMEN e
    JOIN RES_USU ru ON e.ID_EXAMEN = ru.EXAMEN_ID_EXAMEN
    JOIN PREG p ON ru.PREG_ID_PREG = p.ID_PREG
    
  -- Agrupa los resultados por examen para que el cálculo se haga para cada uno individualmente
  GROUP BY e.ID_EXAMEN
) nt ON e.ID_EXAMEN = nt.ID_EXAMEN


-- Uso LEFT JOIN por si un examen no tuviera parte práctica.
LEFT JOIN (

  -- Suma todos los puntos obtenidos en la parte práctica de cada examen.
  SELECT
    e.ID_EXAMEN,
    SUM(rpu.NOTA) AS NOTA_PRACTICA
  FROM EXAMEN e
    JOIN RES_PRACT_USU rpu ON e.ID_EXAMEN = rpu.EXAMEN_ID_EXAMEN
    
  -- Agrupa por examen para sumar las notas de cada uno
  GROUP BY e.ID_EXAMEN
) np ON e.ID_EXAMEN = np.ID_EXAMEN

-- Finalmente, se filtra por fecha específica.
WHERE
  -- TRUNC(r.FECHA) elimina la parte de la hora de la fecha
  TRUNC(r.FECHA) = TO_DATE('13-03-2023', 'DD-MM-YYYY');
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  