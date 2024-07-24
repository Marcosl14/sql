/*
Una vista en SQL es una consulta almacenada que puedes tratar como si fuera una tabla.
Las vistas son útiles para simplificar consultas complejas, proporcionar seguridad al ocultar
ciertas columnas o filas, y para reutilizar consultas comunes.
 * Actualización de Vistas: Las vistas son "virtuales" y no almacenan datos por sí mismas.
   Los datos se obtienen de las tablas subyacentes cada vez que consultas la vista.
 * Seguridad: Puedes usar vistas para limitar el acceso a ciertas columnas o filas de una tabla.
   Por ejemplo, podrías crear una vista que excluya información sensible.
 * Rendimiento: Las vistas pueden simplificar consultas complejas, pero no necesariamente mejoran el rendimiento.
   En algunos casos, pueden incluso ser menos eficientes que las consultas directas a las tablas.
*/

CREATE OR REPLACE VIEW view_users AS
SELECT id, username, email, created_at
FROM users;

SELECT * FROM view_users;



/*
Una vista materializada es una vista que almacena físicamente los resultados de una consulta en una tabla.
A diferencia de las vistas regulares, que son "virtuales" y se recalculan cada vez que se consultan,
las vistas materializadas almacenan los datos y pueden ser actualizadas periódicamente.
Esto puede mejorar significativamente el rendimiento de consultas complejas, ya que los datos no necesitan ser recalculados cada vez.
 * Rendimiento: Las vistas materializadas pueden mejorar significativamente el rendimiento de consultas complejas,
   pero requieren espacio de almacenamiento adicional y pueden necesitar ser actualizadas periódicamente.
 * Actualización: Dependiendo del SGBD, las vistas materializadas pueden ser actualizadas automáticamente o manualmente.
   Asegúrate de entender cómo y cuándo se actualizan en tu SGBD específico.
 * Consistencia: Las vistas materializadas pueden no estar siempre sincronizadas con los datos subyacentes,
   especialmente si se actualizan manualmente o en intervalos largos.
*/


CREATE MATERIALIZED VIEW view_users_2 AS
SELECT id, username, email, created_at
FROM users;

REFRESH MATERIALIZED VIEW mv_users; -- para actualizar la vista materializada a su ultimo estado

SELECT * FROM view_users_2;
