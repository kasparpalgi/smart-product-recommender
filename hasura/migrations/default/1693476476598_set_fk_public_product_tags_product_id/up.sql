alter table "public"."product_tags"
  add constraint "product_tags_product_id_fkey"
  foreign key ("product_id")
  references "public"."products"
  ("id") on update restrict on delete cascade;
