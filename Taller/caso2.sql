CREATE DATABASE IF NOT EXISTS PRUEBA;

USE PRUEBA; 

CREATE TABLE IF NOT EXISTS clientes (
id INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(50),
fecha_nacimiento DATE
);
INSERT INTO clientes (nombre, fecha_nacimiento) VALUES
('Luis Martínez', '1990-06-15'),
('María López', '1985-09-20'),
('Pedro Gómez', '2000-03-10');

DELIMITER //
CREATE FUNCTION calcular_edad(fecha_nacimiento DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE edad INT;
    set edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
    return edad;
END //
DELIMITER ;

SELECT nombre, fecha_nacimiento, calcular_edad(fecha_nacimiento) AS edad
FROM clientes;
  