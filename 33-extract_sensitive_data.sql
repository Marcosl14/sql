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
*/


