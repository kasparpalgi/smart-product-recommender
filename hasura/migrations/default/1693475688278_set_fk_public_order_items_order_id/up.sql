alter table "public"."order_items"
  add constraint "order_items_order_id_fkey"
  foreign key ("order_id")
  references "public"."orders"
  ("id") on update restrict on delete cascade;
