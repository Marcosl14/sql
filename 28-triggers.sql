/*
¡Claro! Los triggers (disparadores) en bases de datos son una poderosa herramienta que permite
ejecutar automáticamente una serie de acciones en respuesta a ciertos eventos en una tabla.
A continuación, te proporciono una explicación detallada sobre los triggers, sus tipos, y cómo se utilizan en PostgreSQL.

¿Qué es un Trigger?
Un trigger es un conjunto de instrucciones que se ejecutan automáticamente en respuesta a un evento específico
en una tabla o vista. Los eventos que pueden activar un trigger incluyen inserciones (INSERT),
actualizaciones (UPDATE), y eliminaciones (DELETE). Los triggers se utilizan para mantener la integridad de los datos,
realizar auditorías, y automatizar tareas repetitivas.

Tipos de Triggers
Antes del Evento (BEFORE):

Se ejecuta antes de que el evento (inserción, actualización, eliminación) se realice en la tabla.
Puede modificar los datos que se están insertando o actualizando.
Puede cancelar la operación si se lanza una excepción.
Después del Evento (AFTER):

Se ejecuta después de que el evento se haya realizado en la tabla.
No puede modificar los datos que se han insertado o actualizado.
Se utiliza comúnmente para auditorías y registros.
En Lugar de (INSTEAD OF):

Se utiliza principalmente con vistas.
Reemplaza la operación original con una operación definida en el trigger.
Componentes de un Trigger
Evento: El evento que activa el trigger (INSERT, UPDATE, DELETE).
Tiempo: Cuándo se ejecuta el trigger en relación con el evento (BEFORE, AFTER, INSTEAD OF).
Condición: Opcionalmente, una condición que debe cumplirse para que el trigger se ejecute.
Acción: El conjunto de instrucciones que se ejecutan cuando se activa el trigger.
Ejemplo de Uso de Triggers en PostgreSQL
A continuación, te muestro un ejemplo completo de cómo crear y utilizar un trigger en PostgreSQL.
*/

-- Crear tablas de ejemplo para trabajar con datos
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    stock INT
);

CREATE TABLE ventas (
    id SERIAL PRIMARY KEY,
    producto_id INT REFERENCES productos(id),
    cantidad INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE session (
    user_id INT,
    last_login TIMESTAMP
);

-- Crear una función de trigger que registra una sesión
CREATE OR REPLACE FUNCTION create_session_log()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO session (user_id, last_login) 
    VALUES (NEW.id, NOW());
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear un trigger que se ejecuta después de actualizar la columna last_login en la tabla "user"
CREATE OR REPLACE TRIGGER create_session_trigger 
AFTER UPDATE ON "user"
FOR EACH ROW 
WHEN (OLD.last_login IS DISTINCT FROM NEW.last_login)
EXECUTE FUNCTION create_session_log();


-- Otro ejemplo:

CALL user_login('fernando', '123456');

CREATE OR REPLACE TRIGGER create_session_trigger 
AFTER UPDATE ON "user"
FOR EACH ROW 
WHEN (OLD.last_login IS DISTINCT FROM NEW.last_login)
EXECUTE FUNCTION create_session_log();

CREATE OR REPLACE FUNCTION create_session_log()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "session" (user_id, last_login) 
    VALUES (NEW.id, NOW());
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
