/*
Prevenir inyecciones SQL es crucial para la seguridad de las aplicaciones que interactúan con bases de datos. Aquí tienes algunas formas efectivas de prevenir inyecciones SQL:

### 1. **Consultas Parametrizadas (Sentencias Preparadas)**
Las consultas parametrizadas o sentencias preparadas son una de las formas más efectivas de prevenir la inyección SQL. Separan los datos de la consulta, evitando que la entrada del usuario altere la estructura de la consulta SQL.

**Ejemplo en JavaScript (Node.js con MySQL):**

```javascript
const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'database_name'
});

connection.connect();

const userInput = 'electronics';
const secureQuery = 'SELECT * FROM products WHERE category = ?';
connection.query(secureQuery, [userInput], (error, results) => {
  if (error) throw error;
  console.log(results);
});

connection.end();
```

### 2. **ORM (Object-Relational Mapping)**
Los ORM permiten interactuar con la base de datos utilizando objetos y métodos del lenguaje de programación, lo que reduce la posibilidad de inyección SQL.

**Ejemplo en JavaScript (Node.js con Sequelize):**

```javascript
const { Sequelize, DataTypes } = require('sequelize');
const sequelize = new Sequelize('database', 'username', 'password', {
  host: 'localhost',
  dialect: 'mysql'
});

const Product = sequelize.define('Product', {
  category: {
    type: DataTypes.STRING,
    allowNull: false
  }
});

(async () => {
  const products = await Product.findAll({
    where: {
      category: 'electronics'
    }
  });
  console.log(products);
})();
```

### 3. **Escapado de Entradas**
Escapar las entradas del usuario antes de incluirlas en las consultas SQL. Esto es menos seguro que las consultas parametrizadas, pero puede ser útil como una capa adicional de seguridad.

**Ejemplo en PHP:**

```php
$input = mysqli_real_escape_string($connection, $input);
$query = "SELECT * FROM products WHERE category = '$input'";
$result = mysqli_query($connection, $query);
```

### 4. **Validación y Sanitización de Entradas**
Validar y sanear las entradas del usuario para asegurarse de que contengan solo datos esperados.

**Ejemplo en JavaScript:**

```javascript
const validator = require('validator');

const userInput = 'electronics';
if (validator.isAlphanumeric(userInput)) {
  const secureQuery = 'SELECT * FROM products WHERE category = ?';
  connection.query(secureQuery, [userInput], (error, results) => {
    if (error) throw error;
    console.log(results);
  });
} else {
  console.log('Invalid input');
}
```

### 5. **Principio de Menor Privilegio**
Asegúrate de que las cuentas de la base de datos utilizadas por la aplicación tengan los permisos mínimos necesarios. Por ejemplo, una cuenta utilizada para consultas de solo lectura no debería tener permisos de escritura.

### 6. **Monitoreo y Registro de Actividades**
Implementar monitoreo y registro de actividades en la base de datos para detectar patrones sospechosos o intentos de inyección SQL.

### 7. **Uso de Procedimientos Almacenados**
Utilizar procedimientos almacenados en lugar de consultas dinámicas. Los procedimientos almacenados se compilan y validan en la base de datos, reduciendo el riesgo de inyección SQL.

**Ejemplo en SQL Server:**

```sql
CREATE PROCEDURE GetProductsByCategory
  @Category NVARCHAR(50)
AS
BEGIN
  SELECT * FROM products WHERE category = @Category;
END
```

**Ejemplo de llamada desde una aplicación:**

```javascript
const sql = require('mssql');
const request = new sql.Request();
request.input('Category', sql.NVarChar, userInput);
request.execute('GetProductsByCategory', (err, result) => {
  console.log(result);
});
```

### 8. **Utilización de Firewalls de Aplicación Web (WAF)**
Un WAF puede ayudar a detectar y bloquear ataques de inyección SQL al inspeccionar las solicitudes entrantes.

### 9. **Actualización Regular del Software**
Mantén siempre actualizados el servidor de la base de datos y las bibliotecas de acceso a datos para beneficiarte de las últimas correcciones de seguridad.

Implementar una combinación de estas técnicas proporcionará una defensa más robusta contra las inyecciones SQL.

*/