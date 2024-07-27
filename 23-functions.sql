CREATE OR REPLACE FUNCTION say_hello( name varchar )
RETURNS varchar
AS
$$ -- tag apertura... podria ser $nombre$
BEGIN
	RETURN 'Hello ' || name;
END
$$ -- tag cierre... el mismo que el de apertua
LANGUAGE plpgsql;

SELECT say_hello( 'Pepe' );
-- o
SELECT say_hello( employee_name ) AS greeting FROM employees;


-- o algo mas complejo:
CREATE OR REPLACE FUNCTION comment_replies( id integer )
RETURNS json
AS
$$
DECLARE result json; -- se declara la variable

BEGIN
	SELECT 
		json_agg( json_build_object(
		  'user', comments.user_id,
		  'comment', comments.content
		)) INTO result -- se almacena en la variable -> por eso es INTO y no AS
	FROM comments WHERE comment_parent_id = id;

	RETURN result; -- se retorna la variable
END;
$$
LANGUAGE plpgsql;

SELECT 
	a.*,
	comment_replies(a.post_id) AS replies
FROM comments a
WHERE comment_parent_id IS NULL;


-- o mas complejo:
CREATE OR REPLACE FUNCTION max_raise_2( empl_id int )
RETURNS NUMERIC(8,2) as $$

DECLARE
	employee_job_id int;
	current_salary NUMERIC(8,2);

	job_max_salary NUMERIC(8,2);
	possible_raise NUMERIC(8,2);

BEGIN
	SELECT 
		job_id, salary
		INTO employee_job_id, current_salary
	FROM employees WHERE employee_id = empl_id;

	SELECT max_salary INTO job_max_salary FROM jobs WHERE job_id = employee_job_id;
	
	possible_raise = job_max_salary - current_salary;

	RETURN possible_raise;
END;
$$ LANGUAGE plpgsql;

SELECT employee_id, first_name, max_raise_2(employee_id) FROM employees;

-- funcion que retorna una tabla
SELECT country_id, country_name, region_name FROM countries
INNER JOIN regions ON countries.region_id = regions.region_id;

CREATE OR REPLACE FUNCTION country_region() 
	RETURNS TABLE ( id CHARACTER(2), name VARCHAR(40), region VARCHAR(25) )
AS $$

BEGIN
	RETURN query
		SELECT country_id, country_name, region_name FROM countries
			INNER JOIN regions ON countries.region_id = regions.region_id;
	
END;
$$ LANGUAGE plpgsql;

SELECT * FROM country_region();
