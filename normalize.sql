CREATE TABLE a(
    v char(2),
    a int
);


INSERT INTO a 
VALUES ( 'XX', 1), ('XY', 2), ('XX', 1);

SELECT * FROM a;

SELECT * FROM a
ORDER BY a.a;


INSERT INTO a VALUES (2,'tre');

DELETE FROM a
WHERE v = 'XX';

------1NF------
-- Устраните повторяющиеся группы в отдельных таблицах.
-- Создайте отдельную таблицу для каждого набора связанных данных.
-- Идентифицируйте каждый набор связанных данных с помощью первичного ключа.

ALTER TABLE a
ADD CONSTRAINT "unique_check" UNIQUE(v, a);


------2NF----
-- Создайте отдельные таблицы для наборов значений, относящихся к нескольким записям.
-- Свяжите эти таблицы с помощью внешнего ключа.


CREATE TABLE employees(
    id serial PRIMARY KEY,
    name varchar(200),
    position varchar(200),
    car_aviability boolean
);

INSERT INTO employees (name, position, car_aviability) VALUES
('John', 'HR', false),
('Jane', 'Sales', false),
('Jake', 'Developer', false),
('Andy', 'driver', true);

SELECT * FROM employees;


CREATE TABLE positions(
    name varchar(200) PRIMARY KEY,
    car_aviability boolean
);

INSERT INTO positions VALUES
('HR', false), ('Sales', false), ('Developer', false), ('driver', true);

ALTER TABLE employees
DROP COLUMN car_aviability;



ALTER TABLE employees 
ADD CONSTRAINT "position_fkey" FOREIGN KEY (position) REFERENCES
positions (name);

SELECT * FROM positions;


SELECT id, e.name, e.position, car_aviability 
FROM employees AS e
JOIN positions AS p
ON e.position = p.name;


DROP TABLE positions;
DROP TABLE employees;

---------3NF---------- 
-- Исключите поля, которые не зависят от ключа.


CREATE TABLE employees(
    id serial PRIMARY KEY,
    name varchar(200),
    department varchar(200),
    department_phone varchar(10)
);

INSERT INTO employees (name, department, department_phone) VALUES 
('John Doe', 'HR', '555-231'),
('Jane Smith', 'Sales', '23-456'),
('Andy Worhol', 'Manager', '345-567');

SELECT * FROM employees;


CREATE TABLE departments(
    name varchar(200) PRIMARY KEY,
    phone_number varchar(10)
);

ALTER TABLE employees
DROP COLUMN department_phone;

ALTER TABLE employees
ADD CONSTRAINT "department_fkey" FOREIGN KEY (department) REFERENCES
departments(name);

----------BCNF------------

/*
Завдання: є викладачі, студенти і предмети
teacher, students, subjects
Студенти ходять на предмети.
1 викладач може вести 1 предмет, але у студента може бути багато предметів.
1 предмет слухає багато студентів
teachers    1:n      students
students    m:n     subjects
teachers    1:1     subjects
*/


CREATE TABLE students
(id serial PRIMARY KEY,
    name varchar(200)
);


CREATE TABLE teachers(
    id serial PRIMARY KEY,
    name varchar(200)
);


CREATE TABLE students_to_teathers_to_subjects(
    teacher_id int REFERENCES teachers(id),
    student_id int REFERENCES students(id),
    subject varchar(32),
    PRIMARY KEY(teacher_id, student_id)
);


INSERT INTO students_to_teathers_to_subjects VALUES 
(1, 1, 'biology'),
(1, 2, 'math'),
(2, 1, 'phisics'),
(2, 2, 'math');

--->

CREATE TABLE subjects(
    name varchar(200) PRIMARY KEY
);

ALTER TABLE teachers
ADD COLUMN subject REFERENCES subjects(name);

ALTER TABLE students_to_teathers_to_subjects
DROP COLUMN subject;


--------4NF--------


/*
Ресторани (restaurants) роблять піци (pizzas).
Піци від ресторанів розвозять різні служби доставки (delivery_services)
БД для мережі ресторанів.
Багато ресторанів по всьому місту, кожен ресторан звертається до служби доставки, яка працює в конкретному районі, або районах.
Ресторан може звернутись до декількох служб доставки,
служба доставки працює в 1 або більше районах.
*/


CREATE TABLE restaurants(
    id serial PRIMARY KEY
);

CREATE TABLE delivery_services(
    id serial PRIMARY KEY
);

CREATE TABLE restaurants_to_deliveries(
    restaurant_id int REFERENCES restaurants(id),
    delivery_id int REFERENCES delivery_services(id),
    pizza_type varchar(64) NOT NULL
);


INSERT INTO restaurants_to_deliveries VALUES
(1, 1, 'pepperoni'),
(1, 1, 'sea'),
(1, 1, '4chease'),
(1, 1, 'hawaii'),
(1, 2, 'pepperoni'),
(1, 2, 'sea'),
(1, 2, 'hawaii'),
(2, 1, 'sea'),
(2, 1, 'hawaii'),
(2, 3, 'sea'),
(2, 3, 'pepperoni')
(3, 2, 'firm');


----->

CREATE TABLE pizzas(
    pizza_type varchar(64) PRIMARY KEY
);

CREATE restaurants_to_pizzas(
    restaurant_id int REFERENCES restaurants(id),
    pizza varchar REFERENCES pizzas(name)
);

ALTER TABLE restaurants_to_deliveries
DROP COLUMN pizza_type;


INSERT INTO restaurants_to_deliveries VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 2);

INSERT INTO restaurants_to_pizzas VALUES
(1, 'pepperoni'),
(1, 'sea');


/*
PRACTICE
Спроектувати БД поставки товарів.
В БД має зберігатися така інформація:
1. Про ТОВАРИ
- код товара,
- найменування товара,
- ціна товара,
2. Про ЗАМОВЛЕННЯ
- код замовлення
- найменування замовника
- адреса замовника
- телефон
- номер договору
- дата заключення договору
- найменування товару
- план поставки (шт)
3. Про фактичні ВІДГРУЗКИ товарів
- код відгрузки
- код замовлення
- дата відгрузки
- відгружено товару (шт)
При проектуванні БД необхідно врахувати наступне:
1. Товар має декілька замовлень на поставку. Замовлення відповідає 1 товару.
2. Товару можуть відповідати декілька відгрузок. У відгрузці можуть бути декілька товарів.
3. Товар не обов'язково має замовлення. Кожне замовлення обов'язково відповідає певному товару.
4. Товар не обов'язково відгружається замовнику. Кожна відгрузка обов'язково відповідає певному товару.
 
*/

CREATE TABLE products(
    product_code serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK(name != ''),
    price numeric(10, 2) NOT NULL
);

CREATE TABLE customers(
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL,
    address text NOT NULL,
    telephone varchar(20)
);

CREATE TABLE orders (
    order_code serial PRIMARY KEY,
    customer_id int REFERENCES customers(id),
    contract_number int NOT NULL,
    contract_date timestamp,
    product_id int REFERENCES products(product_code),
    quantity_plan int NOT NULL
);

CREATE TABLE shipments(
    code serial PRIMARY KEY,
    order_code int REFERENCES orders(order_code),
    shipment_date timestamp NOT NULL
);

CREATE TABLE products_to_shipments (
    product_id int REFERENCES products(product_code),
    shipment_code int REFERENCES shipments(code),
    quantity int NOT NULL,
    PRIMARY KEY (product_id, shipment_code)
);