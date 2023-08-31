
SET check_function_bodies = false;

CREATE TABLE "public"."products" ("id" serial NOT NULL, "name" text NOT NULL, "price" numeric NOT NULL DEFAULT 0, "description" text NOT NULL, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), PRIMARY KEY ("id") );
CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_products_updated_at"
BEFORE UPDATE ON "public"."products"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_products_updated_at" ON "public"."products"
IS 'trigger to set value of column "updated_at" to current timestamp on row update';

CREATE TABLE "public"."user_products" ("id" serial NOT NULL, "views" integer NOT NULL DEFAULT 0, "like" boolean NOT NULL DEFAULT false, PRIMARY KEY ("id") );

comment on column "public"."user_products"."views" is E'How many times user has viewed the product';

alter table "public"."user_products" add column "user_id" integer
 not null;

alter table "public"."user_products" add column "product_id" integer
 not null;

alter table "public"."user_products" drop column "user_id" cascade;

alter table "public"."user_products"
  add constraint "user_products_product_id_fkey"
  foreign key ("product_id")
  references "public"."products"
  ("id") on update restrict on delete cascade;

alter table "public"."user_products" add column "user_id" uuid
 not null;

alter table "public"."user_products"
  add constraint "user_products_user_id_fkey"
  foreign key ("user_id")
  references "auth"."users"
  ("id") on update restrict on delete cascade;

alter table "public"."user_products" add column "created_at" timestamptz
 null default now();

alter table "public"."user_products" add column "updated_at" timestamptz
 null default now();

CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_user_products_updated_at"
BEFORE UPDATE ON "public"."user_products"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_user_products_updated_at" ON "public"."user_products"
IS 'trigger to set value of column "updated_at" to current timestamp on row update';

CREATE TABLE "public"."orders" ("id" serial NOT NULL, "user_id" integer NOT NULL, PRIMARY KEY ("id") );

alter table "public"."orders" drop column "user_id" cascade;

alter table "public"."orders" add column "user_id" uuid
 null;

alter table "public"."orders"
  add constraint "orders_user_id_fkey"
  foreign key ("user_id")
  references "auth"."users"
  ("id") on update restrict on delete cascade;

alter table "public"."orders" add column "status" integer
 not null default '1';

comment on column "public"."orders"."status" is E'1 - created, 2 - paid, 3 - shipped, 4 - delivered, 5 - cancelled';

alter table "public"."orders" add column "paid_at" timestamptz
 null;

alter table "public"."orders" add column "total" numeric
 not null default '0';

alter table "public"."orders" add column "created_at" timestamptz
 null default now();

alter table "public"."orders" add column "updated_at" timestamptz
 null default now();

CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_orders_updated_at"
BEFORE UPDATE ON "public"."orders"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_orders_updated_at" ON "public"."orders"
IS 'trigger to set value of column "updated_at" to current timestamp on row update';

CREATE TABLE "public"."order_items" ("id" serial NOT NULL, "order_id" integer NOT NULL, "product_id" integer NOT NULL, "quantity" numeric NOT NULL DEFAULT 1, "price" numeric NOT NULL DEFAULT 0, PRIMARY KEY ("id") );

alter table "public"."order_items"
  add constraint "order_items_order_id_fkey"
  foreign key ("order_id")
  references "public"."orders"
  ("id") on update restrict on delete cascade;

alter table "public"."order_items"
  add constraint "order_items_product_id_fkey"
  foreign key ("product_id")
  references "public"."products"
  ("id") on update restrict on delete cascade;

CREATE TABLE "public"."categories" ("id" serial NOT NULL, "name" text NOT NULL, "parent_id" integer NOT NULL, PRIMARY KEY ("id") );

CREATE TABLE "public"."product_categories" ("id" serial NOT NULL, "product_id" integer NOT NULL, "category_id" integer NOT NULL, "sort_order" integer NOT NULL DEFAULT 0, PRIMARY KEY ("id") );

alter table "public"."product_categories"
  add constraint "product_categories_category_id_fkey"
  foreign key ("category_id")
  references "public"."categories"
  ("id") on update cascade on delete cascade;

alter table "public"."product_categories"
  add constraint "product_categories_product_id_fkey"
  foreign key ("product_id")
  references "public"."orders"
  ("id") on update restrict on delete cascade;

CREATE TABLE "public"."tags" ("id" serial NOT NULL, "name" text NOT NULL, PRIMARY KEY ("id") );

CREATE TABLE "public"."product_tags" ("id" serial NOT NULL, "product_id" integer NOT NULL, "tag_id" integer NOT NULL, PRIMARY KEY ("id") );

alter table "public"."product_tags"
  add constraint "product_tags_product_id_fkey"
  foreign key ("product_id")
  references "public"."products"
  ("id") on update restrict on delete cascade;

alter table "public"."product_tags"
  add constraint "product_tags_tag_id_fkey"
  foreign key ("tag_id")
  references "public"."tags"
  ("id") on update restrict on delete cascade;

alter table "public"."categories" alter column "parent_id" set default '1';

alter table "public"."product_categories" drop constraint "product_categories_category_id_fkey",
  add constraint "product_categories_category_id_fkey"
  foreign key ("category_id")
  references "public"."categories"
  ("id") on update restrict on delete cascade;

alter table "public"."product_categories" drop constraint "product_categories_product_id_fkey";

alter table "public"."product_categories"
  add constraint "product_categories_product_id_fkey"
  foreign key ("product_id")
  references "public"."products"
  ("id") on update restrict on delete cascade;

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
