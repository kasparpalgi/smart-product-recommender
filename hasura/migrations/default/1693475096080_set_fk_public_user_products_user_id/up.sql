alter table "public"."user_products"
  add constraint "user_products_user_id_fkey"
  foreign key ("user_id")
  references "auth"."users"
  ("id") on update restrict on delete cascade;
