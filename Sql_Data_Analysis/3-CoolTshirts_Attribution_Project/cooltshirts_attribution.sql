-- Count of Distinct total utm campaign & sources
SELECT 
  COUNT(DISTINCT utm_campaign) AS 'total_campaign',
   COUNT(DISTINCT utm_source) AS 'total_source'
FROM page_visits;

-- Distinct utm_campaign & source showing how they are related
SELECT 
  DISTINCT utm_campaign,
  utm_source
FROM page_visits;

-- Distinct page_name
SELECT 
  DISTINCT page_name
FROM page_visits;

-- How many first touches is each campaign responsible for
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT 
    ft_attr.utm_campaign,
    COUNT(*) AS first_touch_count
FROM ft_attr
GROUP BY 1
ORDER BY 2 DESC;

-- how many last touches is each campaing responsible for
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT 
    lt_attr.utm_campaign,
    COUNT(*) AS last_touch_count
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;

-- How many visitors make a purchase
SELECT 
  COUNT(DISTINCT user_id) AS total_visitor_purchase_count
FROM page_visits
WHERE page_name = '4 - purchase';


-- how man last touches is each campaing responsible for on the purchase page
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.page_name,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT 
    lt_attr.utm_campaign,
    COUNT(*) AS purchase_last_touch_count
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;
