# Smart product reccomender

Hasura & PostgreSQL (PL/pgSQL STABLE) hosted in NHost free account. Password publickly in the config file. Another matchmaking project better explained: https://kasparlpalgi.medium.com/hasura-graphql-engine-sql-functions-unveiling-user-similarities-and-crafting-fbec7368784

## The plan

### SQL-Based Recommender

The [recommend_products_based_on_likes](<SQL-Based Recommender/recommend_products_based_on_likes.sql>) function takes a `user_uuid` and a `limit_count` as input arguments and then finds a set of recommended products for the given user based on similar users' activities by calculating recommendation scores for products based on the sum of:

* Views (multiplied by 0.1)
* Likes (multiplied by 0.5)
* Recent activity within the last 14 days (additional score of 0.4)

Steps:
1. Identify users who have interacted with the same products as the target user.
2. For each product interacted with by these similar users, a recommendation score is calculated based on views, likes, and recency.
3. Products are sorted by their recommendation score and limited to the top `limit_count`.

Next Steps:
* Add in consideration additional user-specific factors like age & locale
* Take in consideration product categories and tags
* Take in consideration products ordered
* Take in consideration products with higher profit margins, stock levels, sort order set by admins, etc.

### Collaborative Filtering & Machine Learning
For collaborative filtering, I consider to use libraries like (Surprise)[https://surpriselib.com], (scikit-learn)[https://scikit-learn.org] or similar to do the heavy lifting.

Considering machine learning models like (Neural Collaborative Filtering)[https://towardsdatascience.com/neural-collaborative-filtering-96cef1009401], [Factorization Machines](https://towardsdatascience.com/factorization-machines-for-item-recommendation-with-implicit-feedback-data-5655a7c749db), or Deep Learning models. These would take into account more complex relations and could combine content and collaborative methods. Would need to train these models on historical data and then use them to make future recommendations. Need tons of more data to train these models.

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

### default.recommended_product_table (used only by the recommend_products_based_on_likes function)
* product_id - Integer, nullable
* reccomendation_score - Numberic, nullable