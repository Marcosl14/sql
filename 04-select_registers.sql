-- DQL -> data query language (busquedas de informacion en la tabla)

SELECT * FROM "users"
-- WHERE 
LIMIT 2
OFFSET 2;


SELECT * FROM "users"
WHERE followers BETWEEN 2000 and 10000
ORDER BY followers ASC;
