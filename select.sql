--- SELECT щось FROM звідкись

SELECT * FROM users;

SELECT id, first_name, last_name FROM users;

--- Результ команди селект завжди таблиця 

SELECT * FROM users
WHERE id = 2000;

SELECT * FROM users
WHERE gender ='male';

SELECT * FROM users
WHERE gender = 'male' AND is_subscribe = true;

SELECT * FROM users
WHERE id % 2 = 0;

SELECT * FROM users
WHERE gender = 'female' AND is_subscribe = false;

SELECT email FROM users
WHERE is_subscribe = true;

-------------------

SELECT * FROM users
WHERE first_name = 'William';

SELECT * FROM users
WHERE first_name IN ('Misha', 'William', 'Clark');

SELECT * FROM users
WHERE id IN (1, 10, 100, 1000);

SELECT * FROM users
WHERE id BETWEEN 1800 AND 2000;

-------------------

--- %  - будь-яка кількість будь-яких літер
--- _ - 1 будь-який символ

SELECT * FROM users
WHERE first_name LIKE 'K%';

SELECT * FROM users
WHERE first_name LIKE '_____';

SELECT * FROM users
WHERE first_name LIKE '%a';

UPDATE users
SET weight = 60
WHERE id BETWEEN 1900 AND 1950;

UPDATE users
SET weight = 70
WHERE id % 5 = 0;

DELETE FROM users
WHERE id = 1900
RETURNING *;

---------------- extract, age

SELECT * FROM users
WHERE birthday < '2004-01-01';

SELECT first_name, age(birthday) FROM users;

SELECT first_name, extract("years" from age(birthday)) FROM users;

SELECT * FROM users
WHERE extract("years" from age(birthday)) > 25;

SELECT email FROM users
WHERE gender = 'male' AND extract("years" from age(birthday)) BETWEEN 25 AND 60;

SELECT * FROM users
WHERE extract('month' from birthday) = 10;

SELECT email FROM users
WHERE extract('month' from birthday) = 11 AND extract('day' from birthday) = 1;

UPDATE users
SET height = 2
WHERE extract("years" from age(birthday)) > 60;

UPDATE users
SET weight = 80
WHERE gender = 'male' AND extract("years" from age(birthday)) BETWEEN 30 AND 50;


--------- aliases

SELECT * FROM users;

SELECT id AS "Порядковий номер",
first_name AS "Ім'я",
last_name AS "Прізвище",
email AS "Пошта",
is_subscribe AS "Підписка"
FROM users AS u;

SELECT * FROM users AS u
WHERE u.id = 2000;


--------- pagination

SELECT * FROM users
LIMIT 10;

SELECT * FROM users
LIMIT 10 -- користувачів 10 
OFFSET 10; --відступ 10 (друга сторінка)

--вивести третю сторінку замовлень де елементів на видачу 50
SELECT * FROM orders
LIMIT 50
OFFSET 100; 


---------- об'єднати два рядки

SELECT id, first_name || ' ' || last_name AS full_name FROM users;

SELECT id, concat(first_name, ' ', last_name) AS full_name FROM users;

--1
SELECT id, concat(first_name, ' ', last_name) AS full_name FROM users
WHERE char_length(concat(first_name, ' ', last_name)) > 10;
--2
SELECT * FROM (
    SELECT id, concat(first_name, ' ', last_name) AS full_name FROM users
) AS fn
WHERE char_length(concat(fn.full_name)) > 10;


----------- Practice

/*
    Створити нову таблицю workers:
    - id,
    - name,
    - salary,
    - birthday
*/
    CREATE TABLE workers (
        id serial PRIMARY KEY,
        name varchar(200) NOT NULL CHECK(name != ''),
        salary int NOT NULL,
        birthday date CHECK (birthday < current_date)
    );

-- 1. Додайти робітника з ім'ям Олег, 90р.н., зп 300
    INSERT INTO workers (name, salary, birthday) VALUES
    ('Олег', 300, '1990-01-01');
-- 2. Додайте робітницю Ярославу, зп 1200
    INSERT INTO workers (name, salary) VALUES
    ('Ярослава', 1200);
-- 3. Додайте двох нових робітників одним запитом - Сашу 85р.н., зп 1000, і Машу 95р.н., зп 900
    INSERT INTO workers (name, salary, birthday) VALUES
    ('Cаша', 1000, '1985-01-01'), ('Маша', 900, '1995-01-01');
-- 4. Встановити Олегу зп у 500.
    UPDATE workers
    SET salary = 500
    WHERE name = 'Олег';
-- 5. Робітнику з id = 4 встановити рік народження 87
    UPDATE workers
    SET birthday = '1987-01-01'
    WHERE id = 4;
-- 6. Всім, в кого зп > 500, врізати до 700.
    UPDATE workers
    SET salary = 700
    WHERE salary > 500;
-- 7. Робітникам з 2 по 5 встановити рік народження 99
    UPDATE workers
    SET birthday = '1999-01-01'
    WHERE id BETWEEN 2 AND 5;
-- 8. Змінити Сашу на Женю і збільшити зп до 900.
    UPDATE workers
    SET salary = 900
    SET name = 'Женя'
    WHERE name = 'Cаша';

    UPDATE workers
    SET name = 'Женя'
    WHERE name = 'Cаша';
-- 9. Вибрати всіх робітників, чия зп > 400.
    SELECT * FROM workers
    WHERE salary > 400;
-- 10. Вибрати робітника з id = 4
    SELECT * FROM workers
    WHERE id = 4;
-- 11. Дізнатися зп та вік Жені.
    SELECT salary, birthday from workers
    WHERE name = 'Женя';
-- 12. Знайти робітника з ім'ям Петя.
    SELECT * FROM workers
    WHERE name = 'Петя';
-- 13. Вибрати робітників у віці 27 років або з зп > 800
    SELECT * FROM workers
    WHERE (extract("years" from age(birthday))) = 27 OR salary > 800;
-- 14. Вибрати робітників у віці від 25 до 28 років (вкл)
    SELECT * FROM workers
    WHERE extract("years" from age(birthday)) BETWEEN 25 AND 28;
-- 15. Вибрати всіх робітників, що народились у вересні
    SELECT * FROM workers
    WHERE extract ('month' from birthday) = 9;    
-- 16. Видалити робітника з id = 4
    DELETE FROM workers
    WHERE id = 4;
-- 17. Видалити Олега
    DELETE FROM workers
    WHERE name = 'Олег';
-- 18. Видалити всіх робітників старше 30 років.
    DELETE FROM workers
    WHERE extract('years' from age(birthday)) > 30;


----------- Агрегатні функції

--найбільший зріст
SELECT max(height)
FROM users;

--середній зріст
SELECT avg(height)
FROM users;

--кількість користувачів
SELECT count(*)
FROM users;

SELECT count(*)
FROM users
WHERE gender = 'female';

SELECT avg(weight)
FROM users
WHERE gender = 'male';

--------- GROUP BY

    SELECT avg(weight), gender
    FROM users
    GROUP BY gender;

    SELECT avg(weight)
    FROM users
    WHERE birthday > '2000-01-01';

    SELECT avg(weight), gender
    FROM users
    WHERE extract('year' from age(birthday)) > 25
    GROUP BY gender;

    -- Practice
    
    SELECT avg(height)
    FROM users;

    SELECT max(height), min(height), gender
    FROM users
    GROUP BY gender;

    SELECT count(*)
    FROM users
    WHERE birthday > '1999-01-01';

    SELECT count(*)
    FROM users
    WHERE first_name ILIKE 'WILLIAM';

    SELECT count(*)
    FROM users
    WHERE extract('years' from age(birthday)) BETWEEN 20 AND 30;

    SELECT count(*)
    FROM users
    WHERE height > 1.5;

    -- ILIKE игнорирует регистр (виведе всі варіанти в базі) на відміну від просто LIKE
    SELECT * FROM users
    WHERE first_name ILIKE 'WILLIAM';

    -------- Кількість замовлень кожного юзера

    SELECT count(*), customer_id
    FROM orders
    GROUP BY customer_id;

    ------- Середня ціна телефону по кожному бренду

    SELECT avg(price), brand
    FROM products
    GROUP BY brand;

    ------- Кількість телефонів на складі

    SELECT sum(quantity)
    FROM products;

    ------- Кількість проданих телефонів по кожному бренду
    
    SELECT sum(quantity)
    FROM orders_to_products;


-------------- Сортування, фільтрація--------------------
--- за збільшенням ASC (по умолчанию)--- за зменшенням DESC

----- Відсортувати юзерів за id

SELECT * FROM users
ORDER BY id ASC;

SELECT * FROM users
ORDER BY id DESC;

----- юзери по алфавиту
SELECT * FROM users
ORDER BY first_name ASC; 

SELECT * FROM users
ORDER BY height, birthday;

--- найменша кількість телефонів
SELECT * FROM products
ORDER BY quantity;

--- 5 найдорощих телефонів
SELECT * FROM products
ORDER BY quantity DESC
LIMIT 5;

/*
1. Відсортуйте користувачів за кількістю повних років (не дата народження, а кількість років), і для тих, хто має однаковий вік - за алфавітом у зворотньому порядку
2. Відсортуйте по ціні від меншого до більшого
*/

SELECT (extract('years' from age(birthday))), first_name FROM users
ORDER BY (extract('years' from age(birthday))), first_name DESC;

SELECT * FROM products
ORDER BY price;

SELECT * FROM (
    SELECT extract('years' from age(birthday)) AS age, first_name FROM users) AS fn_w_age
ORDER BY fn_w_age.age

--- количество одногодок 

SELECT extract('years' from age(birthday)) AS age, count(*) FROM users
GROUP BY extract('years' from age(birthday))
ORDER BY extract('years' from age(birthday));

SELECT count(*), age
    FROM (
        SELECT extract('years' from age(birthday)) AS age FROM users
    ) AS u_c_age
GROUP BY age
ORDER BY age;

------------ HAVING --------------
--- WHERE на уровне кортежа (строка таблици)
--- HAVING на уровне групи

SELECT count(*), age
    FROM (
        SELECT extract('years' from age(birthday)) AS age FROM users
    ) AS u_c_age
GROUP BY age
HAVING count(*) >= 5
ORDER BY age;

/*
Витягти id користувачів, які робили щонайменше 3 замовлення.
*/

SELECT count(*) AS orders, customer_id FROM orders 
GROUP BY customer_id
HAVING count(*) >= 3
ORDER BY count(*);


/*
Витягти всі бренди, в яких сума кількості телефонів на складі більше ніж 50 000
*/

SELECT sum(quantity), brand FROM products
GROUP BY brand
HAVING sum(quantity) > 50000
ORDER BY sum(quantity);


-------------Отримати дані одночасно з двох таблиць---------------


CREATE TABLE a (
    v char(3),
    t int
);

CREATE TABLE b (
    v char(3)
);

INSERT INTO a VALUES
('XXX', 1), ('XXY', 1), ('XXZ', 1),
('XYX', 2), ('XYY', 2), ('XYZ', 2),
('YXX', 3), ('YXY', 3), ('YXZ', 3);

INSERT INTO b VALUES
('ZXX'), ('XXX'), ('ZXZ'), ('YXZ'), ('YXY');

--- декартовий добуток, всі можливі пари перемноження
SELECT * FROM A, B; 


--- UNION (Об'днання) об'єднує дві таблиці (з однаковою кількістю стовбців або вказувати конкретний стовбець) в одну якщо є повторення то вони відображаютьля лише один раз
SELECT v FROM A UNION SELECT v FROM B

--- INTERSECT пересечение - відображає тільки ті варінти які повторюються в обох таблицях

SELECT v FROM a
INTERSECT
SELECT v FROM b;

--- EXCEPT віднімання (все з табл А мінус табл В) - отримуємо тільки унікальні (які не повторюються) значення з першої таблиц, без значень які повторюються в обох таблицях

SELECT v FROM a
EXCEPT
SELECT v FROM b;



INSERT INTO users (
    first_name,
    last_name,
    email,
    birthday,
    gender
  )
VALUES (
    'Test1',
    'Tester1',
    'test1@test',
    '1990-01-01',
    'male'
    ),
    (
    'Test2',
    'Tester2',
    'test2@test',
    '1990-02-02',
    'male'
    ),
    (
    'Test3',
    'Tester3',
    'test3@test',
    '1990-03-03',
    'male'
    );

SELECT * FROM users
ORDER BY id DESC;

-- id юзерів які робили замовлення
SELECT id FROM users
INTERSECT
SELECT customer_id FROM orders;

-- id юзерів які не робили замовлення
SELECT id FROM users
EXCEPT
SELECT customer_id FROM orders;

-- email юзерів які не робили замовлення

SELECT email FROM users
WHERE id IN (
    SELECT id FROM users
        EXCEPT
    SELECT customer_id FROM orders);


---------------- Соединение (JOIN) ---------------

-- результат зіставлення двох таблиць, отримали в результаті дані які повторюються в обох табл
SELECT * FROM a, b
WHERE a.v = b.v;

SELECT a.v as "id",
a.t as "price",
b.v as "phone_id"
FROM a, b
WHERE a.v = b.v;

SELECT *
FROM a JOIN b
ON a.v = b.v;

/*
Всі замовлення юзера з id 1865
*/
SELECT u.*, o.id AS order_id
FROM users AS u
JOIN orders AS O
ON o.customer_id = u.id
WHERE u.id = 1865;

/*
Всі моделі телефонів, які були куплені у замовленні номер 2510
*/

SELECT p.model
FROM orders_to_products as otp
JOIN products AS p
ON p.id = otp.product_id
WHERE otp.order_id = 2510;


------------------ JOIN ------------------

---INNER JOIN --- перехрещення
--- Все з однієї таблиці, що міститься в другій таблиці, вибране за певною умовою

SELECT u.*
FROM users AS u
JOIN orders AS O
ON o.customer_id = u.id;

----LEFT - бере всю інформацію з юзерів (навіть якщо юзери не робили замовлення) + інформація з ордерсів,  

SELECT u.*
FROM users AS u
LEFT JOIN orders AS O
ON o.customer_id = u.id;

---- RIGHT - все спільне для обох множин + те що справа не спільне

SELECT u.*
FROM users AS u
RIGHT JOIN orders AS O
ON o.customer_id = u.id;

-------LEFT OUTER-----
----Інформація про користувачів, які не робили замовлень

SELECT u.*
FROM users AS u
LEFT JOIN orders AS O
ON o.customer_id = u.id
WHERE o.id IS NULL;


------ FULL - все з обох таблиць

SELECT u.*
FROM users AS u
FULL JOIN orders AS O
ON o.customer_id = u.id;


-----------------------

/* 
Знайти id замовлень, в яких є телефони бренду Samsung
*/

SELECT otp.order_id, p.model
FROM orders_to_products AS otp
JOIN products AS p 
ON otp.product_id = p.id
WHERE p.brand = 'Samsung';

/* 
Кількість замовлень кожної моделі бренду Самсунг 
*/

SELECT p.model, count(*) AS amount
FROM orders_to_products AS otp
JOIN products AS p 
ON otp.product_id = p.id
WHERE p.brand = 'Samsung'
GROUP BY p.model;

/* 
Дізнатись email користувачів, які замовляли '22 model 19' 
*/

SELECT email 
FROM users AS u
JOIN orders AS o
ON o.customer_id = u.id
JOIN orders_to_products AS otp
ON o.id = otp.order_id
JOIN products AS p
ON otp.product_id = p.id
WHERE p.model = '22 model 19';


/*
Знайти телефони, які ніхто не купував
*/
SELECT *
FROM products AS p
JOIN orders_to_products AS otp
ON p.id = otp.product_id
WHERE otp.order_id IS NULL;

/*
Вивести id замовленнь разом з їхньою повною вартістю
(кількість*ціну телефона)
*/

SELECT otp.order_id, sum(otp.quantity * p.price) AS sum_price
FROM products AS p 
JOIN orders_to_products AS otp
ON p.id = otp.product_id
GROUP BY otp.order_id;



/*
1. Витягти всі замовлення, в яких були куплені телефони samsung
*/

SELECT otp.order_id
FROM products AS p 
JOIN orders_to_products AS otp
ON otp.product_id = product_id
WHERE p.brand = 'Samsung'
GROUP BY otp.order_id;

/*
2. Вивести мейл юзера і кількість його замовлень
*/

SELECT u.email, count(*) AS orders_quantity
FROM orders AS o
JOIN users AS u 
ON u.id = o.customer_id
GROUP BY u.email;

/*
3. Номери замовлень і кількість позицій в кожному замовленні
*/

SELECT order_id , sum(quantity)
FROM orders_to_products AS otp
GROUP BY order_id
ORDER BY order_id;

/*
4. Знайти найпопулярніший телефон (він купувався найбільшу кількість разів).
*/

SELECT p.brand, p.model, sum(otp.quantity)
FROM products AS p 
JOIN orders_to_products AS otp
ON p.id = otp.product_id
GROUP BY p.model, p.brand
ORDER BY sum(otp.quantity) DESC
LIMIT 1;

/*
1. Розрахувати середній чек всього магазину (середня вартість ВСІХ замовлень)
*/
SELECT avg(o_w_sum.order_sum) 
    FROM (
        SELECT order_id , (sum(otp.quantity * p.price)) AS order_sum
        FROM products AS p
        JOIN orders_to_products AS otp
        ON p.id = otp.product_id
        GROUP BY order_id
    ) AS o_w_sum;


/*
2. Знайти користувача, який зробив найбільшу сумму замовлень в магазині.
*/

SELECT u.*, sum(p.price * otp.quantity)
FROM users AS u
JOIN orders AS o
ON u.id = customer_id
JOIN orders_to_products AS otp
ON o.id = otp.order_id
JOIN products AS p
ON p.id = otp.product_id
GROUP BY u.id
ORDER BY sum(p.price * otp.quantity) DESC
LIMIT 1;


/*
3. Найпопулярніший бренд (сума продажів всіх екземплярів всіх моделей)
*/

SELECT p.brand, sum(otp.quantity)
FROM products AS p
JOIN orders_to_products AS otp
ON p.id = otp.product_id
GROUP BY p.brand
ORDER BY sum(otp.quantity) DESC
LIMIT 1;

SELECT * FROM products
ORDER BY brand

/*
4. Витягти всі замовлення вартістю більше середнього чека магазину
*/

-- середній чек
SELECT avg(o_w_sum.order_sum) 
    FROM (
        SELECT order_id , (sum(otp.quantity * p.price)) AS order_sum
        FROM products AS p
        JOIN orders_to_products AS otp
        ON p.id = otp.product_id
        GROUP BY order_id
    ) AS o_w_sum;

-- всі замовлення вартістю більше середнього чека магазину
SELECT *
FROM (
    SELECT order_id , (sum(otp.quantity * p.price)) AS total_sum
    FROM products AS p
    JOIN orders_to_products AS otp
    ON p.id = otp.product_id
    GROUP BY order_id
) AS o_w_sum
WHERE o_w_sum.total_sum > (
        SELECT avg(o_w_sum.order_sum) 
            FROM (
                SELECT order_id , (sum(otp.quantity * p.price)) AS order_sum
                FROM products AS p
                JOIN orders_to_products AS otp
                ON p.id = otp.product_id
                GROUP BY order_id
            ) AS o_w_sum
        )
ORDER BY o_w_sum.total_sum;

/*
WITH "псевдонім" AS (табличний вираз)
с помощью WITH ми можемо потім використовували цю табл за псевдонімом
SELECT ...
FROM "псевдонім"
*/

    WITH orders_with_costs AS (
        SELECT order_id , (sum(otp.quantity * p.price)) AS total_sum
        FROM products AS p
        JOIN orders_to_products AS otp
        ON p.id = otp.product_id
        GROUP BY order_id
    )
    SELECT owc.*
    FROM orders_with_costs AS owc
    WHERE owc.total_sum > (
        SELECT avg(o_w_sum.order_sum) 
            FROM (
                SELECT order_id , (sum(otp.quantity * p.price)) AS order_sum
                FROM products AS p
                JOIN orders_to_products AS otp
                ON p.id = otp.product_id
                GROUP BY order_id
            ) AS o_w_sum
    )
    ORDER BY owc.total_sum;
/*
5. Витягти всіх юзерів, кількість замовлень яких вище середнього
*/

-- сер кількість замовлень
SELECT avg (u_w_sum_o.sum_orders)
    FROM (
        SELECT u.id, count(*) AS sum_orders
        FROM users AS u
        JOIN orders AS o
        ON u.id = customer_id
        GROUP BY u.id
    ) as u_w_sum_o

-- всі юзери, кількість замовлень яких вище середнього

SELECT *
    FROM (
        SELECT u.id, count(*) AS total_orders
        FROM users AS u
        JOIN orders AS o
        ON u.id = customer_id
        GROUP BY u.id
    ) AS u_w_osum
WHERE u_w_osum.total_orders > (
    SELECT avg (u_w_sum_o.sum_orders)
    FROM (
        SELECT u.id, count(*) AS sum_orders
        FROM users AS u
        JOIN orders AS o
        ON u.id = customer_id
        GROUP BY u.id
    ) as u_w_sum_o
)
ORDER BY u_w_osum.total_orders;


/*
6. Витягти юзерів і кількість куплених ними моделей телефонів.
*/

SELECT u.id, count(otp.product_id)
FROM users AS u
JOIN orders AS o  
ON u.id = customer_id
JOIN orders_to_products AS otp
ON o.id = order_id
GROUP BY u.id
ORDER BY u.id;