CREATE DATABASE IF NOT EXISTS PRUEBA;

USE PRUEBA; 

CREATE TABLE IF NOT EXISTS productos(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(20),
    precio DECIMAL(10,2)
);

DELIMITER //

CREATE FUNCTION if NOT EXISTS clasificar_precio(precio DECIMAL(10,2)) 
RETURNS VARCHAR(10) 
DETERMINISTIC
BEGIN
    DECLARE clasificacion_precio VARCHAR(10);

    IF precio < 50 THEN
        SET clasificacion_precio = 'Bajo';
    ELSEIF precio BETWEEN 50 AND 200 THEN
        SET clasificacion_precio = 'Medio';
    ELSE
        SET clasificacion_precio = 'Alto';
    END IF;

    RETURN clasificacion_precio;
END //

DELIMITER ;

SELECT id, nombre, precio, clasificar_precio(precio) as clasificacion_precio
FROM productos;