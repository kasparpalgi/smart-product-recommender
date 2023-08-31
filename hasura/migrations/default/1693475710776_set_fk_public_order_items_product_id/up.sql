alter table "public"."order_items"
  add constraint "order_items_product_id_fkey"
  foreign key ("product_id")
  references "public"."products"
  ("id") on update restrict on delete cascade;
