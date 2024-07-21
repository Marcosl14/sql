-- DQL -> data query language (busquedas de informacion en la tabla)

SELECT * FROM "users"

-- tener cuidado con el uso del LIKE porque puede hacer las queries un poco lentas

-- Nombre inicie con J mayúscula 
WHERE  "name"  LIKE 'J%';

-- Nombre inicie con Jo 
WHERE  "name"  LIKE 'Jo%';

-- Nombre termine con hn 
WHERE  "name"  LIKE '%hn';

-- Nombre tenga 3 letras y las últimas 2 
-- tienen que ser "om" 
WHERE  "name"  LIKE '_om'; // Tom

-- Puede iniciar con cualquier letra 
-- seguido de "om" y cualquier cosa después 
WHERE  "name"  LIKE '_om%'; // Tomas


-- ILIKE!!!
SELECT 'ABC' ILIKE 'a%';   -- Resulta en: true
