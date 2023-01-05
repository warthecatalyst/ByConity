SELECT toDate32('2017-01-01') + INTERVAL 0 MONTH AS x;
SELECT toDate32('2017-01-01') + INTERVAL 1 MONTH AS x;
SELECT toDate32('2017-01-01') + INTERVAL 10 MONTH AS x;
SELECT toDate32('2017-01-01') + INTERVAL 100 MONTH AS x;
SELECT toDate32('2017-01-01') + INTERVAL 1000 MONTH AS x;
SELECT toDate32('2017-01-01') + INTERVAL -1 MONTH AS x;
SELECT toDate32('2017-01-01') + INTERVAL -10 MONTH AS x;
SELECT toDate32('2017-01-01') + INTERVAL -100 MONTH AS x;
SELECT toDate32('2017-01-01') + INTERVAL -1000 MONTH AS x;

SELECT toDate32('2017-01-01') - INTERVAL 0 MONTH AS x;
SELECT toDate32('2017-01-01') - INTERVAL 1 MONTH AS x;
SELECT toDate32('2017-01-01') - INTERVAL 10 MONTH AS x;
SELECT toDate32('2017-01-01') - INTERVAL 100 MONTH AS x;
SELECT toDate32('2017-01-01') - INTERVAL 1000 MONTH AS x;
SELECT toDate32('2017-01-01') - INTERVAL -1 MONTH AS x;
SELECT toDate32('2017-01-01') - INTERVAL -10 MONTH AS x;
SELECT toDate32('2017-01-01') - INTERVAL -100 MONTH AS x;
SELECT toDate32('2017-01-01') - INTERVAL -1000 MONTH AS x;

SELECT toDate32('2017-01-01') + INTERVAL 0 YEAR AS x;
SELECT toDate32('2017-01-01') + INTERVAL 1 YEAR AS x;
SELECT toDate32('2017-01-01') + INTERVAL -1 YEAR AS x;
SELECT toDate32('2017-01-01') - INTERVAL 0 YEAR AS x;
SELECT toDate32('2017-01-01') - INTERVAL 1 YEAR AS x;
SELECT toDate32('2017-01-01') - INTERVAL -1 YEAR AS x;

SELECT '----------';

SELECT toDate32('2017-01-01') + INTERVAL number - 15 DAY AS x FROM system.numbers LIMIT 30;
SELECT toDate32('2017-01-01') - INTERVAL number - 15 DAY AS x FROM system.numbers LIMIT 30;

SELECT toDate32('2017-01-01') + INTERVAL number - 15 YEAR AS x FROM system.numbers LIMIT 30;
SELECT toDate32('2017-01-01') - INTERVAL number - 15 YEAR AS x FROM system.numbers LIMIT 30;
