SET output_format_write_statistics = 0;
SELECT sum(impr_cnt) AS impr_cnt, sum(clk_cnt) AS clk_cnt FROM dzx.dwa_traffic_perfro_compare_di WHERE ( account_id = 10073 AND  series_id = 143 AND  first_contact = '商业产品' AND  p_date >= '2021-07-08' AND  p_date <= '2021-07-14' AND  second_contact = 'dim_all' AND  third_contact = 'dim_all') LIMIT 1 SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact