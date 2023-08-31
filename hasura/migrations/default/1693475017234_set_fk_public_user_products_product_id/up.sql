alter table "public"."user_products"
  add constraint "user_products_product_id_fkey"
  foreign key ("product_id")
  references "public"."products"
  ("id") on update restrict on delete cascade;
