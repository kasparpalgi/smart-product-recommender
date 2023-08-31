alter table "public"."orders" alter column "user_id" drop not null;
alter table "public"."orders" add column "user_id" int4;
