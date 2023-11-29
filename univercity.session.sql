CREATE TABLE students (
    id serial PRIMARY KEY,
    first_name varchar(200) NOT NULL CHECK (first_name != ''),
    last_name varchar(200) NOT NULL CHECK (last_name != ''),
    group_id int REFERENCES groups(id)
);

CREATE TABLE groups (
    id serial PRIMARY KEY,
    name varchar(200) NOT NULL CHECK (name != ''),
    facultet_id int REFERENCES facultets(id)
);

CREATE TABLE facultets (
    id serial PRIMARY KEY,
    name varchar(200) NOT NULL CHECK (name != '')
);

CREATE TABLE disciplines (
    id serial PRIMARY KEY,
    name varchar(200) NOT NULL CHECK (name != ''),
    lector varchar(200) NOT NULL CHECK (name != '')
);

CREATE TABLE facultets_to_disciplines (
    facultet_id int REFERENCES facultets(id),
    discipline_id int REFERENCES disciplines(id),
    PRIMARY KEY (discipline_id, facultet_id)
);

CREATE TABLE exams (
    student_id int REFERENCES students(id),
    discipline_id int REFERENCES disciplines(id),
    PRIMARY KEY (discipline_id, student_id),
    grade int CHECK (grade > 0)
);

