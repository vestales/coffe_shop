WITH calcular_costo AS(
    select it.sku, ROUND(SUM((ing_price/ing_weight) * quantity), 3) AS costo_ing from items AS it
    LEFT JOIN recipe AS r
    ON r.recipe_id = it.sku
    LEFT JOIN ingredients AS i
    ON r.ing_id = i.ing_id
    group by sku
)SELECT DATE_FORMAT(o.created_at, '%H') as hora,
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