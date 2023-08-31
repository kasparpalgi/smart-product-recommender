CREATE OR REPLACE FUNCTION recommend_products_based_on_likes(user_uuid UUID, limit_count INT)
RETURNS TABLE (product_id INT, score NUMERIC) AS $$
BEGIN
RETURN QUERY
WITH 
-- Calculate the 'activity score' for each product based on user actions.
user_activity AS (
  SELECT
    product_id,
    SUM(
      views * 0.1 + 
      CASE WHEN "like" THEN 1 ELSE 0 END * 0.5 +
      CASE WHEN updated_at > current_date - interval '7 day' THEN 0.4 ELSE 0 END
    ) AS activity_score
  FROM "default".user_products
  WHERE user_id = user_uuid
  GROUP BY product_id
),

-- Identify users who have similar tastes to the current user.
similar_users AS (
  SELECT 
    user_id,
    SUM(ua.activity_score * up.activity_score) AS similarity_score
  FROM "default".user_products AS up
  JOIN user_activity AS ua ON up.product_id = ua.product_id
  WHERE up.user_id != user_uuid
  GROUP BY user_id
  ORDER BY similarity_score DESC
  LIMIT 10
),

-- Calculate recommendation score for each product based on actions of similar users.
recommendation_scores AS (
  SELECT 
    up.product_id,
    SUM(up.activity_score * su.similarity_score) AS recommendation_score
  FROM "default".user_products AS up
  JOIN similar_users AS su ON up.user_id = su.user_id
  GROUP BY up.product_id
)

-- Return top C products sorted by recommendation score.
SELECT 
  rs.product_id,
  rs.recommendation_score
FROM recommendation_scores AS rs
ORDER BY rs.recommendation_score DESC
LIMIT limit_count;

END;
$$ LANGUAGE plpgsql;