-- Quiz Funnel

SELECT *
FROM survey
LIMIT 10;

SELECT question,
  COUNT(DISTINCT user_id) AS 'num_response'
FROM survey
GROUP BY 1;

-- Home Try-On Funnel

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz 'q'
LEFT JOIN home_try_on 'h'
  ON q.user_id = h.user_id
LEFT JOIN purchase 'p'
  ON p.user_id = h.user_id
LIMIT 10;

-- Overall Conversion rates Aggregating across all rows 
WITH funnel AS (
  SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz 'q'
LEFT JOIN home_try_on 'h'
  ON q.user_id = h.user_id
LEFT JOIN purchase 'p'
  ON p.user_id = h.user_id
)
SELECT COUNT(user_id) AS 'num_quiz',
  SUM(is_home_try_on) AS 'num_home_try',
  SUM(is_purchase) AS 'num_purchase'
FROM funnel;

-- Comparing Conversion from quiz to home_try_on to purhase
WITH funnel AS (
  SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz 'q'
LEFT JOIN home_try_on 'h'
  ON q.user_id = h.user_id
LEFT JOIN purchase 'p'
  ON p.user_id = h.user_id
)
SELECT
  ROUND(1.0 * SUM(is_home_try_on) / COUNT(user_id),2) AS 'quiz_to_home_try_on',
  ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on),2) AS 'home_try_on_to_purchase'
FROM funnel;

-- Difference in purhase rates between customers who had 3 number of pairs with ones who had 5
WITH funnel AS (
  SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz 'q'
LEFT JOIN home_try_on 'h'
  ON q.user_id = h.user_id
LEFT JOIN purchase 'p'
  ON p.user_id = h.user_id
)
SELECT number_of_pairs,
  ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on),2) AS 'purchase_rates'
FROM funnel
WHERE number_of_pairs IS NOT NULL
GROUP BY 1;

-- The most common results of the style quiz
SELECT style,
  COUNT(*) AS 'style_results'
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

-- The most common types of purchase made
SELECT model_name,
  COUNT(*) AS 'num_purchase'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

-- The MAX, MIN, AVG & Total Purchase made
SELECT MAX(price) AS 'max_price',
  MIN(price) AS 'min_price',
  ROUND(AVG(price),2) AS 'avg_price'
FROM purchase;