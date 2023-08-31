First let's create a temporary table: 

```
CREATE TABLE recommended_product_temp (
  product_id INT,
  recommendation_score NUMERIC
);
```

Optionally delete it after tracking the function: `DROP TABLE recommended_product_temp;`