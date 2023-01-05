CREATE DATABASE IF NOT EXISTS dzx;
DROP TABLE IF EXISTS dzx.dwa_business_value_transpro_compare_cart_di;
CREATE TABLE dzx.dwa_business_value_transpro_compare_cart_di (`radi_sumclue_daily` Int64 ,`chance_sumclue_daily` Int64 ,`nradi_hqclue_daily` Int64 ,`nradi_sumclue_daily` Int64 ,`nchance_sumclue_daily` Int64 ,`core_hqclue_daily` Int64 ,`attriclue_daily` Int64 ,`cart_id` String ,`p_date` String ,`account_name` String ,`series_name` String ,`nhqattriclue_daily` Int64 ,`nattriclue_daily` Int64 ,`hqattriclue_daily` Int64 ,`chance_hqclue_daily` Int64 ,`core_sumclue_daily` Int64 ,`sumclue_daily` Int64 ,`radi_hqclue_daily` Int64 ,`cart_name` String ,`ncore_hqclue_daily` Int64 ,`series_id` Int64 ,`nhqclue_daily` Int64 ,`hqclue_daily` Int64 ,`account_id` Int64 ,`nsumclue_daily` Int64 ,`ncore_sumclue_daily` Int64 ,`nchance_hqclue_daily` Int64 ) ENGINE = CnchMergeTree() PARTITION BY p_date ORDER BY (series_id,cart_id,account_id,cityHash64(cart_id)) SAMPLE BY cityHash64(cart_id);
INSERT INTO dzx.dwa_business_value_transpro_compare_cart_di FORMAT CSV INFILE '/data01/liulanyi/cnch-sql-cases/tools/certificate_builder/certificate_motor_dzx/tables_info/dzx.dwa_business_value_transpro_compare_cart_di.csv' SETTINGS input_format_skip_unknown_fields = 1, skip_nullinput_notnull_col = 1;
