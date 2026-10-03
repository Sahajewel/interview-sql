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