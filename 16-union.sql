SELECT * FROM continent WHERE name like '%America%'
UNION
SELECT * FROM continent WHERE code in (3,5)
ORDER BY name ASC

-- las uniones tienen que tener el mismo numero de columnas y el mismo tipo en cada columna


-- o sentencias mas complejas...: 
(
  SELECT count(*) as count, b.name FROM country a
    INNER JOIN continent b ON a.continent = b.code
    GROUP by b.name
)
union
(
    SELECT 0 as count, b.name FROM country a
      RIGHT JOIN continent b ON a.continent = b.code
      WHERE a.continent IS NULL
      GROUP by b.name
)
ORDER BY count;
