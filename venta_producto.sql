SELECT item_name, item_size, count(row_id) as numero_pedidos_por_producto
FROM orders AS o
LEFT JOIN items AS i
ON o.item_id = i.item_id
group by item_name, item_size
order by numero_pedidos_por_producto DESC;