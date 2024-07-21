-- Sintaxis Implícita (Estilo Antiguo)

SELECT
    a.name AS country,
    b.name AS continent
FROM
	country AS a,
	continent AS b
WHERE
	a.continent = b.code
ORDER BY 
	b.name

-- Sintaxis Explícita (JOIN)

SELECT
    a.name AS country,
    b.name AS continent
FROM
    country AS a
INNER JOIN
    continent AS b
ON
    a.continent = b.code
ORDER BY 
    b.name;




-- En SQL, UNION y JOIN son dos operaciones distintas que se utilizan para combinar datos de diferentes maneras. A continuación, te explico las diferencias clave entre ambas:

-- UNION
-- Propósito: Combina los resultados de dos o más consultas SELECT en un solo conjunto de resultados.
-- Requisitos: Las consultas que se combinan deben tener el mismo número de columnas y tipos de datos compatibles en las columnas correspondientes.
-- Duplicados: Por defecto, UNION elimina los duplicados. Si deseas incluir duplicados, puedes usar UNION ALL.
-- Sintaxis:
-- SELECT columna1, columna2 FROM tabla1
-- UNION
-- SELECT columna1, columna2 FROM tabla2;
-- JOIN
-- Propósito: Combina filas de dos o más tablas basándose en una condición relacionada entre ellas.
-- Tipos de JOIN:
-- INNER JOIN: Devuelve filas cuando hay una coincidencia en ambas tablas.
-- LEFT JOIN (o LEFT OUTER JOIN): Devuelve todas las filas de la tabla izquierda y las filas coincidentes de la tabla derecha. Si no hay coincidencia, las filas de la tabla derecha serán NULL.
-- RIGHT JOIN (o RIGHT OUTER JOIN): Devuelve todas las filas de la tabla derecha y las filas coincidentes de la tabla izquierda. Si no hay coincidencia, las filas de la tabla izquierda serán NULL.
-- FULL JOIN (o FULL OUTER JOIN): Devuelve filas cuando hay una coincidencia en una de las tablas. Si no hay coincidencia, las filas no coincidentes también se incluyen con valores NULL.
-- Sintaxis:
-- SELECT a.columna1, b.columna2
-- FROM tabla1 a
-- INNER JOIN tabla2 b ON a.columna_comun = b.columna_comun;
-- Ejemplo Práctico
-- UNION
-- SELECT nombre, apellido FROM empleados
-- UNION
-- SELECT nombre, apellido FROM clientes;
-- Este UNION combinará los nombres y apellidos de las tablas empleados y clientes, eliminando duplicados.

-- JOIN
-- SELECT empleados.nombre, departamentos.nombre
-- FROM empleados
-- INNER JOIN departamentos ON empleados.departamento_id = departamentos.id;
-- Este INNER JOIN combinará las filas de las tablas empleados y departamentos donde departamento_id en empleados coincide con id en departamentos.

-- Resumen
-- UNION se utiliza para combinar resultados de múltiples consultas SELECT en un solo conjunto de resultados.
-- JOIN se utiliza para combinar filas de dos o más tablas basándose en una condición relacionada entre ellas.
-- Espero que esto aclare las diferencias entre UNION y JOIN en SQL. Si tienes alguna otra pregunta o necesitas más detalles, no dudes en preguntar.