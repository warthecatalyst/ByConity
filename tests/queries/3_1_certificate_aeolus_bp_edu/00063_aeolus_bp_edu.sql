SET output_format_write_statistics = 0;
SELECT `key_id` AS `key_id`,`key_name` AS `key_name`,`int_values` AS `int_values`,`double_values` AS `double_values` FROM `data_ev_core`.`dwm_ev_growth_common_indicator_sets_df` WHERE `date` = '20210810'  AND  `indicator_ename` = 'school_summary'  AND  `scope_name` = '学校'  AND  `module_name` = '白泽CRM' LIMIT 40000,10000 SETTINGS enable_optimize_predicate_expression=0,distributed_product_mode='global' FORMAT JSONCompact