SET check_function_bodies = false;
INSERT INTO public.products (id, name, price, description, created_at, updated_at) VALUES (1, 'Haha Hummus', 5, ' Dip into happiness with every scoop.', '2023-08-31 10:01:11.549097+00', '2023-08-31 10:09:04.98081+00');
INSERT INTO public.products (id, name, price, description, created_at, updated_at) VALUES (2, 'Laughing Lotion', 99.5000, 'A body lotion that tickles your skin, not just your fancy!', '2023-08-31 10:09:44.91687+00', '2023-08-31 10:09:44.91687+00');
INSERT INTO public.products (id, name, price, description, created_at, updated_at) VALUES (3, 'E-book "Eat and Shut Up Manual"', 0, 'The book is the description itself', '2023-08-31 10:10:41.15447+00', '2023-08-31 10:10:41.15447+00');
INSERT INTO public.products (id, name, price, description, created_at, updated_at) VALUES (4, 'Giggly Gizmo', 23.9900, 'A gadget designed to bring joy, one beep at a time.', '2023-08-31 10:10:58.92268+00', '2023-08-31 10:10:58.92268+00');
INSERT INTO public.products (id, name, price, description, created_at, updated_at) VALUES (5, 'Lighthearted Laptop', 825, 'Computing so easy, it''s laughable.', '2023-08-31 10:11:26.074801+00', '2023-08-31 10:11:26.074801+00');
INSERT INTO public.products (id, name, price, description, created_at, updated_at) VALUES (6, 'Book "Hasura for Beginners"', 15, 'Learn from zero to hero', '2023-08-31 10:12:09.750709+00', '2023-08-31 10:12:09.750709+00');
SELECT pg_catalog.setval('public.products_id_seq', 6, true);
