-- =========================================================
-- Query: Damaged-Item Rate Within Returns, by Category
-- Purpose: Test Warehouse's theory that poor packaging/
--          damage is driving non-resellable returns
-- =========================================================

SELECT 
    p.category,
    COUNT(r.return_id) AS total_returns,                     -- Base: all returns in this category

    SUM(CASE 
            WHEN r.damaged = 'Y' THEN 1 
            ELSE 0 
        END) AS damaged_returns,                              -- CASE WHEN converts each row into 1 or 0,
                                                               -- SUM then adds them up = count of damaged returns

    ROUND(
        SUM(CASE WHEN r.damaged = 'Y' THEN 1 ELSE 0 END) * 100.0
        / COUNT(r.return_id), 
    2) AS damaged_pct

FROM Returns r
JOIN Orders o 
    ON r.order_id = o.order_id
JOIN Products p 
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY damaged_pct DESC;
