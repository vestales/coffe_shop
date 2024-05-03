select it.item_name, it.item_size, ROUND(SUM((ing_price/ing_weight) * quantity), 3) AS costo_ing from items AS it
LEFT JOIN recipe AS r
ON r.recipe_id = it.sku
LEFT JOIN ingredients AS i
ON r.ing_id = i.ing_id
group by it.item_name, it.item_size;