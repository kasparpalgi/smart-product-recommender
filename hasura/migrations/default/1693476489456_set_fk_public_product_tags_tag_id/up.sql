alter table "public"."product_tags"
  add constraint "product_tags_tag_id_fkey"
  foreign key ("tag_id")
  references "public"."tags"
  ("id") on update restrict on delete cascade;
