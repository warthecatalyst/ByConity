SET output_format_write_statistics = 0;
SELECT `assign_id` AS `assign_id`,`assign_name` AS `assign_name` FROM `data_ev_core`.`dim_banke_assign_ch` WHERE `banke_id` = toInt64('6974293913466459940') GROUP BY `assign_id`,`assign_name` SETTINGS enable_optimize_predicate_expression=0,distributed_product_mode='global' FORMAT JSONCompact