CREATE OR REPLACE FUNCTION say_hello( name varchar )
RETURNS varchar
AS
$$ -- tag apertura... podria ser $nombre$
BEGIN
return 'Hola ' || name;
END
$$ -- tag cierre... el mismo que el de apertua
LANGUAGE plpgsql;

SELECT say_hello( 'Pepe' );


-- o algo mas complejo:
CREATE OR REPLACE FUNCTION comment_replies( id integer )
RETURNS json
AS
$$
DECLARE result json;

BEGIN
	
	select 
		json_agg( json_build_object(
		  'user', comments.user_id,
		  'comment', comments.content
		)) into result
	from comments where comment_parent_id = id;


	return result;
END;
$$
LANGUAGE plpgsql;

select 
	a.*,
	comment_replies(a.post_id) as replies
from comments a
where comment_parent_id is null;
