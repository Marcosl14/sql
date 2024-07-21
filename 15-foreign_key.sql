-- para hacer esto, el country( code ) debe ser unique...
-- ALTER TABLE language
--     ADD CONSTRAINT unique_code UNIQUE (code);

ALTER TABLE city
    ADD CONSTRAINT fk_country_code
    FOREIGN KEY (countrycode)
    REFERENCES country( code )
    ON DELETE CASCADE; -- used to specify that when a row is deleted from the parent table, all rows in the child table that reference the deleted row should also be deleted.
-- ON UPDATE CASCADE, provides a powerful solution to automate the update of child records when the corresponding parent record is updated

-- When to Use the “ON UPDATE CASCADE” Clause?
-- When a record in a parent table is updated, it often requires updating related records in child tables to maintain data consistency.
-- Manually updating these child records can be time–consuming and error–likely, especially in large databases with complex relationships.
-- We will understand through the below examples.

-- CREATE TABLE parent_table (
--     parent_id INT PRIMARY KEY
-- );
-- CREATE TABLE child_table (
--     child_id INT PRIMARY KEY,
--     parent_id INT,
--     FOREIGN KEY (parent_id) REFERENCES parent_table(parent_id) ON UPDATE CASCADE
-- );

-- Explanation: The above query creates two tables: parent_tathe le with a primary key parent_id,
-- and child_table with a primary key child_id and a foreign key parent_id referencing the parent_id in parent_table.
-- The ON UPDATE CASCADE clause ensures that if the parent_id in parent_table is updated,
-- the corresponding parent_id in child_table is also updated to maintain referential integrity.