alter table "public"."user_products" alter column "user_id" drop not null;
alter table "public"."user_products" add column "user_id" int4;
