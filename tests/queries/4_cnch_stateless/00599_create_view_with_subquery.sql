
DROP TABLE IF EXISTS test_view_00599;
DROP TABLE IF EXISTS test_00599;
CREATE TABLE test_00599(id UInt64) ENGINE = CnchMergeTree ORDER BY id;
CREATE VIEW test_view_00599 AS SELECT * FROM test_00599 WHERE id = (SELECT 1);
DETACH TABLE test_view_00599 PERMANENTLY;
ATTACH TABLE test_view_00599;
SET show_table_uuid_in_table_create_query_if_not_nil=0;
SHOW CREATE TABLE test_view_00599;
DROP TABLE IF EXISTS test_view_00599;
DROP TABLE IF EXISTS test_00599;
