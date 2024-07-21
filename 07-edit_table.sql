-- DDL -> data definition language (definicion de la tabla)

DROP TABLE users; -- elimina la tabla. pero si la tabla esta relacionada, entonces arrojara error.

TRUNCATE TABLE users; -- elimina todos los registros de la tabla.


-- DDL -> data definition language (definicion de la tabla)

ALTER TABLE users 
    ADD COLUMN first_name VARCHAR(10),
    DROP COLUMN nueva_columna,
    ALTER COLUMN first_name TYPE VARCHAR(100),
    ALTER COLUMN first_name SET NOT NULL;

-- cambiar el tipo de dato de texto a entero
ALTER TABLE country 
    ALTER COLUMN continent TYPE Int4
	USING continent::integer;

-- hacer UNIQUE:
ALTER TABLE language
	ALTER COLUMN code SET UNIQUE

-- agregar un campo como PK
ALTER TABLE language
    ADD CONSTRAINT unique_code UNIQUE (code);

-- no aceptar campos negativos (CHECKS)
ALTER TABLE country 
    ADD CHECK (
        surfacearea >= 0
    );

ALTER TABLE country 
    ADD CHECK (
        continent = 'Asia'
        OR continent = 'South America'
        OR continent = 'North America'
        OR continent = 'Oceania'
        OR continent = 'Antarctica'
        OR continent = 'Africa'
        OR continent = 'Europe'
    );

ALTER TABLE country 
    DROP CONSTRAINT country_continent_check;
    
