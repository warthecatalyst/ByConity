SET output_format_write_statistics = 0;
SELECT p_date AS date FROM dzx.dwd_business_market_influenced_customer_trend_di WHERE ( date <= '2021-07-19' AND  date >= '2021-06-14') ORDER BY p_date DESC LIMIT 1 SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact