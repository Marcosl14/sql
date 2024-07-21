-- DQL -> data query language (busquedas de informacion en la tabla)

-- https://www.postgresql.org/docs/9.5/functions-aggregate.html

SELECT
    COUNT(*) AS total_users,
    MIN(followers) AS min_followers,
    MAX(followers) AS max_followers,
    AVG(followers) AS average_followers,
    SUM(followers) / COUNT(*) as average_followers_1,
    ROUND(
        AVG(followers)
     ) AS average_followers_2,
    FLOOR(
        AVG(followers)
    ) AS floor_followers,
    CEIL(
        AVG(followers)
    ) AS ceil_followers
FROM users;