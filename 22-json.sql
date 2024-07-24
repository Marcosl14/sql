-- json_build_object crea un objeto JSON
-- json_agg crea un array con las resppuestas

SELECT json_agg(
        json_build_object(
            'user',
            comments.user_id,
            'comment',
            comments.content
        )
    )
FROM comments
WHERE comment_parent_id = 1



-- o algo un poco mas complejo
SELECT *,
    (
        SELECT json_agg(
                json_build_object(
                    'user', comments.user_id,
                    'comment', comments.content
                )
            )
        FROM comments
        WHERE comment_parent_id = 1
    )
FROM comments
WHERE comment_parent_id IS NULL
