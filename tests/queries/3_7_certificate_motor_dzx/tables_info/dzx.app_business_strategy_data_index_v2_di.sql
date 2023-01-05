CREATE DATABASE IF NOT EXISTS dzx;
DROP TABLE IF EXISTS dzx.app_business_strategy_data_index_v2_di;
CREATE TABLE dzx.app_business_strategy_data_index_v2_di (`car_series_type` String ,`hot_content_num` Int64 ,`car_series_min_price` Float64 ,`inc_did_num` Int64 ,`car_series_energy_type` String ,`industry` String ,`rk_type` String ,`car_type` String ,`series_id` Int64 ,`res_type` String ,`p_date` String ,`series_name` String ,`rk` Int64 ,`hot_index` Float64 ,`connect_user_num` Int64 ,`car_series_max_price` Float64 ) ENGINE = CnchMergeTree() PARTITION BY (p_date,res_type) ORDER BY (series_id,intHash64(series_id)) SAMPLE BY intHash64(series_id);
INSERT INTO dzx.app_business_strategy_data_index_v2_di FORMAT CSV INFILE '/data01/liulanyi/cnch-sql-cases/tools/certificate_builder/certificate_motor_dzx/tables_info/dzx.app_business_strategy_data_index_v2_di.csv' SETTINGS input_format_skip_unknown_fields = 1, skip_nullinput_notnull_col = 1;
