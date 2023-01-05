CREATE DATABASE IF NOT EXISTS aeolus_data_db_aeolus_delta_202003;
DROP TABLE IF EXISTS aeolus_data_db_aeolus_delta_202003.aeolus_data_table_4500_dev;
CREATE TABLE aeolus_data_db_aeolus_delta_202003.aeolus_data_table_4500_dev (`row_id_kmtq3k` Int64 ,`p_date` Date ,`行 id` Nullable(String) ,`订单 id` Nullable(String) ,`订单日期` Nullable(String) ,`发货日期` Nullable(String) ,`邮寄方式` Nullable(String) ,`客户 id` Nullable(String) ,`客户名称` Nullable(String) ,`细分` Nullable(String) ,`城市` Nullable(String) ,`省/自治区` Nullable(String) ,`国家` Nullable(String) ,`地区` Nullable(String) ,`产品 id` Nullable(String) ,`类别` Nullable(String) ,`子类别` Nullable(String) ,`产品名称` Nullable(String) ,`销售额` Nullable(Float32) ,`数量` Nullable(String) ,`折扣` Nullable(String) ,`利润` Nullable(Float32) ,`地区[aeolus_dc2f7c58_ef54_47da_9a2e_57be409bbf91]` Nullable(String) ,`地区经理` Nullable(String) ) ENGINE = CnchMergeTree() PARTITION BY p_date ORDER BY (`row_id_kmtq3k`,intHash64(`row_id_kmtq3k`)) SAMPLE BY intHash64(`row_id_kmtq3k`);
INSERT INTO aeolus_data_db_aeolus_delta_202003.aeolus_data_table_4500_dev FORMAT CSV INFILE '/data01/xinghe.shangguan/cnch-sql-cases/tools/certificate_builder/certificate_aeolus_delta/tables_info/aeolus_data_db_aeolus_delta_202003.aeolus_data_table_4500_dev.csv' SETTINGS input_format_skip_unknown_fields = 1, skip_nullinput_notnull_col = 1;
