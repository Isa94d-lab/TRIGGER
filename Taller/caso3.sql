CREATE DATABASE IF NOT EXISTS PRUEBA;

USE PRUEBA; 

CREATE TABLE IF NOT EXISTS contactos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(30),
    telefono VARCHAR(10)
);

INSERT INTO contactos (nombre, telefono) VALUES
('Juan Pérez', '1234567890'),
('Ana Gómez', '9876543210'),
('Carlos Ruiz', '5551234567');

DELIMITER //
CREATE FUNCTION formatear_telefono(numero VARCHAR(10)) 
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    RETURN CONCAT('(', LEFT(numero, 3), ') ', MID(numero, 4, 3), '-', RIGHT(numero, 4));
END //
DELIMITER ;

SELECT nombre, telefono, formatear_telefono(telefono) AS telefono_formateado
FROM contactos;