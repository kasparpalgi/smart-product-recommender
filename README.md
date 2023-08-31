# Smart product reccomender

Hasura & PostgreSQL hosted in NHost free account. Password publickly in the config file.

## The plan

### SQL-Based Recommender

Improve the SQL function [recommend_products_based_on_likes.sql](<SQL-Based Recommender/recommend_products_based_on_likes.sql>)to carry out some basic recommendations. Find the top X (eg. 3-4) products that are most often bought and/or liked by users who liked/viewed/bought the same products as the current user. Finally, I should take in consideration the order/like/view date and give more weight to the more recent ones.

### Collaborative Filtering & Machine Learning
For collaborative filtering, I consider to use libraries like (Surprise)[https://surpriselib.com], (scikit-learn)[https://scikit-learn.org] or similar to do the heavy lifting.

Considering machine learning models like (Neural Collaborative Filtering)[https://towardsdatascience.com/neural-collaborative-filtering-96cef1009401], [Factorization Machines](https://towardsdatascience.com/factorization-machines-for-item-recommendation-with-implicit-feedback-data-5655a7c749db), or Deep Learning models. These would take into account more complex relations and could combine content and collaborative methods. Would need to train these models on historical data and then use them to make future recommendations. Need tons of more data to train these models.

### Content-Based Filtering
Use categories and tags of each product.

### Finally: Combining Methods
Take recommendations from each method and combine them by weighting them based on the confidence of each method.

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

### default.categories
* id - Integer, primary key, default: autoincrement
* name - Text
* parent_id - Integer, FK to default.categories.id

### default.product_categories
* id - Integer, primary key, default: autoincrement
* product_id - Integer, FK to default.products.id
* category_id - Integer, FK to default.categories.id
* sort_order - Integer, default: 0

### default.tags
* id - Integer, primary key, default: autoincrement
* name - Text

### default.product_tags
* id - Integer, primary key, default: autoincrement
* product_id - Integer, FK to default.products.id
* tag_id - Integer, FK to default.categories.id

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