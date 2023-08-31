
-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE OR REPLACE FUNCTION recommend_products_based_on_likes(user_uuid UUID, limit_count INT)
-- RETURNS TABLE (product_id INT, score NUMERIC) AS $$
-- BEGIN
-- RETURN QUERY
-- WITH
-- -- Calculate the 'activity score' for each product based on user actions.
-- user_activity AS (
--   SELECT
--     product_id,
--     SUM(
--       views * 0.1 +
--       CASE WHEN "like" THEN 1 ELSE 0 END * 0.5 +
--       CASE WHEN updated_at > current_date - interval '7 day' THEN 0.4 ELSE 0 END
--     ) AS activity_score
--   FROM "default".user_products
--   WHERE user_id = user_uuid
--   GROUP BY product_id
-- ),
--
-- -- Identify users who have similar tastes to the current user.
-- similar_users AS (
--   SELECT
--     user_id,
--     SUM(ua.activity_score * up.activity_score) AS similarity_score
--   FROM "default".user_products AS up
--   JOIN user_activity AS ua ON up.product_id = ua.product_id
--   WHERE up.user_id != user_uuid
--   GROUP BY user_id
--   ORDER BY similarity_score DESC
--   LIMIT 10
-- ),
--
-- -- Calculate recommendation score for each product based on actions of similar users.
-- recommendation_scores AS (
--   SELECT
--     up.product_id,
--     SUM(up.activity_score * su.similarity_score) AS recommendation_score
--   FROM "default".user_products AS up
--   JOIN similar_users AS su ON up.user_id = su.user_id
--   GROUP BY up.product_id
-- )
--
-- -- Return top C products sorted by recommendation score.
-- SELECT
--   rs.product_id,
--   rs.recommendation_score
-- FROM recommendation_scores AS rs
-- ORDER BY rs.recommendation_score DESC
-- LIMIT limit_count;
--
-- END;
-- $$ LANGUAGE plpgsql;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE OR REPLACE FUNCTION recommend_products_based_on_likes(user_uuid UUID, limit_count INT)
-- RETURNS TABLE (product_id INT, score NUMERIC) AS $$
-- BEGIN
-- RETURN QUERY
-- WITH
-- -- Calculate the 'activity score' for each product based on user actions.
-- user_activity AS (
--   SELECT
--     product_id,
--     SUM(
--       views * 0.1 +
--       CASE WHEN "like" THEN 1 ELSE 0 END * 0.5 +
--       CASE WHEN updated_at > current_date - interval '7 day' THEN 0.4 ELSE 0 END
--     ) AS activity_score
--   FROM "default".user_products
--   WHERE user_id = user_uuid
--   GROUP BY product_id
-- ),
--
-- -- Identify users who have similar tastes to the current user.
-- similar_users AS (
--   SELECT
--     user_id,
--     SUM(ua.activity_score * up.activity_score) AS similarity_score
--   FROM "default".user_products AS up
--   JOIN user_activity AS ua ON up.product_id = ua.product_id
--   WHERE up.user_id != user_uuid
--   GROUP BY user_id
--   ORDER BY similarity_score DESC
--   LIMIT 10
-- ),
--
-- -- Calculate recommendation score for each product based on actions of similar users.
-- recommendation_scores AS (
--   SELECT
--     up.product_id,
--     SUM(up.activity_score * su.similarity_score) AS recommendation_score
--   FROM "default".user_products AS up
--   JOIN similar_users AS su ON up.user_id = su.user_id
--   GROUP BY up.product_id
-- )
--
-- -- Return top C products sorted by recommendation score.
-- SELECT
--   rs.product_id,
--   rs.recommendation_score
-- FROM recommendation_scores AS rs
-- ORDER BY rs.recommendation_score DESC
-- LIMIT limit_count;
--
-- END;
-- $$ LANGUAGE plpgsql;

alter table "public"."product_categories" drop constraint "product_categories_product_id_fkey";

alter table "public"."product_categories"
  add constraint "product_categories_product_id_fkey"
  foreign key ("product_id")
  references "public"."orders"
  ("id") on update restrict on delete cascade;

alter table "public"."product_categories" drop constraint "product_categories_category_id_fkey",
  add constraint "product_categories_category_id_fkey"
  foreign key ("category_id")
  references "public"."categories"
  ("id") on update cascade on delete cascade;

ALTER TABLE "public"."categories" ALTER COLUMN "parent_id" drop default;

alter table "public"."product_tags" drop constraint "product_tags_tag_id_fkey";

alter table "public"."product_tags" drop constraint "product_tags_product_id_fkey";

DROP TABLE "public"."product_tags";

DROP TABLE "public"."tags";

alter table "public"."product_categories" drop constraint "product_categories_product_id_fkey";

alter table "public"."product_categories" drop constraint "product_categories_category_id_fkey";

DROP TABLE "public"."product_categories";

DROP TABLE "public"."categories";

alter table "public"."order_items" drop constraint "order_items_product_id_fkey";

alter table "public"."order_items" drop constraint "order_items_order_id_fkey";

DROP TABLE "public"."order_items";

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."orders" add column "updated_at" timestamptz
--  null default now();
--
-- CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
-- RETURNS TRIGGER AS $$
-- DECLARE
--   _new record;
-- BEGIN
--   _new := NEW;
--   _new."updated_at" = NOW();
--   RETURN _new;
-- END;
-- $$ LANGUAGE plpgsql;
-- CREATE TRIGGER "set_public_orders_updated_at"
-- BEFORE UPDATE ON "public"."orders"
-- FOR EACH ROW
-- EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
-- COMMENT ON TRIGGER "set_public_orders_updated_at" ON "public"."orders"
-- IS 'trigger to set value of column "updated_at" to current timestamp on row update';

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."orders" add column "created_at" timestamptz
--  null default now();

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."orders" add column "total" numeric
--  not null default '0';

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."orders" add column "paid_at" timestamptz
--  null;

comment on column "public"."orders"."status" is NULL;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."orders" add column "status" integer
--  not null default '1';

alter table "public"."orders" drop constraint "orders_user_id_fkey";

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."orders" add column "user_id" uuid
--  null;

alter table "public"."orders" alter column "user_id" drop not null;
alter table "public"."orders" add column "user_id" int4;

DROP TABLE "public"."orders";

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."user_products" add column "updated_at" timestamptz
--  null default now();
--
-- CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
-- RETURNS TRIGGER AS $$
-- DECLARE
--   _new record;
-- BEGIN
--   _new := NEW;
--   _new."updated_at" = NOW();
--   RETURN _new;
-- END;
-- $$ LANGUAGE plpgsql;
-- CREATE TRIGGER "set_public_user_products_updated_at"
-- BEFORE UPDATE ON "public"."user_products"
-- FOR EACH ROW
-- EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
-- COMMENT ON TRIGGER "set_public_user_products_updated_at" ON "public"."user_products"
-- IS 'trigger to set value of column "updated_at" to current timestamp on row update';

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."user_products" add column "created_at" timestamptz
--  null default now();

alter table "public"."user_products" drop constraint "user_products_user_id_fkey";

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."user_products" add column "user_id" uuid
--  not null;

alter table "public"."user_products" drop constraint "user_products_product_id_fkey";

alter table "public"."user_products" alter column "user_id" drop not null;
alter table "public"."user_products" add column "user_id" int4;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."user_products" add column "product_id" integer
--  not null;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."user_products" add column "user_id" integer
--  not null;

comment on column "public"."user_products"."views" is NULL;

DROP TABLE "public"."user_products";

DROP TABLE "public"."products";
