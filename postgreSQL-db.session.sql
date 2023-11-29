/* GREATE DROP*/

CREATE TABLE books(
    name varchar(300),
    author varchar(300),
    type varchar(150),
    pages int,
    year date,
    publisher varchar(200)
);

DROP TABLE books;

/*
    NOT NULL - не NULL, значення вказане
    UNIQUE - унікальне поле в межах табл
    UNIQUE(first_name, last_name) - унікальна пара значень (не по одному) вказаних в дужках
    CONSTRAINT name_pair UNIQUE(first_name, last_name) - теж саме що і вище, але за допомогою CONSTRAINT дали назву name_pair  за якою потім можемо дропнути цей CONSTRAINT
    CHECK (first_name != '' - перевірь що не пустий рядок
    CHECK (birthday < current_date) - current_date поточна дата, перевіряємо зо поточна більше ніж народження 
    DEFAULT false, DEFAULT current_timestamp - значення по дефолту , якщо дані не передані
*/

/*NOT NULL UNIQUE === PRIMARY KEY */

CREATE TABLE users(
    id serial PRIMARY KEY,
    first_name varchar(100) NOT NULL CHECK (first_name != ''),
    last_name varchar(100) NOT NULL CHECK (last_name != ''),
    email varchar(100) NOT NULL UNIQUE CHECK (email != ''),
    birthday date CHECK (birthday < current_date),
    gender varchar(100) CHECK (gender != '')
);

DROP TABLE users;

/* ADD DATA */

/* add one */
INSERT INTO users (first_name, last_name, email, birthday, gender, height, weight) VALUES 
('Clark', 'Kent', 'super1@man.com', '1991-09-09', 'male', 2.0, 1);

/* add many */
INSERT INTO users (first_name, last_name, email, birthday, gender) VALUES 
('Misha', 'Mykh', 'Mykh@man.com', '1995-08-21', 'male'),
('Nika', 'Kras', 'Kras@man.com', '1996-10-14', 'female'),
('Ivan', 'Sve', 'Sve@man.com', '1995-08-24', 'male');

/* 
    numeric (точность, масштаб)
        точность - сколько всего цифр в числе
        масштаб - сколько цифр после точки
*/
ALTER TABLE users
ADD COLUMN height numeric(3, 2);

ALTER TABLE users
ADD CONSTRAINT "too_hight_user" CHECK (height < 4.0);

ALTER TABLE users
DROP CONSTRAINT "too_hight_user";

ALTER TABLE users
ADD COLUMN weight numeric(5, 2) CHECK (weight > 0);

ALTER TABLE users
ADD CONSTRAINT "yuong_user" CHECK (birthday > '1990-01-01');

ALTER TABLE users
DROP CONSTRAINT "yuong_user";

DELETE FROM users
WHERE id > 10;

ALTER TABLE users
DROP CONSTRAINT users_email_key;



-------- звязки (associations) ----------

CREATE TABLE products(
    id serial PRIMARY KEY,
    name varchar(100) NOT NULL CHECK (name != ''),
    category varchar(100),
    price numeric(10, 2) NOT NULL CHECK (price > 0),
    quantity int CHECK (quantity > 0)
);

INSERT INTO products (name, price, quantity) VALUES
('Samsung', 100, 5),
('iPhone', 500, 1),
('Sony', 200, 3);

ALTER TABLE products
ADD COLUMN model varchar(200);

ALTER TABLE products
RENAME COLUMN name TO brand;

DELETE FROM orders_to_products;

DELETE FROM products;


/* 1:m (один до багатьох, один юзер - багато замовлень) за допомогою посилання => customer_id int REFERENCES users(id)*/


DROP TABLE orders;

DELETE FROM orders;

CREATE TABLE orders(
    id serial PRIMARY KEY,
    create_at timestamp DEFAULT current_timestamp,
    customer_id int REFERENCES users(id)
);

INSERT INTO orders (customer_id) VALUES
(1), (1), (2), (1), (3);


/* m:n (багато до багатьох, багато товарів - багато замовлень) за допомогою допоміжної звязуючої таблиці => */

CREATE TABLE orders_to_products (
    product_id int REFERENCES products(id),
    order_id int REFERENCES orders(id),
    quantity int CHECK (quantity > 0),
    PRIMARY KEY (product_id, order_id)
);

INSERT INTO orders_to_products (product_id, order_id, quantity) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 1);

CREATE TABLE messages (
    id serial PRIMARY KEY,
    body text NOT NULL CHECK(body != ''),
    create_at timestamp CHECK (create_at <= current_timestamp) DEFAULT current_timestamp,
    is_read boolean NOT NULL DEFAULT false,
    chat_id int REFERENCES chats(id),
    author_id int REFERENCES users(id)
);

DROP TABLE messages;

CREATE TABLE chats (
    id serial PRIMARY KEY,
    name varchar(100) NOT NULL CHECK(name != '')
);

INSERT INTO chats (name) VALUES ('first') RETURNING *;

CREATE TABLE chats_to_users (
    chat_id int REFERENCES users(id),
    user_id int REFERENCES chats(id),
    PRIMARY KEY(chat_id, user_id)
);

/* Задача */

CREATE TABLE contents (
    id serial PRIMARY KEY,
    name varchar(200) NOT NULL CHECK (name != ''),
    description varchar(200) CHECK (name != ''),
    create_at timestamp DEFAULT current_timestamp
);

DROP TABLE contents;

CREATE TABLE contents_to_users (
    user_id int REFERENCES users(id),
    content_id int REFERENCES contents(id),
    PRIMARY KEY (user_id, content_id),
    reaction boolean DEFAULT NULL
);

DROP TABLE contents_to_users;

INSERT INTO contents (name) VALUES
('first'), ('last');

INSERT INTO contents_to_users (user_id, reaction, content_id) VALUES
(1, true, 1);


---------- 1:1 ----------- (один до одного) тренер - команда


CREATE TABLE coaches (
    id serial PRIMARY KEY,
    name varchar(300)
  --  team_id int REFERENCES teams(id)
);

CREATE TABLE teams (
    id serial PRIMARY KEY,
    name varchar(300),
    coach_id int REFERENCES coaches(id)
);

ALTER TABLE coaches
ADD COLUMN team_id int REFERENCES teams(id);

-- delete 1:1 --

ALTER TABLE coaches
DROP COLUMN team_id;

DROP TABLE teams;
DROP TABLE coaches;




----- UPDATE, DELETE----

UPDATE users
SET last_name = 'Doe';
-- всім замінило last_name = 'Doe'

UPDATE users
SET last_name = 'Kent'
WHERE id = 1;
-- змінило last_name = 'Kent'; юзеру з id 1

UPDATE users
SET weight = 60
WHERE birthday > '1990-01-01';

DELETE FROM users
WHERE id = 5;


-------- SELECT -----------


SELECT * FROM users;
--все з табл юзер

SELECT * FROM users
WHERE weight = 60;

SELECT * FROM users
WHERE birthday > '1992-01-01';

ALTER TABLE users
ADD COLUMN is_subscribe boolean;