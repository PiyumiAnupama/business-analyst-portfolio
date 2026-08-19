-- =========================================================
-- Query: Return Rate by Discount Status
-- Purpose: Test the theory that discount-driven purchases
--          lead to higher return rates (Marketing's hypothesis)
-- =========================================================

SELECT 
    o.discount_applied,                                     -- Groups orders into discounted vs non-discounted
    COUNT(DISTINCT o.order_id) AS total_orders,              -- DISTINCT prevents double-counting if an order 
                                                              -- has multiple return records
    COUNT(DISTINCT r.return_id) AS total_returns,            -- COUNT on a column automatically ignores NULLs,
                                                              -- so orders with no matching return aren't counted
    ROUND(
        COUNT(DISTINCT r.return_id) * 100.0                  -- *100.0 forces decimal division, not integer division
        / COUNT(DISTINCT o.order_id), 
    2) AS return_rate_pct

FROM orders o
LEFT JOIN returns r 
    ON o.order_id = r.order_id                               -- LEFT JOIN keeps ALL orders, even ones never returned
                                                             
GROUP BY o.discount_applied;
