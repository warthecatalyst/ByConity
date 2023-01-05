CREATE DATABASE IF NOT EXISTS aeolus_data_db_aeolus_delta_202006;
DROP TABLE IF EXISTS aeolus_data_db_aeolus_delta_202006.aeolus_data_table_49198_prod;
CREATE TABLE aeolus_data_db_aeolus_delta_202006.aeolus_data_table_49198_prod (`row_id_kmtq3k` Int64 ,`p_date` Date ,`app_id` Nullable(Int64) ,`app` Nullable(String) ,`brand` Nullable(String) ,`os_api` Nullable(String) ,`app_version` Nullable(Int64) ,`is_dau` Nullable(Int64) ,`user_type` Nullable(Int64) ,`is_push_launch` Nullable(Int64) ,`fre` Nullable(String) ,`in_app_status` Nullable(String) ,`out_app_status` Nullable(String) ,`sender` Nullable(String) ,`return_next_day` Nullable(Int64) ,`all_user` Nullable(Int64) ,`send_devices` Nullable(Int64) ,`show_devices` Nullable(Int64) ,`click_devices` Nullable(Int64) ,`only_in_app_click_devices` Nullable(Int64) ,`out_app_click_devices` Nullable(Int64) ,`push_launch_devices` Nullable(Int64) ,`click_no_show_devices` Nullable(Int64) ,`send_failed_devices` Nullable(Int64) ,`badge_request_devices` Nullable(Int64) ,`badge_show_devices` Nullable(Int64) ,`badge_failed_request_devices` Nullable(Int64) ,`send_count` Nullable(Int64) ,`show_count` Nullable(Int64) ,`click_count` Nullable(Int64) ,`in_app_click_count` Nullable(Int64) ,`out_app_click_count` Nullable(Int64) ,`click_no_show_count` Nullable(Int64) ,`send_failed_count` Nullable(Int64) ,`badge_request_count` Nullable(Int64) ,`badge_show_count` Nullable(Int64) ,`badge_failed_request_count` Nullable(Int64) ,`date` Nullable(String) ) ENGINE = CnchMergeTree() PARTITION BY p_date ORDER BY (`row_id_kmtq3k`,intHash64(`row_id_kmtq3k`)) SAMPLE BY intHash64(`row_id_kmtq3k`);
INSERT INTO aeolus_data_db_aeolus_delta_202006.aeolus_data_table_49198_prod FORMAT CSV INFILE '/data01/xinghe.shangguan/cnch-sql-cases/tools/certificate_builder/certificate_aeolus_delta/tables_info/aeolus_data_db_aeolus_delta_202006.aeolus_data_table_49198_prod.csv' SETTINGS input_format_skip_unknown_fields = 1, skip_nullinput_notnull_col = 1;
