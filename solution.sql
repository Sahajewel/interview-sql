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

