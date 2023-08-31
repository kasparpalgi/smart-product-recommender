CREATE OR REPLACE FUNCTION "public".recommend_products_based_on_likes(user_uuid UUID, limit_count INT)
RETURNS TABLE(product_id INT, recommendation_score FLOAT) AS $$
BEGIN
  RETURN QUERY
  WITH 
  similar_users AS (
    SELECT 
      up.user_id
    FROM "public".user_products AS up
    WHERE up.product_id IN (
      SELECT product_id FROM "public".user_products WHERE user_id = user_uuid
    )
    AND up.user_id != user_uuid
  ),
  recommendation_scores AS (
    SELECT 
      up.product_id,
      SUM(
        up.views * 0.1 + 
        CASE WHEN up."like" THEN 1 ELSE 0 END * 0.5 +
        CASE WHEN up.updated_at > current_date - interval '7 day' THEN 0.4 ELSE 0 END
      ) AS recommendation_score
    FROM "public".user_products AS up
    WHERE up.user_id IN (SELECT user_id FROM similar_users)
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
