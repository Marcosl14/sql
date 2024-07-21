-- DQL -> data query language (busquedas de informacion en la tabla)

-- https://www.postgresql.org/docs/9.1/functions-string.html

SELECT 'Hello ' || 'World';  -- Resulta en: 'Hello World'
SELECT 'Hello ' || 'World';  -- Resulta en: 'Hello World'
SELECT CONCAT('Hello', ' ', 'World');  -- Resulta en: 'Hello World'

SELECT SUBSTRING('Hello World' FROM 2 FOR 5);  -- Resulta en: 'ello '

SELECT LENGTH('Hello World');  -- Resulta en: 11

SELECT LOWER('Hello World');  -- Resulta en: 'hello world'

SELECT UPPER('Hello World');  -- Resulta en: 'HELLO WORLD'
SELECT UPPER(name) AS upper_name FROM users;

SELECT TRIM('   Hello World   ');    -- Resulta en: 'Hello World'
SELECT LTRIM('   Hello World   ');   -- Resulta en: 'Hello World   '
SELECT RTRIM('   Hello World   ');   -- Resulta en: '   Hello World'

SELECT REPLACE('Hello World', 'World', 'PostgreSQL');  -- Resulta en: 'Hello PostgreSQL'

SELECT POSITION('World' IN 'Hello World');  -- Resulta en: 7

SELECT REPEAT('Hello', 3);  -- Resulta en: 'HelloHelloHello'

SELECT 123::text;                 -- Resulta en: '123'
SELECT CAST(123 AS text);         -- Resulta en: '123'

-- EJEMPLOS DE APLICACION
SELECT
    name,
    TRIM(
        SUBSTRING(
            name,
            0, 
            POSITION( ' ' IN name)
        )
    ) AS first_name,
    TRIM(
        SUBSTRING( name,
            POSITION( ' ' IN name)
            -- LENGTH(name) - 1 -- esto lo podemos obviar... el ya sabe que es hasta el final
        )
    ) AS last_name
FROM users;

-- Y si fuese necesario actualizar la tabla con estos valores (agregarlos a columnas)...
ALTER TABLE users
    ADD COLUMN first_name VARCHAR(100),
    ADD COLUMN last_name VARCHAR(100);

UPDATE users
SET first_name = TRIM(
        SUBSTRING(
            name,
            0, 
            POSITION( ' ' IN name)
        )
    ),
    last_name = TRIM(
        SUBSTRING( name,
            POSITION( ' ' IN name)
        )
    );


