CREATE DATABASE IF NOT EXISTS aeolus_data_db_aeolus_delta_202006;
DROP TABLE IF EXISTS aeolus_data_db_aeolus_delta_202006.aeolus_data_table_49681_prod;
CREATE TABLE aeolus_data_db_aeolus_delta_202006.aeolus_data_table_49681_prod (`row_id_kmtq3k` Int64 ,`p_date` Date ,`target_city_id` Nullable(Int64) ,`target_city` Nullable(String) ,`lead_date` Nullable(String) ,`associate_cnt` Nullable(Int64) ,`im_associate_cnt` Nullable(Int64) ,`phone_associate_cnt` Nullable(Int64) ,`report_associate_cnt` Nullable(Int64) ,`app_associate_cnt` Nullable(Int64) ,`ad_associate_cnt` Nullable(Int64) ,`toutiao_associate_cnt` Nullable(Int64) ,`douyin_associate_cnt` Nullable(Int64) ,`free_old_associate_cnt` Nullable(Int64) ,`assignment_cnt` Nullable(Int64) ,`followup_cnt` Nullable(Int64) ,`1h_followup_cnt` Nullable(Int64) ,`followup_customer_cnt` Nullable(Int64) ,`high_quality_followup_customer_cnt` Nullable(Int64) ,`realtor_id_cnt` Nullable(Int64) ,`success_associate_cnt` Nullable(Int64) ,`fee_realtor_assignment_cnt` Nullable(Int64) ,`date` Nullable(String) ) ENGINE = CnchMergeTree() PARTITION BY p_date ORDER BY (`row_id_kmtq3k`,intHash64(`row_id_kmtq3k`)) SAMPLE BY intHash64(`row_id_kmtq3k`);
INSERT INTO aeolus_data_db_aeolus_delta_202006.aeolus_data_table_49681_prod FORMAT CSV INFILE '/data01/xinghe.shangguan/cnch-sql-cases/tools/certificate_builder/certificate_aeolus_delta/tables_info/aeolus_data_db_aeolus_delta_202006.aeolus_data_table_49681_prod.csv' SETTINGS input_format_skip_unknown_fields = 1, skip_nullinput_notnull_col = 1;
