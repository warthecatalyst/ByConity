CREATE DATABASE IF NOT EXISTS aeolus_data_db_aeolus_delta_202005;
DROP TABLE IF EXISTS aeolus_data_db_aeolus_delta_202005.aeolus_data_table_45173_prod;
CREATE TABLE aeolus_data_db_aeolus_delta_202005.aeolus_data_table_45173_prod (`row_id_kmtq3k` Int64 ,`p_date` Date ,`content_type` Nullable(String) ,`vid` Nullable(String) ,`image_mode` Nullable(String) ,`rit` Nullable(String) ,`external_action` Nullable(String) ,`landing_type` Nullable(String) ,`app_version` Nullable(String) ,`platform` Nullable(String) ,`cost` Nullable(String) ,`send` Nullable(String) ,`show` Nullable(String) ,`bid` Nullable(String) ,`click` Nullable(String) ,`convert` Nullable(String) ,`market_click_open` Nullable(String) ,`market_open_success` Nullable(String) ,`market_open_failed` Nullable(String) ,`click_start` Nullable(String) ,`click_start_detail` Nullable(String) ,`click_pause` Nullable(String) ,`click_pause_detail` Nullable(String) ,`click_continue` Nullable(String) ,`click_continue_detail` Nullable(String) ,`download_finish` Nullable(String) ,`download_failed` Nullable(String) ,`click_install` Nullable(String) ,`click_install_detail` Nullable(String) ,`install_window_show` Nullable(String) ,`download_install_finish` Nullable(String) ,`market_install_finish` Nullable(String) ,`install_failed` Nullable(String) ,`deeplink_app_open` Nullable(String) ,`deeplink_url_open` Nullable(String) ,`deeplink_url_app` Nullable(String) ,`deeplink_open_success` Nullable(String) ,`deeplink_open_fail` Nullable(String) ,`open_url_app` Nullable(String) ,`landing_open_url_app` Nullable(String) ,`open_url_appback` Nullable(String) ,`landing_open_url_appback` Nullable(String) ,`deeplink_success` Nullable(String) ,`landing_deeplink_success` Nullable(String) ,`deeplink_failed` Nullable(String) ,`landing_deeplink_failed` Nullable(String) ,`site_id` Nullable(String) ,`ad_id` Nullable(String) ,`ac` Nullable(String) ,`date` Nullable(String) ,`second_industry_name` Nullable(String) ,`advanced_creative_type` Nullable(String) ,`click_has_v3` Nullable(String) ,`first_industry_name` Nullable(String) ,`landing_page_click_start` Nullable(String) ,`refer` Nullable(String) ) ENGINE = CnchMergeTree() PARTITION BY p_date ORDER BY (`row_id_kmtq3k`,intHash64(`row_id_kmtq3k`)) SAMPLE BY intHash64(`row_id_kmtq3k`);
INSERT INTO aeolus_data_db_aeolus_delta_202005.aeolus_data_table_45173_prod FORMAT CSV INFILE '/data01/xinghe.shangguan/cnch-sql-cases/tools/certificate_builder/certificate_aeolus_delta/tables_info/aeolus_data_db_aeolus_delta_202005.aeolus_data_table_45173_prod.csv' SETTINGS input_format_skip_unknown_fields = 1, skip_nullinput_notnull_col = 1;
