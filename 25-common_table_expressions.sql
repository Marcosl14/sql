/*
Common Table Expressions (CTEs)
 * Definición: Una CTE es una consulta temporal que se puede referenciar dentro de una SELECT, INSERT, UPDATE, o DELETE.
   Se define utilizando la cláusula WITH.
 * Duración: Las CTEs son temporales y solo existen durante la ejecución de la consulta en la que se definen.
   No se almacenan en la base de datos.
 * Uso: Se utilizan principalmente para mejorar la legibilidad y la organización de consultas complejas.
   También pueden ser recursivas, lo que permite realizar operaciones como el recorrido de jerarquías.

Diferencias con una vista:
 * CTEs: Temporales y solo existen durante la ejecución de la consulta.
 * Vistas Regulares: Persistentes en cuanto a su definición (el almacenada la definicion), pero no almacenan datos.
*/

WITH query1 AS (
  SELECT date_trunc('week'::text, posts.created_at) AS weeks,
      sum(claps.counter) AS total_claps,
      count(DISTINCT posts.post_id) AS number_of_posts,
      count(*) AS number_of_claps
  FROM posts
      JOIN claps ON claps.post_id = posts.post_id
  GROUP BY (date_trunc('week'::text, posts.created_at))
  ORDER BY (date_trunc('week'::text, posts.created_at)) DESC
)

SELECT * FROM query1;

-- Multiples:
WITH claps_per_post AS (
  SELECT post_id, sum(counter) FROM claps
  GROUP BY post_id
), posts_2023 AS (
  SELECT * FROM posts WHERE created_at BETWEEN '2023-01-01' AND '2023-12-31'
)

SELECT * FROM claps_per_post
  WHERE claps_per_post.post_id IN (SELECT post_id FROM posts_2023)

-- Recursivos
/*
Los Common Table Expressions (CTEs) recursivos son una característica poderosa en SQL que te permite
realizar consultas recursivas,es decir, consultas que se refieren a sí mismas.
Esto es especialmente útil para trabajar con datos jerárquicos o estructuras de árbol,
como listas de empleados y sus gerentes, categorías y subcategorías, o rutas en grafos.

Sintaxis Básica de un CTE Recursivo
Un CTE recursivo se define utilizando la cláusula WITH y consta de dos partes:

Parte Ancla: La consulta inicial que no es recursiva.
Parte Recursiva: La consulta que se refiere al CTE y se ejecuta repetidamente.
La sintaxis básica es la siguiente:
  WITH RECURSIVE cte_name AS (
      -- Parte Ancla
      SELECT ...
      FROM ...
      WHERE ...

      UNION ALL

      -- Parte Recursiva
      SELECT ...
      FROM cte_name
      JOIN ...
      WHERE ...
  )

  SELECT * FROM cte_name;
*/

-- Por ejemplo:
WITH RECURSIVE t(n) AS (
    VALUES (1)

  UNION ALL

    SELECT n+1 FROM t WHERE n < 100
)

SELECT * FROM t;


-- Otro ejemplo:
WITH RECURSIVE countdown( val ) AS (
    SELECT 5 as val
    -- o VALUES(5)

  UNION ALL

    SELECT val - 1 FROM countdown WHERE val > 1
)

SELECT * FROM countdown;


-- O algo mas real:
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(100),
  manager_id INT
);

INSERT INTO employees (employee_id, employee_name, manager_id) VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'David', 2),
(5, 'Eve', 2);

WITH RECURSIVE employee_hierarchy AS (
    -- Parte Ancla: Selecciona los empleados que no tienen gerente (nivel más alto)
    SELECT 
      employee_id,
      employee_name,
      manager_id,
      1 AS level
    FROM employees
    WHERE manager_id IS NULL

  UNION ALL

    -- Parte Recursiva: Selecciona los empleados y se une con el CTE para encontrar sus gerentes
    SELECT 
      e.employee_id,
      e.employee_name,
      e.manager_id,
      eh.level + 1 AS level
    FROM employees e
    INNER JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)

SELECT * FROM employee_hierarchy;

-- podemos probar la parte ancla haciendo solamente:
WITH RECURSIVE employee_hierarchy AS (
  -- Parte Ancla: Selecciona los empleados que no tienen gerente (nivel más alto)
  SELECT 
    employee_id,
    employee_name,
    manager_id,
    1 AS level
  FROM employees
  WHERE manager_id IS NULL
)

SELECT * FROM employee_hierarchy;

-- Y seria lo mismo que hacer...
WITH employee_hierarchy AS (
  SELECT 
    employee_id,
    employee_name,
    manager_id
  FROM employees
)
SELECT * FROM employee_hierarchy WHERE manager_id IS NULL
UNION
SELECT * FROM employee_hierarchy WHERE manager_id = 1
UNION
SELECT * FROM employee_hierarchy WHERE manager_id = 2
UNION
SELECT * FROM employee_hierarchy WHERE manager_id = 3
