CREATE DATABASE IF NOT EXISTS empresa;

USE empresa;

-- Tabla de empleados

CREATE TABLE IF NOT EXISTS empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    posicion VARCHAR(50),
    fecha_contratacion DATE
);

-- Tabla de salarios

CREATE TABLE IF NOT EXISTS salarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empleado_id INT,
    salario DECIMAL(10, 2) NOT NULL,
    fecha_ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

-- Tabla de auditoría de cambios en salarios

CREATE TABLE IF NOT EXISTS auditoria_salarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empleado_id INT,
    salario_anterior DECIMAL(10, 2),
    nuevo_salario DECIMAL(10, 2),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO empleados (nombre, posicion, fecha_contratacion) VALUES
('Carlos Gómez', 'Gerente', '2018-04-10'),
('Laura Pérez', 'Analista', '2020-07-15');

INSERT INTO salarios (empleado_id, salario) VALUES
(1, 5000.00),
(2, 3000.00);


-- Ejercicio 1. Se activara despues de haber ingresado un nuevo salario, guardandolo automaticamente en "auditoria_salarios"
DELIMITER $$

    CREATE TRIGGER after_insert_salario
    AFTER INSERT on salarios
    FOR EACH ROW
    BEGIN
        INSERT INTO auditoria_salarios (empleado_id, salario_anterior, nuevo_salario, fecha_cambio)
        VALUES (NEW.empleado_id, 0.00, NEW.salario, NOW());
    END $$
DELIMITER;

-- PRUEBA 1.

INSERT INTO empleados (nombre, posicion, fecha_contratacion) 
VALUES ('Juan López', 'Desarrollador', '2021-09-20');

INSERT INTO salarios (empleado_id, salario) 
VALUES (3, 4500.00);

SELECT * FROM auditoria_salarios;

------------------------------------------------------------------

-- Ejercicio 2. TRIGGER encargado de validar si el salario nuevo es mayor al anterior del empleado

DELIMITER $$

CREATE TRIGGER before_update_salario
BEFORE UPDATE ON salarios
FOR EACH ROW
BEGIN
    IF NEW.salario < OLD.salario THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: El nuevo salario es menor al salario actual';
    END IF;
END $$

DELIMITER ;

-- PRUEBA 2.

-- Funcional
UPDATE salarios 
SET salario = 6000.00 
WHERE empleado_id = 1;

-- NO funcional

UPDATE salarios 
SET salario = 2000.00 
WHERE empleado_id = 1;

-- 

SELECT * FROM salarios WHERE empleado_id = 1;

--


-- Ejercicio 3. El anterior TIGGER valido, de cumplirse, se actualizara el nuevo salario


DELIMITER $$

CREATE TRIGGER after_update_salario
AFTER UPDATE ON salarios
FOR EACH ROW
BEGIN
    IF OLD.salario <> NEW.salario THEN
        INSERT INTO auditoria_salarios (empleado_id, salario_anterior, nuevo_salario)
        VALUES (OLD.empleado_id, OLD.salario, NEW.salario);
    END IF;
END $$

DELIMITER ;

-- PRUEBA 3.

UPDATE salarios 
SET salario = 7000.00 
WHERE empleado_id = 1;

SELECT * FROM auditoria_salarios;


-- Ejercicio 4. Este TIGGER esta encargado de eliminar un salario y registrar el cambio en "auditoria_salario"

DELIMITER $$

DROP TRIGGER IF EXISTS after_delete_salario $$

CREATE TRIGGER after_delete_salario
AFTER DELETE ON salarios
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_salarios (empleado_id, salario_anterior, nuevo_salario)
    VALUES (OLD.empleado_id, OLD.salario, 0.00);
END $$

DELIMITER ;

-- PRUEBA 4.

DELETE FROM salarios 
WHERE empleado_id = 2;

SELECT * FROM auditoria_salarios;



-- Ejercicio FINAL. REPORTE COMPLETO DE AUDITORIA

SELECT
    e.nombre AS empleado,
    a.salario_anterior,
    a.nuevo_salario,
    a.fecha_cambio
FROM auditoria_salarios a
JOIN empleados e ON a.empleado_id = e.id
ORDER BY a.fecha_cambio DESC;
