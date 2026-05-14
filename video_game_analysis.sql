-- =====================
-- GENRE SALES ANALYSIS
-- =====================
SELECT genre,
       COUNT(*) AS num_games,
       ROUND(SUM(total_sales), 2) AS total_sales_millions,
       ROUND(AVG(total_sales), 2) AS avg_sales_per_game
FROM vgsales
WHERE total_sales > 0
AND genre IS NOT NULL
GROUP BY genre
ORDER BY total_sales_millions DESC;

-- =====================
-- TOP GAMES BY CONSOLE
-- =====================
SELECT title, publisher, console,
       total_sales
FROM vgsales
WHERE total_sales > 0
ORDER BY total_sales DESC
LIMIT 50;

-- =====================
-- PUBLISHER CONSISTENCY
-- =====================
SELECT publisher,
       COUNT(*) AS num_games,
       ROUND(AVG(total_sales), 2) AS avg_sales,
       ROUND(MAX(total_sales), 2) AS best_seller,
       ROUND(MIN(total_sales), 2) AS worst_seller,
       ROUND(MAX(total_sales) - AVG(total_sales), 2) AS outlier_gap
FROM vgsales
WHERE publisher IS NOT NULL
AND publisher != 'Unknown'
AND total_sales > 0
GROUP BY publisher
HAVING COUNT(*) >= 20
AND AVG(total_sales) >= 0.5
ORDER BY avg_sales DESC
LIMIT 20;

-- =====================
-- ADDITIONAL ANALYSIS
-- =====================
-- Top 10 best sellers
SELECT title, console, total_sales
FROM vgsales
ORDER BY total_sales DESC
LIMIT 10;

-- Ultra Games deep dive
SELECT title, total_sales, console
FROM vgsales
WHERE publisher = 'Ultra Games'
ORDER BY total_sales DESC;

-- Nintendo investigation
SELECT publisher, COUNT(*) AS num_games,
ROUND(AVG(total_sales), 2) AS avg_sales
FROM vgsales
WHERE publisher = 'Nintendo'
AND total_sales > 0
GROUP BY publisher;