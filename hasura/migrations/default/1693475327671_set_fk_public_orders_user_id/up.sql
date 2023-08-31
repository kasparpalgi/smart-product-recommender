alter table "public"."orders"
  add constraint "orders_user_id_fkey"
  foreign key ("user_id")
  references "auth"."users"
  ("id") on update restrict on delete cascade;
