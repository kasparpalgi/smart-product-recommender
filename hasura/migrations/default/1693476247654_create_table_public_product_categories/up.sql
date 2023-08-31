CREATE TABLE "public"."product_categories" ("id" serial NOT NULL, "product_id" integer NOT NULL, "category_id" integer NOT NULL, "sort_order" integer NOT NULL DEFAULT 0, PRIMARY KEY ("id") );
