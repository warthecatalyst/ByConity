SET output_format_write_statistics = 0;
SELECT p_date AS date FROM dzx.motor_ad_market_project_dict WHERE ( date <= '2021-07-13' AND  date >= '2021-06-08') ORDER BY p_date DESC LIMIT 1 SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact