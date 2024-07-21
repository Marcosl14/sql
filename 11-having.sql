-- DQL -> data query language (busquedas de informacion en la tabla)

SELECT count(*) as amount, country
FROM users
-- WHERE count(*) > 5 -- esto fallaria porque no se permiten aggregate_functions en el WHERE
GROUP BY country
HAVING count(*) > 5 -- tampoco podemos usar amount aqui... solo en algunas bases de datos se permite
ORDER BY amount DESC;

-- otro ejemplo:
SELECT
    count(*) as amount,
    TRIM(
        SUBSTRING(
            email,
            POSITION( '@' IN email) + 1
        )
    ) as domain
FROM users
GROUP BY domain
HAVING count(*) > 1
ORDER BY amount DESC
