/*
¿Qué es la inyección SQL ciega?
La inyección SQL ciega ocurre cuando una aplicación es vulnerable a inyección SQL, pero sus respuestas HTTP no
contienen los resultados de la consulta SQL relevante ni los detalles de errores de la base de datos.

Muchas técnicas como los ataques UNION no son efectivas con vulnerabilidades de inyección SQL ciega.
Esto se debe a que dependen de poder ver los resultados de la consulta inyectada en las respuestas de la aplicación.
Aún es posible explotar la inyección SQL ciega para acceder a datos no autorizados, pero se deben usar técnicas diferentes.
*/

/*
Explotando la inyección SQL ciega mediante respuestas condicionales
Considera una aplicación que usa cookies de seguimiento para recopilar análisis sobre el uso.
Las solicitudes a la aplicación incluyen un encabezado de cookie como este:

Cookie: TrackingId=u5YD3PapBcR4lN3e7Tj4
Cuando se procesa una solicitud que contiene una cookie TrackingId, la aplicación usa una consulta SQL para
determinar si es un usuario conocido:
*/

SELECT TrackingId FROM TrackedUsers WHERE TrackingId = 'u5YD3PapBcR4lN3e7Tj4'

/*
Esta consulta es vulnerable a inyección SQL, pero los resultados de la consulta no se devuelven al usuario.
Sin embargo, la aplicación se comporta de manera diferente dependiendo de si la consulta devuelve datos.
Si envías un TrackingId reconocido, la consulta devuelve datos y recibes un mensaje de "Bienvenido de nuevo" en la respuesta.

Este comportamiento es suficiente para poder explotar la vulnerabilidad de inyección SQL ciega.
Puedes recuperar información activando diferentes respuestas condicionalmente, dependiendo de una condición inyectada.


NOTA1: la Cookie la podemos ver en los parametros de la request o incluso en nuestro browser en 'Aplication'
NOTA2: podemos copiar el curl de la request en 'Network' y llevarlo a un script, por ejemplo, o incluso, postman


Para entender cómo funciona este exploit, supongamos que se envían dos solicitudes con los siguientes valores de
cookie TrackingId:

…xyz' AND '1'='1
…xyz' AND '1'='2

El primero de estos valores hace que la consulta devuelva resultados, porque la condición inyectada AND '1'='1 es
verdadera. Como resultado, se muestra el mensaje de "Bienvenido de nuevo".

El segundo valor hace que la consulta no devuelva resultados, porque la condición inyectada es falsa.
El mensaje de "Bienvenido de nuevo" no se muestra.

Esto nos permite determinar la respuesta a cualquier condición inyectada y extraer datos pieza por pieza.
*/


/*
Por ejemplo, supongamos que hay una tabla llamada Users con las columnas Username y Password, y un usuario llamado
Administrator. Puedes determinar la contraseña de este usuario enviando una serie de entradas para probar la
contraseña carácter por carácter.

NOTA:
Para comprobar si realmente existe la tabla Users:
xyz' AND (SELECT 'a' FROM Users LIMIT 1) = 'a

Para hacer esto, comienza con la siguiente entrada:

xyz' AND SUBSTRING((SELECT Password FROM Users WHERE Username = 'Administrator'), 1, 1) > 'm

NOTA:
Para comprobar si la base de datos usa SUBSTRING o SUBSTR:
xyz' AND SUBSTRING(('hola'), 1, 1) = 'h

Esto devuelve el mensaje de "Bienvenido de nuevo", indicando que la condición inyectada es verdadera, y por lo tanto,
el primer carácter de la contraseña es mayor que m.

Luego, enviamos la siguiente entrada:

xyz' AND SUBSTRING((SELECT Password FROM Users WHERE Username = 'Administrator'), 1, 1) > 't

Esto no devuelve el mensaje de "Bienvenido de nuevo", indicando que la condición inyectada es falsa, y por lo tanto,
el primer carácter de la contraseña no es mayor que t.

Finalmente, enviamos la siguiente entrada, que devuelve el mensaje de "Bienvenido de nuevo", confirmando que el primer
carácter de la contraseña es s:

xyz' AND SUBSTRING((SELECT Password FROM Users WHERE Username = 'Administrator'), 1, 1) = 's

Podemos continuar este proceso para determinar sistemáticamente la contraseña completa del usuario Administrator.

Nota
La función SUBSTRING se llama SUBSTR en algunos tipos de bases de datos.

*/
