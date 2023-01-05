CREATE DATABASE IF NOT EXISTS aeolus_data_db_aeolus_delta_201911;
DROP TABLE IF EXISTS aeolus_data_db_aeolus_delta_201911.aeolus_data_table_12744_prod;
CREATE TABLE aeolus_data_db_aeolus_delta_201911.aeolus_data_table_12744_prod (`row_id_kmtq3k` Int64 ,`p_date` Date ,`device_id` Nullable(Int64) ,`app_version` Nullable(String) ,`channel` Nullable(String) ,`os` Nullable(String) ,`brand` Nullable(String) ,`country` Nullable(String) ,`province` Nullable(String) ,`city_level` Nullable(String) ,`district` Nullable(String) ,`session_launch` Nullable(Int32) ,`duration` Nullable(Int32) ,`p_date[dm_ed_ed_device_activation_day]` Nullable(String) ,`device_id[dm_ed_ed_illegal_user]` Nullable(String) ,`date` Nullable(String) ,`p_date[dm_ed_ed_illegal_user]` Nullable(String) ,`user_id` Nullable(String) ) ENGINE = CnchMergeTree() PARTITION BY p_date ORDER BY intHash64(`row_id_kmtq3k`) SAMPLE BY intHash64(`row_id_kmtq3k`);
INSERT INTO aeolus_data_db_aeolus_delta_201911.aeolus_data_table_12744_prod FORMAT CSV INFILE '/data01/xinghe.shangguan/cnch-sql-cases/tools/certificate_builder/certificate_aeolus_delta/tables_info/aeolus_data_db_aeolus_delta_201911.aeolus_data_table_12744_prod.csv' SETTINGS input_format_skip_unknown_fields = 1, skip_nullinput_notnull_col = 1;
