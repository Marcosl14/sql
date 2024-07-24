SELECT
	first_name,
	last_name,
	hire_date,
	CASE
		WHEN
			hire_date > now() - INTERVAL '1 year'
			THEN 'Rango A'
		WHEN
			hire_date > now() - INTERVAL '3 year'
			THEN 'Rango B'
		WHEN
			hire_date > now() - INTERVAL '6 year'
			THEN 'Rango C'
		ELSE 'Rango D'
	END AS rango_antiguedad
FROM
	employees
ORDER BY
	hire_date DESC;

