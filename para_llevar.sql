SELECT in_or_out, count(row_id) as numero_pedidos_para_llevar
FROM orders
group by in_or_out;