select count(order_id) as total_orders,
order_hour_of_day
from [Gold].[orders]
group by order_hour_of_day
order by total_orders desc

-----------------------------------------Peak Days & Hours---------------------------------------------
WITH hourly_orders AS (
    SELECT
        order_dow,
        order_hour_of_day,
        COUNT(order_id) AS total_orders
    FROM Gold.orders
    GROUP BY
        order_dow,
        order_hour_of_day
)
SELECT
    order_dow,
    order_hour_of_day,
    total_orders,
    SUM(total_orders) OVER (PARTITION BY order_dow) AS day_total_orders,
    CAST(
        total_orders * 100.0 / NULLIF(SUM(total_orders) OVER (PARTITION BY order_dow), 0)
        AS DECIMAL(5, 2)
    ) AS pct_of_day_orders,
    DENSE_RANK() OVER (PARTITION BY order_dow ORDER BY total_orders DESC) AS peak_rank_in_day
FROM hourly_orders
ORDER BY
    order_dow,
    order_hour_of_day;


-----------------------------------------Top Reordered Products---------------------------------------------
select top 20
p.product_id,
p.product_name,
p.department_name,
p.aisle_name,
count(*) as total_times_ordered,
sum(op.reordered) as times_reordered

from [Gold].[products] p join
[Gold].[order_products__prior] op on
p.product_id=op.product_id
where p.product_name<>'Unknown'
GROUP BY
    p.product_id,
    p.product_name,
    p.department_name,
    p.aisle_name
HAVING COUNT(*) >= 1000
ORDER BY
   
    total_times_ordered DESC;

-----------------------------------------Add-to-Cart Order Effect---------------------------------------------
WITH cart_buckets AS (
    SELECT
        CASE
            WHEN add_to_cart_order BETWEEN 1 AND 3  THEN '01 - First 3 (1-3)'
            WHEN add_to_cart_order BETWEEN 4 AND 7  THEN '02 - Early-Mid (4-7)'
            WHEN add_to_cart_order BETWEEN 8 AND 15 THEN '03 - Late-Mid (8-15)'
            ELSE '04 - Late (16+)'
        END AS cart_position_bucket,
        reordered
    FROM Gold.order_products__prior
)

SELECT
    cart_position_bucket,
    COUNT(*) AS total_items,
    SUM(CAST(reordered AS INT)) AS reordered_items,
    CAST(
        SUM(CAST(reordered AS INT)) * 100.0 / NULLIF(COUNT(*), 0)
        AS DECIMAL(5, 2)
    ) AS reorder_rate_pct
FROM cart_buckets
GROUP BY cart_position_bucket
ORDER BY cart_position_bucket;



-----------------------------------------days_since_prior_order---------------------------------------------
WITH order_level_items AS (
    SELECT
        o.order_id,
        o.days_since_prior_order,
        COUNT(*) AS basket_size,
        SUM(CAST(op.reordered AS INT)) AS reordered_items
    FROM Gold.orders o
    INNER JOIN Gold.order_products__prior op
        ON o.order_id = op.order_id
    GROUP BY
        o.order_id,
        o.days_since_prior_order
),
bucketed_orders AS (
    SELECT
        order_id,
        basket_size,
        reordered_items,
        CASE
            WHEN days_since_prior_order IS NULL       THEN '00 - First Order (NULL)'
            WHEN days_since_prior_order = 0             THEN '01 - Same Day (0)'
            WHEN days_since_prior_order BETWEEN 1 AND 7  THEN '02 - Within 1 Week (1-7)'
            WHEN days_since_prior_order BETWEEN 8 AND 14 THEN '03 - 1 to 2 Weeks (8-14)'
            WHEN days_since_prior_order BETWEEN 15 AND 21 THEN '04 - 2 to 3 Weeks (15-21)'
            WHEN days_since_prior_order BETWEEN 22 AND 30 THEN '05 - 3 to 4 Weeks (22-30)'
            ELSE '06 - Over 30 Days (30+)'
        END AS reorder_interval_bucket
    FROM order_level_items
)
SELECT
    reorder_interval_bucket,
    COUNT(order_id) AS total_orders,
    SUM(basket_size) AS total_items,
    CAST(AVG(CAST(basket_size AS FLOAT)) AS DECIMAL(6, 2)) AS avg_basket_size,
    CAST(
        SUM(reordered_items) * 100.0 / NULLIF(SUM(basket_size), 0)
        AS DECIMAL(5, 2)
    ) AS reorder_rate_pct
FROM bucketed_orders
GROUP BY reorder_interval_bucket
ORDER BY reorder_interval_bucket;




