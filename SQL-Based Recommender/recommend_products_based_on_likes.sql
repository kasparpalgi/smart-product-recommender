CREATE OR REPLACE FUNCTION recommend_products_based_on_likes(user_id INTEGER)
RETURNS TABLE(product_id INTEGER, score INTEGER) AS $$
BEGIN
  RETURN QUERY 
  SELECT p.product_id, COUNT(*) as score
  FROM user_products up
  JOIN products p ON p.product_id = up.product_id
  WHERE up.like = TRUE AND up.user_id != user_id
  AND up.product_id IN (SELECT product_id FROM user_products WHERE user_id = user_id AND like = TRUE)
  GROUP BY p.product_id
  ORDER BY score DESC
  LIMIT 3;
END;
$$ LANGUAGE plpgsql;