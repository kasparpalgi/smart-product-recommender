First let's create a temporary table: 

```
DO $$ BEGIN
  CREATE TYPE recommended_product AS (
    product_id INT,
    recommendation_score NUMERIC
  );
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;
```

Optionally delete it after tracking the function: `DROP TABLE recommended_product_temp;`