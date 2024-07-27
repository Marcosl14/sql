/*
Un procedimiento almacenado en PostgreSQL es un conjunto de instrucciones SQL y PL/pgSQL que se almacenan en la base de datos y se pueden ejecutar como una unidad. Los procedimientos almacenados permiten encapsular lógica compleja, realizar operaciones repetitivas y mejorar la modularidad y reutilización del código. A diferencia de las funciones, los procedimientos almacenados pueden realizar operaciones que no devuelven un valor, como actualizaciones masivas, inserciones, y otras modificaciones de datos.

Objetivos de un Procedimiento Almacenado
Encapsulación de Lógica Compleja: Permiten encapsular lógica de negocio compleja en una unidad reutilizable.
Reutilización de Código: Facilitan la reutilización de código, ya que se pueden llamar desde diferentes partes de la aplicación.
Mantenimiento: Mejoran el mantenimiento del código, ya que cualquier cambio en la lógica se realiza en un solo lugar.
Seguridad: Pueden mejorar la seguridad al controlar el acceso a los datos y operaciones específicas.
Rendimiento: Pueden mejorar el rendimiento al reducir la cantidad de datos transferidos entre la aplicación y la base de datos.
Ejemplos de Procedimientos Almacenados
Ejemplo 1: Procedimiento para Actualizar Salarios
Este procedimiento actualiza los salarios de los empleados en función de su rendimiento.
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

-- Insertar algunos datos de ejemplo
INSERT INTO productos (nombre, stock) VALUES
('Producto A', 100),
('Producto B', 200);

DROP PROCEDURE IF EXISTS registrar_venta(INT, INT);

-- Crear un procedimiento que registra una venta y actualiza el stock
CREATE PROCEDURE registrar_venta(p_producto_id INT, p_cantidad INT)
AS $$
DECLARE
    v_stock INT;
    error_occurred BOOLEAN := FALSE;
BEGIN
    -- Iniciamos una transacción
    BEGIN
        -- Verificamos el stock actual del producto
        SELECT stock INTO v_stock FROM productos WHERE id = p_producto_id;
        
        -- Si no hay suficiente stock, lanzamos un error
        IF v_stock < p_cantidad THEN
            RAISE EXCEPTION 'Stock insuficiente para el producto %', p_producto_id;
        END IF;

        -- Insertamos la venta en la tabla ventas
        INSERT INTO ventas (producto_id, cantidad) VALUES (p_producto_id, p_cantidad);

        -- Actualizamos el stock del producto
        UPDATE productos SET stock = stock - p_cantidad WHERE id = p_producto_id;
    EXCEPTION
        -- Si ocurre un error, marcamos la variable de error y hacemos ROLLBACK
        WHEN OTHERS THEN
            error_occurred := TRUE;
            ROLLBACK;
            RAISE NOTICE 'Error occurred: %', SQLERRM;
    END;

    -- Si no hubo errores, hacemos COMMIT
    IF NOT error_occurred THEN
        COMMIT;
        RAISE NOTICE 'Venta registrada y stock actualizado correctamente';
    END IF;
END;
$$ LANGUAGE plpgsql;

/*
El comando ROLLBACK se utiliza en procedimientos almacenados y transacciones para deshacer todas las operaciones
realizadas desde el inicio de la transacción. Es una herramienta crucial para mantener la integridad de los datos
en caso de errores o condiciones inesperadas durante la ejecución de una transacción.

¿Por qué usar ROLLBACK en un procedimiento almacenado?
Mantenimiento de la Integridad de los Datos: Si ocurre un error durante la ejecución de un procedimiento almacenado,
ROLLBACK puede deshacer todas las operaciones realizadas hasta ese punto, asegurando que la base de datos no quede en un estado inconsistente.
Manejo de Errores: Permite manejar errores de manera controlada. Puedes capturar excepciones y decidir si deseas
deshacer todas las operaciones realizadas hasta el momento.
Atomicidad: Garantiza que una serie de operaciones se realicen completamente o no se realicen en absoluto, manteniendo la atomicidad de la transacción.
*/

-- Llamar al procedimiento para registrar una venta
-- Esto debería funcionar correctamente
CALL registrar_venta(1, 10);

-- Consultar las tablas para ver los resultados
SELECT * FROM productos;
SELECT * FROM ventas;

-- Llamar al procedimiento con una cantidad que excede el stock disponible
-- Esto debería generar un error y deshacer la transacción
CALL registrar_venta(1, 1000);

-- Consultar las tablas para ver que no se realizaron cambios debido al error
SELECT * FROM productos;
SELECT * FROM ventas;


-- Otro ejemplo:
CREATE OR REPLACE PROCEDURE user_login(user_name VARCHAR, user_password VARCHAR)
AS $$
DECLARE 
    was_found BOOLEAN;
BEGIN
    SELECT COUNT(*) INTO was_found 
    FROM "user" 
    WHERE username = user_name 
      AND password = CRYPT(user_password, password);

    IF was_found = FALSE THEN
        INSERT INTO session_failed(username, "when") 
        VALUES (user_name, NOW());
        COMMIT;
        RAISE EXCEPTION 'Usuario y contraseña no son correctos';    
    END IF;
    
    UPDATE "user" 
    SET last_login = NOW() 
    WHERE username = user_name;
    COMMIT;
    RAISE NOTICE 'Usuario encontrado %', was_found;
END;
$$ LANGUAGE plpgsql;

CALL user_login('fernando', '123456');
