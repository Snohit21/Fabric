-- Run against the LH_Source SQL analytics endpoint.
-- The endpoint is read-only; use it for discovery and profiling only.

-- 1. Discover actual registered source columns and SQL types.
SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('customers', 'products', 'orders', 'order_details')
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- 2. Validate expected table row counts.
SELECT 'customers' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.customers
UNION ALL
SELECT 'products', COUNT_BIG(*) FROM dbo.products
UNION ALL
SELECT 'orders', COUNT_BIG(*) FROM dbo.orders
UNION ALL
SELECT 'order_details', COUNT_BIG(*) FROM dbo.order_details;

-- 3. Check candidate primary-key nulls and duplicates.
-- Each query should return zero rows for a clean candidate key.
SELECT customer_id, COUNT_BIG(*) AS occurrences
FROM dbo.customers
GROUP BY customer_id
HAVING customer_id IS NULL OR COUNT_BIG(*) > 1;

SELECT product_id, COUNT_BIG(*) AS occurrences
FROM dbo.products
GROUP BY product_id
HAVING product_id IS NULL OR COUNT_BIG(*) > 1;

SELECT order_id, COUNT_BIG(*) AS occurrences
FROM dbo.orders
GROUP BY order_id
HAVING order_id IS NULL OR COUNT_BIG(*) > 1;

SELECT order_detail_id, COUNT_BIG(*) AS occurrences
FROM dbo.order_details
GROUP BY order_detail_id
HAVING order_detail_id IS NULL OR COUNT_BIG(*) > 1;

-- 4. Check basic referential integrity.
SELECT COUNT_BIG(*) AS orders_without_customer
FROM dbo.orders o
LEFT JOIN dbo.customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT_BIG(*) AS order_details_without_order
FROM dbo.order_details d
LEFT JOIN dbo.orders o ON o.order_id = d.order_id
WHERE o.order_id IS NULL;

SELECT COUNT_BIG(*) AS order_details_without_product
FROM dbo.order_details d
LEFT JOIN dbo.products p ON p.product_id = d.product_id
WHERE p.product_id IS NULL;
