-- =========================================================
-- Query: Return Rate by Product Category
-- Purpose: Test the unconfirmed suspicion that certain 
--          categories/suppliers have disproportionately 
--          high return rates
-- =========================================================

SELECT 
    p.category,                                              -- Groups results by product category
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT r.return_id) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.return_id) * 100.0 
        / COUNT(DISTINCT o.order_id), 
    2) AS return_rate_pct

FROM Products p
JOIN Orders o 
    ON p.product_id = o.product_id                           -- Regular JOIN: every order always has a real product,
                                                              -- so no need to preserve unmatched rows here
LEFT JOIN Returns r 
    ON o.order_id = r.order_id                               -- LEFT JOIN: most orders are NOT returned, 
                                                              -- so we must keep them for an accurate denominator
GROUP BY p.category
ORDER BY return_rate_pct DESC;                                -- Surfaces the highest-risk categories first
