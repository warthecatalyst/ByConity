SELECT `p_date` AS `p_date` FROM `cnch_alpha_lq_audit_arm`.`user_info_v2_encrypt` GROUP BY `p_date` ORDER BY `p_date` DESC LIMIT 1 SETTINGS enable_optimize_predicate_expression=0,distributed_product_mode='global'
