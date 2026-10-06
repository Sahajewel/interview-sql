CREATE DATABASE problem_solving;
CREATE TABLE elders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO elders (name) VALUES 
('Jewel')

SELECT * FROM elders;
INSERT INTO elders (name) VALUES('Kumar'),('Saha');
SELECT * FROM elders;

CREATE TABLE check_ins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    elder_id UUID REFERENCES elders(id) ON DELETE CASCADE,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM check_ins;

SELECT elders.id,elders.name, COUNT(check_ins.id) AS check_in_count
FROM elders
LEFT JOIN check_ins ON elders.id = check_ins.elder_id AND check_ins.checked_at >= CURRENT_TIMESTAMP - INTERVAL '7 days'
GROUP BY elders.id, elders.name;

CREATE INDEX idx_check_ins_elder_checked_at ON check_ins(elder_id, checked_at DESC);

DROP INDEX idx_check_ins_elder_checked_at;
CREATE INDEX idx_check_ins_elder_checked_at ON check_ins(elder_id, checked_at );

EXPLAIN ANALYZE
SELECT * FROM check_ins
WHERE elder_id = '3f2b8c1e-9a4d-4e7b-8c21-5d6a7b8c9d0e' AND checked_at >= CURRENT_TIMESTAMP - INTERVAL '7 days';


CREATE DATABASE interview;
CREATE TABLE usersTable (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO usersTable ( name, email) 
VALUES ('Rahim', 'ramim@gmail.com');

SELECT * FROM usersTable;

CREATE TABLE elders (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

SELECT * FROM elders;

INSERT INTO elders (name)
VALUES ('Saha');

SELECT * FROM elders;

ALTER TABLE elders ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

SELECT * FROM elders;

CREATE TABLE check_ins (
    id SERIAL PRIMARY KEY,
    elders_id INT,
    FOREIGN KEY (elders_id) REFERENCES elders(id) ON DELETE CASCADE,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM check_ins;
SELECT * FROM check_ins WHERE elders_id = 1;

SELECT * FROM elders LEFT JOIN check_ins ON check_ins.elders_id=elders.id AND check_ins.checked_at >=CURRENT_TIMESTAMP - INTERVAL '7 days';

SELECT elders.id, elders.name, COUNT(check_ins.id) AS check_in_count
FROM elders
LEFT JOIN check_ins ON check_ins.elders_id = elders.id AND check_ins.checked_at >= CURRENT_TIMESTAMP - INTERVAL '7 days'
GROUP BY elders.id, elders.name
;

DROP TABLE check_ins;

DROP TABLE elders;

SELECT * FROM elders;

CREATE TABLE elders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE elders;
প্রশ্ন ১: (Mimamori প্রজেক্টের সাথে মিল রেখে)
পরিস্থিতি: users টেবিল এবং medication_logs (ওষুধ খাওয়ার লগ) টেবিল আছে।
কাজ: গত ৩০ দিনে কোনো বয়স্ক ব্যক্তি কতবার ওষুধ খেয়েছেন তা বের করতে হবে। যারা গত ৩০ দিনে একবারও ওষুধ খাননি, তাদের নামও রেজাল্টে থাকতে হবে এবং গণনার মান 0 দেখাতে হবে।

Table Schema:

users (id, name)

CREATE TABLE usersInter(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL
);
INSERT INTO usersInter(id,name) VALUES
('3f2b8c1e-9a4d-4e7b-8c21-5d6a7b8c9d0f', 'Rahim');

SELECT * FROM usersInter;

CREATE TABLE medicine_logs (
    id SERIAL PRIMARY KEY,
    user_id UUID,
    FOREIGN KEY (user_id) REFERENCES usersInter(id) ON DELETE CASCADE
);

ALTER TABLE medicine_logs ADD COLUMN taken_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
SELECT * FROM medicine_logs;

INSERT INTO medicine_logs (user_id, taken_at) VALUES 
('3f2b8c1e-9a4d-4e7b-8c21-5d6a7b8c9d0f', '2023-10-01 10:00:00' );

SELECT * FROM medicine_logs;

ALTER TABLE medicine_logs ADD COLUMN taken_at TIMEESTAMP DEFAULT CURRENT_TIMESTAMP;

SELECT usersInter.id,usersInter.name, COUNT(medicine_logs.id) AS medicine_logs_count
FROM usersInter
 JOIN medicine_logs ON medicine_logs.user_id = usersInter.id AND medicine_logs.taken_at >= NOW() - INTERVAL '30 days'
GROUP BY usersInter.id, usersInter.name;

প্রশ্ন ২: (Anshin Stay প্রজেক্টের সাথে মিল রেখে)
পরিস্থিতি: properties (বাসা/ফ্ল্যাট) এবং applications (বাসার আবেদন) টেবিল আছে।
কাজ: প্রতিটি প্রজেক্ট/ফ্ল্যাটের জন্য মোট আবেদনের সংখ্যা বের করো। কোনো ফ্ল্যাটে যদি একটিও আবেদন জমা না পড়ে থাকে, তবে সেটিও তালিকাভুক্ত হতে হবে এবং কাউন্ট 0 দেখাতে হবে।

Table Schema:

properties (id, title)

applications (id, property_id, created_at)

CREATE TABLE properties (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);
INSERT INTO properties(title) VALUES
('FLAT A'),
('FLAT B'),
('FLAT C'),
('FLAT D'),
('FLAT E');
SELECT * FROM properties;

CREATE TABLE applications(
    id SERIAL PRIMARY KEY,
    property_id INT,
    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO applications (property_id, created_at) VALUES
(1, '2023-10-01 10:00:00'),
(1, '2023-10-02 11:00:00'),
(2, '2023-10-03 12:00:00'),
(2, '2023-10-04 13:00:00'),
(2, '2023-10-05 14:00:00'),
(4, '2023-10-06 15:00:00');
SELECT * FROM applications;

SELECT properties.id, properties.title, COUNT(applications.id) AS applications_id_coint
FROM properties
 LEFT JOIN applications ON applications.property_id = properties.id 
GROUP BY properties.id, properties.title
ORDER BY properties.id
;

প্রশ্ন ৩: (Aggregate + Having সহ)
পরিস্থিতি: elders এবং check_ins টেবিল আছে।
কাজ: যেসব বয়স্ক ব্যক্তি গত ৭ দিনে ২ বারের কম (০ বার বা ১ বার) চেক-ইন করেছেন, শুধু তাদের লিস্ট বের করো (জরুরি নোটিফিকেশন পাঠানোর জন্য)।

Table Schema:

elders (id, name)

check_ins (id, elder_id, checked_at)

CREATE TABLE elders1 (
    id SERIAL PRIMARY KEY,
    name VARCHAR(10) NOT NULL
);
INSERT INTO elders1 (name) VALUES
('Rahim'),('Karims'),('Bakul'),('Mukul'),('Mahin');
SELECT * FROM elders1;

CREATE TABLE check_ins1(
    id SERIAL PRIMARY KEY,
    elders_id INT,
    FOREIGN KEY (elders_id) REFERENCES elders1(id) ON DELETE CASCADE,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO check_ins1 (elders_id, checked_at) VALUES 
(1, '2023-10-01 10:00:00'),
(1, '2023-10-02 11:00:00'),
(2, '2023-10-03 12:00:00'),
(3, '2023-10-04 13:00:00'),
(4, '2023-10-05 14:00:00'),
(5, '2023-10-06 15:00:00');
SELECT * FROM check_ins1;
SELECT elders1.id, elders1.name, COUNt(check_ins1.id) AS count_check_ins
FROM elders1
LEFT JOIN check_ins1 ON elders1.id = check_ins1.elders_id AND check_ins1.checked_at >= '2023-10-02'::DATE AND check_ins1.checked_at < '2023-10-02'::DATE + INTERVAL '7 days'
GROUP BY elders1.id, elders1.name
HAVING COUNT(check_ins1.id) <2
ORDER BY elders1.id
;


CREATE TABLE families(
    id SERIAL PRIMARY KEY,
    family_name VARCHAR(100) NOT NULL
);

INSERT INTO families (family_name) VALUES
('choudhury'),
('khan'),
('Mia'),
('bacchan'),
('debnath');

SELECT * FROM families;

CREATE TABLE elders4 (
    id SERIAL PRIMARY KEY,
    family_id INT,
    FOREIGN KEY (family_id) REFERENCES families(id) ON DELETE CASCADE,
name VARCHAR (100) NOT NULL
);


INSERT INTO elders4 (family_id, name) VALUES
(2,'Selim'),
(5,'Rajib'),
(2,'Rahim'),
(3,'Sumon');

SELECT * FROM elders4;

CREATE TABLE check_ins4 (
    id SERIAL PRIMARY KEY,
    elder_id INT,
    FOREIGN KEY(elder_id) REFERENCES elders4(id) ON DELETE CASCADE,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO check_ins4(elder_id, checked_at) VALUES 
(1,'2026-10-04 10:30:00'),
(2,'2026-10-03 12:30:00');

SELECT * FROM check_ins4;

SELECT families.id, families.family_name, COUNT(check_ins4.id) AS check_ins_count
 FROM families
LEFT JOIN elders4
 ON families.id = elders4.family_id
 LEFT JOIN check_ins4
 ON elders4.id = check_ins4.elder_id
 AND check_ins4.checked_at >= NOW() - INTERVAL '7 days'
GROUP BY families.id, families.family_name
ORDER BY families.id;

CREATE TABLE users6(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO users6(name) VALUES
('Saha'),
('Jewel'),
('Kumar'),
('Mitu'),
('Pavel');

CREATE TABLE check_ins6(
    id SERIAL PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users6(id) ON DELETE CASCADE,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO check_ins6(user_id, checked_at) VALUES 
(1,'2026-10-03 10:00:00'),
(3,'2026-10-02 11:00:00'),
(5,'2026-10-01 12:00:00'),
(1,'2026-10-02 01:00:00'),
(5,'2026-10-01 12:00:00'),
(3,'2026-10-04 02:00:00'),
(5,'2026-10-01 12:00:00'),
(2,'2026-10-01 12:00:00');

SELECT  * FROM check_ins6;

CREATE TABLE emergencies6(
    id SERIAL PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users6(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO emergencies6(user_id, created_at) VALUES 
(1, '2026-10-04 09:12:00'),
(2, '2026-10-03 08:12:30'),
(1, '2026-10-02 09:11:00'),
(3, '2026-10-01 09:12:00'),
(1, '2026-10-04 10:12:00'),
(1, '2026-10-03 08:12:00'),
(4, '2026-10-02 07:12:00');

SELECT * FROM emergencies6;

SELECT users6.id, users6.name, 
COUNT( check_ins6.id) AS check_ins_count, 
COUNT( emergencies6.id) AS cmergencies6_count 
 FROM users6
LEFT JOIN check_ins6 ON users6.id = check_ins6.user_id
LEFT JOIN emergencies6 ON users6.id = emergencies6.user_id
GROUP BY users6.id, users6.name
ORDER BY users6.id 
;
CREATE TABLE properties1 (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);
INSERT INTO properties1(title) VALUES
('Flat A'),
('Flat B'),
('Flat C'),
('Flat D'),
('Flat E'),
('Flat F');

SELECT * FROM properties1;
CREATE TABLE applications1 (
    id SERIAL PRIMARY KEY,
    property_id INT,
    FOREIGN KEY (property_id) REFERENCES properties1(id) ON DELETE CASCADE,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO applications1 (property_id, applied_at) VALUES 
(1,'2026-10-06 10:00:00'),
(2,'2026-10-02 10:00:00'),
(1,'2026-10-01 10:00:00'),
(4,'2026-09-15 10:00:00'),
(1,'2026-09-20 10:00:00'),
(1,'2026-09-25 10:00:00'),
(5,'2026-09-27 10:00:00'),
(1,'2026-09-28 10:00:00');

SELECT * FROM applications1;

SELECT p.id, p.title, COUNT(a.id) AS total_count
 FROM properties1 p
 LEFT JOIN applications1 a ON p.id = a.property_id AND a.applied_at >= NOW() - INTERVAL '30 days'
 GROUP BY p.id, p.title
 HAVING  COUNT(a.id) >2

 ;

 ALTER TABLE applications1
 ADD COLUMN status VARCHAR(20) DEFAULT 'PENDING';

SELECT * FROM applications1;
ALTER TABLE applications1
ADD COLUMN email VARCHAR(20) NOT NULL DEFAULT 'saha@gmail.com';
UPDATE applications1
SET email='maa@gmail.com'
WHERE id=1;
SELECT * FROM properties1;
ALTER TABLE applications1
RENAME COLUMN  email TO user_email;


ALTER TABLE applications1
ALTER COLUMN user_email TYPE VARCHAR(50);

SELECT id, name FROM users6;
ALTER TABLE users6
ADD COLUMN age INT;
UPDATE users6
SET age=90
Where id=5;
SELECT id, age FROM users6
ORDER BY id DESC;

SELECT id, name,age FROM users6
WHERE age>=70;


SELECT id,age FROM users6
ORDER BY age DESC
;

SELECT * FROM check_ins6;
SELECT users6.id, users6.name, COUNT(check_ins6.id) AS check_count
FROM users6
LEFT JOIN check_ins6 ON  users6.id = check_ins6.user_id
;

SELECT users6.name, check_ins6.checked_at FROM users6
JOIN check_ins6 ON users6.id = check_ins6.user_id
GROUP BY users6.name, check_ins6.checked_at;

SELECT  users6.name,COUNT(check_ins6.id) AS total_count
FROM users6
LEFT JOIN check_ins6 ON users6.id = check_ins6.user_id
GROUP BY users6.id,users6.name
ORDER BY total_count DESC;

SELECT  users6.name,COUNT(check_ins6.id) AS total_count
FROM users6
LEFT JOIN check_ins6 ON users6.id = check_ins6.user_id
GROUP BY users6.id,users6.name
HAVING COUNT(check_ins6.id) >=2;

SELECT users6.name, check_ins6.checked_at FROM users6
JOIN check_ins6 ON users6.id = check_ins6.user_id;
SELECT * FROM users6 WHERE age>=70;
SELECT * FROM users66;


 