DROP SCHEMA IF EXISTS restaurante_tp;

CREATE SCHEMA restaurante_tp;
USE restaurante_tp;

CREATE TABLE mozo (
    id_mozo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    apellido VARCHAR(45) NOT NULL,
    fecha_contratacion DATE NOT NULL
);

CREATE TABLE mesa (
    id_mesa INT PRIMARY KEY, 
    capacidad INT NOT NULL,
    ubicacion VARCHAR(45) NOT NULL 
);

CREATE TABLE categoria_producto (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE producto (
    codigo_producto INT PRIMARY KEY, 
    nombre VARCHAR(45) NOT NULL,
    id_categoria INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    activo TINYINT(1) DEFAULT 1 NOT NULL, 
    FOREIGN KEY (id_categoria) REFERENCES categoria_producto(id_categoria)
);

CREATE TABLE pedido (
    nro_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME NOT NULL,
    estado VARCHAR(20) NOT NULL, 
    mozo_id_mozo INT NOT NULL,
    mesa_id_mesa INT NOT NULL,
    FOREIGN KEY (mozo_id_mozo) REFERENCES mozo(id_mozo),
    FOREIGN KEY (mesa_id_mesa) REFERENCES mesa(id_mesa)
);

CREATE TABLE detalle_pedido (
    pedido_nro_pedido INT NOT NULL,
    producto_codigo INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario_cobrado DECIMAL(10,2) NOT NULL, 
    PRIMARY KEY (pedido_nro_pedido, producto_codigo),
    FOREIGN KEY (pedido_nro_pedido) REFERENCES pedido(nro_pedido),
    FOREIGN KEY (producto_codigo) REFERENCES producto(codigo_producto)
);

INSERT INTO mozo (nombre, apellido, fecha_contratacion) VALUES 
('Carlos', 'Gómez', '2025-01-15'),
('Lucía', 'Fernández', '2025-03-10'),
('Julio', 'Calzada', '2025-06-01'),
('David', 'Solari', '2025-08-12'),
('Juan', 'Skywalker', '2025-11-04'),
('Alejo', 'Morales', '2026-02-20');

INSERT INTO mesa VALUES 
(1, 2, 'Ventana'),
(2, 4, 'Centro'),
(3, 6, 'Patio'),
(4, 1, 'Barra'),
(5, 1, 'Barra'),
(6, 4, 'Terraza'),
(7, 2, 'Terraza');

INSERT INTO categoria_producto (nombre_categoria) VALUES 
('Plato Principal'),
('Bebida'),
('Postre'),
('Entrada');

INSERT INTO producto (codigo_producto, nombre, id_categoria, precio, activo) VALUES 
(101, 'Milanesa con Papas', 1, 8500.00, 1), 
(102, 'Ensalada', 1, 6200.00, 1),            
(103, 'Gaseosa', 2, 1500.00, 1),             
(104, 'Vino Tinto', 2, 4500.00, 1),           
(105, 'Flan Mixto', 3, 2800.00, 1),           
(106, 'Sopa del Día', 4, 3000.00, 1),
(107, 'Pancho', 4, 2500.00, 1),
(108, 'Hamburguesa completa', 1, 7500.00, 1),
(109, 'Agua', 2, 1200.00, 1),
(110, 'Fideos con salsa a eleccion', 1, 6800.00, 1);         

INSERT INTO pedido (fecha_hora, estado, mozo_id_mozo, mesa_id_mesa) VALUES 
(DATE_SUB(NOW(), INTERVAL 3 HOUR), 'Entregado', 1, 1),
(DATE_SUB(NOW(), INTERVAL 2 HOUR), 'Entregado', 1, 2),
(DATE_SUB(NOW(), INTERVAL 1 HOUR), 'Entregado', 1, 4);

INSERT INTO pedido (fecha_hora, estado, mozo_id_mozo, mesa_id_mesa) VALUES 
(DATE_SUB(NOW(), INTERVAL 170 MINUTE), 'Entregado', 2, 3),
(DATE_SUB(NOW(), INTERVAL 80 MINUTE), 'Entregado', 2, 6);

INSERT INTO pedido (fecha_hora, estado, mozo_id_mozo, mesa_id_mesa) VALUES 
(DATE_SUB(NOW(), INTERVAL 150 MINUTE), 'Entregado', 3, 5),
(DATE_SUB(NOW(), INTERVAL 50 MINUTE), 'Entregado', 3, 7);

INSERT INTO pedido (fecha_hora, estado, mozo_id_mozo, mesa_id_mesa) VALUES 
(DATE_SUB(NOW(), INTERVAL 130 MINUTE), 'Entregado', 4, 1),
(DATE_SUB(NOW(), INTERVAL 40 MINUTE), 'Entregado', 4, 3);

INSERT INTO pedido (fecha_hora, estado, mozo_id_mozo, mesa_id_mesa) VALUES 
(DATE_SUB(NOW(), INTERVAL 90 MINUTE), 'Entregado', 5, 2);

INSERT INTO pedido (fecha_hora, estado, mozo_id_mozo, mesa_id_mesa) VALUES 
(DATE_SUB(NOW(), INTERVAL 30 MINUTE), 'Entregado', 6, 6);

INSERT INTO detalle_pedido VALUES 
(1, 101, 2, 8500.00), (1, 103, 2, 1500.00),
(2, 108, 1, 7500.00), (2, 109, 1, 1200.00),
(3, 107, 3, 2500.00);

INSERT INTO detalle_pedido VALUES 
(4, 102, 4, 6200.00), (4, 104, 2, 4500.00), (4, 105, 3, 2800.00),
(5, 110, 2, 6800.00), (5, 103, 4, 1500.00);

INSERT INTO detalle_pedido VALUES 
(6, 108, 2, 7500.00), (6, 109, 2, 1200.00),
(7, 101, 1, 8500.00), (7, 105, 1, 2800.00);

INSERT INTO detalle_pedido VALUES 
(8, 110, 3, 6800.00),
(9, 102, 2, 6200.00), (9, 104, 1, 4500.00);

INSERT INTO detalle_pedido VALUES 
(10, 101, 4, 8500.00), (10, 103, 4, 1500.00);

INSERT INTO detalle_pedido VALUES 
(11, 108, 3, 7500.00), (11, 110, 1, 6800.00);

UPDATE detalle_pedido 
SET cantidad = IF(MINUTE(NOW()) % 2 = 0, 5, 2) 
WHERE pedido_nro_pedido = 3 AND producto_codigo = 107;

-- Bajas correspondientes del enunciado
UPDATE producto SET activo = 0 WHERE codigo_producto = 105;
DELETE FROM producto WHERE codigo_producto = 106;

SELECT 
    pr.nombre AS Producto,
    cat.nombre_categoria AS Categoria,
    SUM(dp.cantidad) AS Total_Vendidos
FROM 
    detalle_pedido AS dp
INNER JOIN 
    producto AS pr ON dp.producto_codigo = pr.codigo_producto
INNER JOIN 
    categoria_producto AS cat ON pr.id_categoria = cat.id_categoria
GROUP BY 
    pr.codigo_producto, pr.nombre, cat.nombre_categoria
ORDER BY 
    Total_Vendidos DESC;
    
SELECT 
    m.nombre AS Nombre_Mozo,
    m.apellido AS Apellido_Mozo,
    COUNT(DISTINCT p.nro_pedido) AS Cantidad_Pedidos_Atendidos,
    IFNULL(SUM(dp.cantidad * dp.precio_unitario_cobrado), 0.00) AS Facturacion_Total
FROM 
    mozo AS m
LEFT JOIN 
    pedido AS p ON m.id_mozo = p.mozo_id_mozo AND p.estado = 'Entregado'
LEFT JOIN 
    detalle_pedido AS dp ON p.nro_pedido = dp.pedido_nro_pedido
GROUP BY 
    m.id_mozo, m.nombre, m.apellido
ORDER BY 
    Cantidad_Pedidos_Atendidos DESC, Facturacion_Total DESC;

SELECT 
    me.ubicacion AS Ubicacion_Salon,
    COUNT(DISTINCT p.nro_pedido) AS Total_Pedidos_En_Zona,
    IFNULL(SUM(dp.cantidad * dp.precio_unitario_cobrado), 0.00) AS Total_Facturado_Zona
FROM 
    mesa AS me
LEFT JOIN 
    pedido AS p ON me.id_mesa = p.mesa_id_mesa
LEFT JOIN 
    detalle_pedido AS dp ON p.nro_pedido = dp.pedido_nro_pedido
GROUP BY 
    me.ubicacion
ORDER BY 
    Total_Facturado_Zona DESC;