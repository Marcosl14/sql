SELECT domain, amount
FROM (
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
) as new_subquery

-- CUIDADO: las subqueries son altamente ineficientes