alter table "public"."product_categories"
  add constraint "product_categories_product_id_fkey"
  foreign key ("product_id")
  references "public"."orders"
  ("id") on update restrict on delete cascade;
