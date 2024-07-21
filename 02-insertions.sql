-- DML -> data manipulation language (manipulacion de la informacion en la tabla)

INSERT INTO users
    ("name")
VALUES
    ('Marcos'),
    ('Cecilia'),
    ('Joaquin'),
    ('Francesco');

-- o para insertar todas las columnas...

INSERT INTO users
VALUES
    ('Marcos'),
    ('Cecilia'),
    ('Joaquin'),
    ('Francesco');

-- o insertar en una tabla nueva (o no) datos de otra tabla, por ejemplo:
INSERT INTO continent (name)
SELECT DISTINCT continent
FROM country
ORDER BY continent ASC
