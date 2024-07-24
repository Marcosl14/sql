SELECT
    -- Obtener la fecha actual
    CURRENT_DATE AS fecha_actual,

    -- Obtener la fecha y hora actual
    NOW() AS fecha_hora_actual,

    -- Agregar 10 días a la fecha actual
    CURRENT_DATE + INTERVAL '10 days' AS fecha_mas_10_dias,

    -- Restar 5 días a la fecha actual
    CURRENT_DATE - INTERVAL '5 days' AS fecha_menos_5_dias,

    -- Calcular la diferencia entre la fecha actual y una fecha específica
    AGE(CURRENT_DATE, '2023-01-01') AS diferencia_fecha,

    -- Extraer el año de la fecha actual
    EXTRACT(YEAR FROM CURRENT_DATE) AS anio_actual,

    -- Extraer el mes de la fecha actual
    EXTRACT(MONTH FROM CURRENT_DATE) AS mes_actual,

    -- Extraer el día de la fecha actual
    EXTRACT(DAY FROM CURRENT_DATE) AS dia_actual,

    -- Formatear la fecha actual en formato 'DD/MM/YYYY'
    TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY') AS fecha_formateada,

    -- Convertir una cadena a una fecha
    TO_DATE('2023-10-01', 'YYYY-MM-DD') AS fecha_convertida,

    -- Obtener el primer día del mes actual
    DATE_TRUNC('month', CURRENT_DATE) AS primer_dia_mes,

    -- Obtener el último día del mes actual
    (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day') AS ultimo_dia_mes,

    -- date_part
    date_part('years', now()) as anio_actual_2
;

SELECT * FROM employees
WHERE hire_date > DATE('1998-02-05')
ORDER BY hire_date ASC;

SELECT max(hire_date) as nuevo
FROM employees;

SELECT *
FROM employees
WHERE hire_date BETWEEN '1999-01-01' AND '2000-01-01';

-- INTERVALOS
SELECT
	max(hire_date) as nuevo,
 	max(hire_date) + INTERVAL '1 days',
 	max(hire_date) + INTERVAL '1 months',
 	max(hire_date) + INTERVAL '1 years',
 	max(hire_date) + INTERVAL '1.1 years', -- un año y un mes
 	max(hire_date) + INTERVAL '1 years' + INTERVAL '1 months' + INTERVAL '1 day', -- un año y un mes
 	max(hire_date) + make_interval(YEARS := 23), -- aqui nos permite usar una variable (23) como se ve en el ejemplo siguiente
 	max(hire_date) + make_interval(YEARS := date_part('years', now())::INTEGER )
FROM employees;
