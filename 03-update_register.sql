-- DML -> data manipulation language (manipulacion de la informacion en la tabla)

UPDATE "users"
SET "name" = 'Jose'
WHERE "name" = 'Marcos';


-- o ediciones masivas, por ejemplo, reemplazar los valores de cierto campo de una tabla (con una subquery):
UPDATE country
SET continent = (SELECT code FROM continent WHERE continent.name = country.continent);

-- Primero se crea la tabla continent y se le agregan los valores de los continentes:
CREATE TABLE continent (
    code SERIAL,
    name TEXT UNIQUE NOT NULL
);

INSERT INTO continent (name)
SELECT DISTINCT continent
FROM country
ORDER BY continent ASC;
