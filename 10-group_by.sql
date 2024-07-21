-- DQL -> data query language (busquedas de informacion en la tabla)

SELECT count(*), followers
FROM users
WHERE followers = 4 OR followers = 5000
-- esta query por si sola, va a fallar porque estamos intentando usar una aggregate_function en conjunto con un campo de la tabla en el SELECT
-- por eso usamos el GROUP BY, para agrupar los resultados
GROUP BY followers;

SELECT count(*) as amount, followers
FROM users
WHERE followers BETWEEN 3000 AND 5000
GROUP BY followers
ORDER BY amount DESC;
