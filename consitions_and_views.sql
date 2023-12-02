SELECT first_name AS "Ім'я", 
    last_name AS "Прізвище"
FROM users;

-------Умовні конструкції-------


/* -----1 variant------
CASE
    WHEN condition1 = value
        THEN result1
    WHEN condition2 = value
        THEN result2
    ELSE 
        result3
END
*/

SELECT *, (
    CASE
        WHEN is_subscribe = TRUE
            THEN 'Підписаний'
        WHEN is_subscribe = FALSE
            THEN 'Не підписаний'
        ELSE 'Невідомо'
    END
)   
FROM users;

-- orders

ALTER TABLE orders
ADD COLUMN status boolean;

UPDATE orders
SET status = FALSE;

UPDATE orders
SET status = TRUE
WHERE id % 2 = 0;

UPDATE orders
SET status = TRUE
WHERE id % 3 = 0;

SELECT *, (
    CASE
        WHEN status = TRUE
            THEN 'Done'
        WHEN status = FALSE
            THEN 'Processing'
        ELSE 'New'
    END
)
FROM orders;


/* ------- 2 variant ------ */


/*
CASE  conditioanl_Value
    WHEN value1
        THEN result1
    WHEN value2
        THEN result2
    ELSE default_value
END
*/

SELECT *, (
    CASE (extract('month' from birthday))
        WHEN 1 THEN 'winter'
        WHEN 2 THEN 'winter'
        WHEN 3 THEN 'spring'
        WHEN 4 THEN 'spring'
        WHEN 5 THEN 'spring'
        WHEN 6 THEN 'summer'
        WHEN 7 THEN 'summer'
        WHEN 8 THEN 'summer'
        WHEN 9 THEN 'fall'
        WHEN 10 THEN 'fall'
        WHEN 11 THEN 'fall'
        WHEN 12 THEN 'winter'
    ELSE 'unknown'
END
) AS "birth_season"
FROM users;

/*
Витягти всю інформацію про юзерів, створити нову колонку - повнолітність.
Якщо користувачу менше ніж 18 повних років - виводити "неповнолітній",
якщо більше - вивести "повнолітній"
*/

SELECT *, (
    CASE 
        WHEN (extract('years' from age(birthday))) >= 18
            THEN 'Повнолітній'
        WHEN (extract('years' from age(birthday))) < 18
            THEN 'Не повнолітній'
        ELSE 'Невідомо'
    END
)   
FROM users;

/*
1. Вивести всі телефони, в стопці "manufacturer" вивести виробника - якщо бренд - iPhone, то вивести Apple, для всіх інших - вивести "Other"
*/
 SELECT *, (
    CASE
        WHEN brand = 'iPhone'   
            THEN 'Apple'
        ELSE 'Other'
    END
 ) AS manufacturer
 FROM products;

/*
2. Вивести всі телефони, в стопці "price_category" вивести
якщо ціна > 10 000 - flagman
ціна < 1000 - cheap
1000 > ціна < 10 000 - middle
*/
SELECT *, (
    CASE
        WHEN price > 9000
            THEN 'flagman'
        WHEN price < 1000
            THEN 'cheap'
        ELSE 'middle'
    END
) as price_category
FROM products;
/*
3. Вивести всіх користувачів та їхній статус - якщо у користувача > 3 замовлення, то він постійний клієнт,
якщо від 1 до 3 - то він активний клієнт
якщо 0 - то він новий клієнт
*/

SELECT u.*, (
    CASE
        WHEN count(*) > 3 
            THEN 'Постійний кліент'
        WHEN count(*) BETWEEN 1 AND 3
            THEN 'Активний клієнт'
        WHEN count(*) = 0
            THEN 'Новий клієнт'
        ELSE 'Не зареєстрований клієнт'
    END
) AS user_status
FROM users as u
LEFT JOIN orders as o
ON u.id = customer_id
GROUP BY u.id;


--------COALESCE----------
/*
Функция COALESCE возвращает первый попавшийся аргумент, не NULL. Если же все
аргументы равны NULL, результатом тоже будет NULL.
*/ 

SELECT id, brand, model, price, COALESCE(category, 'smartphone') AS category
FROM products;



-------GREATEST, LEAST-----

-- Функции GREATEST (виводиться хто більший) и LEAST (виводиться хто менший) выбирают наибольшее или наименьшее значение из списка выражений.

SELECT *, LEAST(price, 500) AS sale_price
FROM products;
--для тих хто дешевше 500 ставить price, для тих хто дороще ставить 500


SELECT *, GREATEST(price, 500) AS new_price
FROM products;


-----------Підзапити (подзапросы) -----------

/*   IN, NOT IN, SOME/ANY, EXISTS */

-- всі користувачі що не робили замовлень
SELECT * 
FROM users AS u
WHERE u.id NOT IN (
    SELECT o.customer_id
    FROM orders AS o
);

-- всі користувачі що робили замовлення
SELECT * 
FROM users AS u
WHERE u.id IN (
    SELECT o.customer_id
    FROM orders AS o
);

-- телефони які не купували
SELECT *
FROM products AS p
WHERE p.id NOT IN (
    SELECT otp.product_id
    FROM orders_to_products AS otp
)

---------------EXISTS-------------
--повертає true або false (існує чи не існує)

SELECT *
FROM users
WHERE id = 290;

SELECT EXISTS
    (SELECT *
    FROM users
    WHERE id = 2000);

---- Чи робив юзер 1900 хоч одне замовлення?

SELECT EXISTS
    (SELECT o.customer_id
    FROM orders AS o
    WHERE id = 1900);

SELECT u.id, u.email, (EXISTS
                        (SELECT o.customer_id
                        FROM orders AS o)) AS order_info
FROM users AS u
WHERE id = 2000;

----ANY/SOME----
---(IN)---
--Якщо хоч для якогось значення умова = true -  то повернеться true

--------------ALL--------
--Якщо для всіх рядків значення = true

-- телефони які не купували
SELECT *
FROM products AS p
WHERE p.id != ALL (
            SELECT product_id 
            FROM orders_to_products
);



--------------------------Подання (представления) - views -------------
-- Віртуальні таблиці

----- Юзери з їхньою кількістю замовлень
SELECT u.*, count(*) AS order_count
FROM users AS u
JOIN orders AS o 
ON u.id = o.customer_id
GROUP BY u.id;

CREATE VIEW users_with_order_count AS (
                                SELECT u.*, count(*) AS order_count
                                FROM users AS u
                                JOIN orders AS o 
                                ON u.id = o.customer_id
                                GROUP BY u.id
);

SELECT *
FROM users_with_order_count
WHERE order_count > 2;


-- Cпрощення запитів

/* Всі замовлення вартістю більше середнього чеку
WITH orders_with_costs AS (
    SELECT otp.order_id, sum(p.price*otp.quantity) AS total_amount
    FROM orders_to_products AS otp
    JOIN products AS p
    ON p.id = otp.product_id
    GROUP BY otp.order_id
    )
SELECT owc.*
FROM orders_with_costs AS owc
WHERE owc.total_amount > (SELECT avg(o_w_sum.order_sum)
       FROM (
            SELECT otp.order_id, sum(p.price*otp.quantity) AS order_sum
            FROM orders_to_products AS otp
            JOIN products AS p
            ON p.id = otp.product_id
            GROUP BY otp.order_id
              ) AS o_w_sum);
*/

CREATE VIEW orders_with_costs AS (
    SELECT otp.order_id, sum(p.price*otp.quantity) AS total_amount, count(*)
    FROM orders_to_products AS otp
    JOIN products AS p
    ON p.id = otp.product_id
    GROUP BY otp.order_id
);

SELECT owc.*
FROM orders_with_costs AS owc
WHERE owc.total_amount > (
    SELECT avg(total_amount)
    FROM orders_with_costs
);

/* Зробити віртуальну таблицю, яка зберігає замовлення з їхньою вартістю і кількістю замовлених моделей (product_id) */

CREATE VIEW orders_with_costs_and_model_count AS (
    SELECT o.*, sum(p.price*otp.quantity) AS order_amount, count(otp.product_id) AS order_quantity
    FROM orders AS o
    JOIN orders_to_products AS otp
    ON o.id = otp.order_id
    JOIN products AS p
    ON p.id = otp.product_id
    GROUP BY o.id
);

DROP VIEW orders_with_costs_and_model_count;

--Вивести користувачів + загальну суму всіх їхніх замовлень

SELECT u.*, sum(order_amount) AS total_order_sum
FROM users AS u
JOIN orders_with_costs_and_model_count AS owcamc
ON u.id = owcamc.customer_id
GROUP BY u.id;

---Зробити віртуальну таблицю з id, повним ім'ям (ім'я + прізвище), email, суму по всіх замовленнях

CREATE VIEW users_fullname_with_order_sum AS (
    SELECT u.id, concat(u.first_name, ' ', u.last_name) AS full_name, u.email, sum(owcamc.order_amount) AS total_order_sum
    FROM users AS u
    JOIN orders_with_costs_and_model_count AS owcamc
    ON u.id = owcamc.customer_id
    GROUP BY u.id
);


/*
1. Топ-10 юзерів, які робили найдорожчі замовлення (сума по всіх замовленнях)
*/
    SELECT * 
    FROM users_fullname_with_order_sum as ufwos
    ORDER BY ufwos.total_order_sum DESC
    LIMIT 10;
/*
2. Топ-10 юзерів, які замовляли найбільшу кількість моделей
*/
    SELECT u.*, sum(owcamc.order_quantity) AS count_models
    FROM users AS u
    JOIN orders_with_costs_and_model_count AS owcamc
    ON u.id = owcamc.customer_id
    GROUP BY u.id
    ORDER BY sum(owcamc.order_quantity) DESC
    LIMIT 10;
/*
3. Всі замовлення, в яких було замовлено більше ніж середня кількість моделей по всіх замовленнях
*/

SELECT owcamc.*
FROM orders_with_costs_and_model_count AS owcamc
WHERE owcamc.order_quantity > (
    SELECT avg (owcamc.order_quantity)
    FROM orders_with_costs_and_model_count AS owcamc
)
ORDER BY owcamc.order_quantity DESC;
