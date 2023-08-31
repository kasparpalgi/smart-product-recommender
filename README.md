# Smart product reccomender

Hasura & PostgreSQL hosted in NHost free account. Password publickly in the config file.

## Tables

### auth.users
* id - UUID, primary key, default: public.gen_random_uuid()
* display_name - Text, default: ''
* email - citext, unique, nullable
More fields... See: [auth_users.yaml](hasura/metadata/databases/default/tables/auth_users.yaml)

### default.products

* id - Integer, primary key, default: autoincrement (integer for easier testing)
* name - Text
* price - Number, default: 0
* description - Text
etc.

### default.user_products

* id - Integer, primary key, default: autoincrement
* views - Integer, default: 1 (How many times user has viewed the product)
* like - Boolean, default: false
* product_id - Integer, FK to public.products.id
* user_id - UUID, FK to auth.users.id
* created_at - Timestamp, default: now()
* updated_at - Timestamp, default: now()
  
### default.orders

* id - Integer, primary key, default: autoincrement
* user_id - UUID, FK to auth.users.id
* status - Integer, default: 1 (1 - created, 2 - paid, 3 - shipped, 4 - delivered, 5 - cancelled)
* paid_at - Timestamp, nullable
* total - Numeric, default: 0
* created_at - Timestamp, default: now()
* updated_at - Timestamp, default: now()

### default.order_items

* id - Integer, primary key, default: autoincrement
* order_id - Integer, FK to default.orders.id
* product_id - Integer, FK to default.products.id
* quantity - Numeric, default: 1
* price - Numeric, default: 0