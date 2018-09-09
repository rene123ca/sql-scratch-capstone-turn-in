/* 1 How many campaigns and sources */
SELECT COUNT (DISTINCT utm_campaign) AS campaigns
FROM page_visits
;
SELECT COUNT (DISTINCT utm_source) AS sources
FROM page_visits
;
/* show relationship between sources and campaigns */
SELECT DISTINCT (utm_campaign ) AS campaign_title, (utm_source) AS source_title
FROM page_visits
GROUP BY 1 
ORDER BY 1 DESC
;
/* 2. Find distinct values of page_name column*/
/*Find distinct webpages on the website */
SELECT DISTINCT (page_name) AS 'COOLTShirts Unique Pages'
FROM page_visits
;
/*3 How many first touches for each campaign*/
/* Which campaigns attract users */
/* Create a subquery block */
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
   /*Group  - Source - Campaign - First time touches */
SELECT ft_attr.utm_source AS COOLTSource,
       ft_attr.utm_campaign AS COOLTCampaign,
       COUNT(*) AS 'First Touch Count'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
/*4.  Last Touch Attribution */
/* How visitors are drawn back to the website */
WITH last_touch AS (
SELECT user_id,
  MAX (timestamp) as last_touch_at
FROM page_visits
GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS COOLTSource,
       lt_attr.utm_campaign AS COOLTCampaign,
       COUNT(*) AS 'Last Touch Count'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
/* 5. How Many visitors made Purchases */
SELECT COUNT (DISTINCT user_id) AS 'Completed Purchases'
FROM page_visits
WHERE page_name = '4 - purchase'
;
 /* 6. last touches that lead to a purchase */
 /* Which Campaigns closed the sale */
WITH last_touch AS (
  SELECT user_id,
         MAX(timestamp) AS last_touch_at   			
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
  lt_attr AS (
  SELECT lt.user_id,
  			 lt.last_touch_at,
         pv.utm_source,
  			 pv.utm_campaign
 FROM last_touch AS lt
JOIN page_visits AS pv
 ON lt.user_id = pv.user_id
  AND lt.last_touch_at = pv.timestamp
  )
  SELECT lt_attr.utm_source AS COOLTSource,
  			 lt_attr.utm_campaign AS COOLTCampaign,
         COUNT (*) AS 'Last Touch Purhases'
   FROM lt_attr
   GROUP BY 1,2
   ORDER BY 3 DESC;
  