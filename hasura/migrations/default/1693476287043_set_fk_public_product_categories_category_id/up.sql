alter table "public"."product_categories"
  add constraint "product_categories_category_id_fkey"
  foreign key ("category_id")
  references "public"."categories"
  ("id") on update cascade on delete cascade;
