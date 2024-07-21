-- DML -> data manipulation language (manipulacion de la informacion en la tabla)

DELETE FROM users; -- CUIDADO porque esto vacía la tabla

DELETE FROM users
WHERE name = 'Marcos'
