
DROP TABLE IF EXISTS empty;
DROP TABLE IF EXISTS data;
CREATE TABLE empty (value Int8) ENGINE = CnchMergeTree ORDER BY value;
CREATE TABLE data (value Int8) ENGINE = CnchMergeTree ORDER BY value;
INSERT INTO data SELECT * FROM empty;
SELECT * FROM data;
INSERT INTO data SELECT 1;
SELECT * FROM data;
DROP TABLE empty;
DROP TABLE data;
