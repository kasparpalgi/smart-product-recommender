alter table "public"."product_categories" drop constraint "product_categories_category_id_fkey",
  add constraint "product_categories_category_id_fkey"
  foreign key ("category_id")
  references "public"."categories"
  ("id") on update restrict on delete cascade;
