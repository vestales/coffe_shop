CREATE DATABASE IF NOT EXISTS coffe_shop;

USE coffe_shop;

CREATE TABLE IF NOT EXISTS ingredients (ing_id VARCHAR(6) PRIMARY KEY, 
ing_name VARCHAR(100), 
ing_weight INT,
ing_meas VARCHAR(10),
ing_price FLOAT);

CREATE TABLE IF NOT EXISTS recipe (row_id INT PRIMARY KEY,
recipe_id VARCHAR(15),
ing_id VARCHAR(6),
quantity INT,
CONSTRAINT `fk_ing_id` FOREIGN KEY (ing_id) REFERENCES ingredients (ing_id));

CREATE TABLE IF NOT EXISTS items (item_id VARCHAR(5) PRIMARY KEY, 
sku VARCHAR(15), 
item_name VARCHAR(50),
item_cat VARCHAR(25),
item_size VARCHAR(10),
item_price FLOAT);

CREATE TABLE IF NOT EXISTS orders (row_id INT PRIMARY KEY,
orders_id VARCHAR(6),
created_at DATETIME,
item_id VARCHAR(5),
quantity INT,
cust_name VARCHAR(15),
in_or_out VARCHAR(3),
CONSTRAINT `fk_item_id` FOREIGN KEY (item_id) REFERENCES items (item_id));

select * from items;
select * from orders
order by item_id DESC;
select * from ingredients;
select * from recipe;


-- Aqui creamos una tabla temporal para calcular lo que cuesta producir un producto
CREATE TEMPORARY TABLE calcular_costo
select it.sku, ROUND(SUM((ing_price/ing_weight) * quantity), 3) AS costo_ing from items AS it
LEFT JOIN recipe AS r
ON r.recipe_id = it.sku
LEFT JOIN ingredients AS i
ON r.ing_id = i.ing_id
group by sku;

-- Aqui miramos cuantos pedidos piden, cuanto dinero ganamos, nos cuesta producirlo y las ganancias por dia
SELECT DATE_FORMAT(o.created_at, '%d') as dia,
 count(o.row_id) as numero_pedidos_por_dia , 
 ROUND(sum(item_price), 1) AS dinero_generado, 
 ROUND(sum(costo_ing), 3) AS costo_product, 
 ROUND(sum(item_price) - sum(costo_ing), 3) AS ganancia
FROM orders AS o
LEFT JOIN items AS it
ON o.item_id = it.item_id
LEFT JOIN calcular_costo AS ing
on ing.sku = it.sku
group by dia;

-- Aqui miramos cuantos pedidos piden, cuanto dinero ganamos, nos cuesta producirlo y las ganancias por hora
SELECT DATE_FORMAT(o.created_at, '%H') as hora,
 count(o.row_id) as numero_pedidos_por_dia , 
 ROUND(sum(item_price), 1) AS dinero_generado, 
 ROUND(sum(costo_ing), 3) AS costo_product, 
 ROUND(sum(item_price) - sum(costo_ing), 3) AS ganancia
FROM orders AS o
LEFT JOIN items AS it
ON o.item_id = it.item_id
LEFT JOIN calcular_costo AS ing
on ing.sku = it.sku
group by hora;

-- Aqui miramos cuantos pedidos piden, cuanto dinero ganamos, nos cuesta producirlo y las ganancias por dia y hora
SELECT DATE_FORMAT(o.created_at, '%d') as dia,
DATE_FORMAT(o.created_at, '%H') as hora,
 count(o.row_id) as numero_pedidos_por_dia , 
 ROUND(sum(item_price), 1) AS dinero_generado, 
 ROUND(sum(costo_ing), 3) AS costo_product, 
 ROUND(sum(item_price) - sum(costo_ing), 3) AS ganancia
FROM orders AS o
LEFT JOIN items AS it
ON o.item_id = it.item_id
LEFT JOIN calcular_costo AS ing
on ing.sku = it.sku
group by dia, hora;


-- Aqui miramos cuantos pedidos piden de cada producto
SELECT item_name, item_size, count(row_id) as numero_pedidos_por_producto
FROM orders AS o
LEFT JOIN items AS i
ON o.item_id = i.item_id
group by item_name, item_size
order by numero_pedidos_por_producto DESC;

-- Aqui miramos cuantos cuantos piden para llevar
SELECT in_or_out, count(row_id) as numero_pedidos_para_llevar
FROM orders
group by in_or_out;

-- Calculamos lo que cuesta hacer cada producto
select it.sku, ROUND(SUM((ing_price/ing_weight) * quantity), 3) AS costo_ing from items AS it
LEFT JOIN recipe AS r
ON r.recipe_id = it.sku
LEFT JOIN ingredients AS i
ON r.ing_id = i.ing_id
group by it.sku;


drop table orders;
drop table items;
drop table ingredients;
drop table recipe;