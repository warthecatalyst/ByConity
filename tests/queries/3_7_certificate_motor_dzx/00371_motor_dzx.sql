SET output_format_write_statistics = 0;
SELECT p_date AS date FROM dzx.dim_business_ad WHERE ( date <= '2021-07-14' AND  date >= '2021-06-09') ORDER BY p_date DESC LIMIT 1 SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact