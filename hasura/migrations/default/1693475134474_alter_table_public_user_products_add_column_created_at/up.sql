alter table "public"."user_products" add column "created_at" timestamptz
 null default now();
