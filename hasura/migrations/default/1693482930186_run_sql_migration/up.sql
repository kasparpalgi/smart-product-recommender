CREATE OR REPLACE FUNCTION recommend_products_based_on_likes(user_uuid UUID, limit_count INT)
RETURNS TABLE (product_id INT, recommendation_score NUMERIC) AS $$
BEGIN
  RETURN QUERY
  WITH 
  user_activity AS (
    SELECT
      product_id,
      SUM(
        views * 0.1 + 
        CASE WHEN "like" = TRUE THEN 1 ELSE 0 END * 0.5 +
        CASE WHEN updated_at > current_date - interval '7 day' THEN 0.4 ELSE 0 END
      ) AS activity_score
    FROM user_products  -- Removed schema prefix
    WHERE user_id = user_uuid
    GROUP BY product_id
  ),
  similar_users AS (
    SELECT 
      user_id,
      SUM(ua.activity_score * up.activity_score) AS similarity_score
    FROM user_products AS up  -- Removed schema prefix
    JOIN user_activity AS ua ON up.product_id = ua.product_id
    WHERE up.user_id != user_uuid
    GROUP BY user_id
    ORDER BY similarity_score DESC
    LIMIT 10
  ),
  recommendation_scores AS (
    SELECT 
      up.product_id,
      SUM(up.activity_score * su.similarity_score) AS recommendation_score
    FROM user_products AS up  -- Removed schema prefix
    JOIN similar_users AS su ON up.user_id = su.user_id
    GROUP BY up.product_id
  )
  SELECT 
    rs.product_id,
    rs.recommendation_score
  FROM recommendation_scores AS rs
  ORDER BY rs.recommendation_score DESC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE;
