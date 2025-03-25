CREATE DATABASE IF NOT EXISTS PRUEBA;

USE PRUEBA; 

CREATE TABLE IF NOT EXISTS empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    salario DECIMAL(10,2)
);

INSERT IGNORE INTO empleados (nombre, salario) VALUES
    ('Juan Pérez', 1500.00),
    ('Ana Gómez', 3000.00),
    ('Carlos Ruiz', 6000.00);


DELIMITER //
CREATE FUNCTION calcular_bonificacion(salario DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE bonificacion DECIMAL(10,2);

    IF salario < 2000 THEN
    set bonificacion = salario * 0.10;
    ELSEIF  salario BETWEEN 2000 and 5000 THEN
    set bonificacion = salario * 0.7;
    ELSE
    set bonificacion = salario * 0.5;
    END IF;
    RETURN bonificacion;
END //
DELIMITER ;

SELECT id, nombre, salario, calcular_bonificacion(salario) AS bonificacion
FROM empleados;
  