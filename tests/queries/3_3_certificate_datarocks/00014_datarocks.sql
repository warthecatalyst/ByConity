SELECT `group_id` AS `group_id`,`action_type` AS `action_type`,`timestamp_ms` AS `timestamp_ms`,`action_context` AS `action_context`,`review_id` AS `review_id`,`random` AS `random`,`caller` AS `caller`,`from_node_id` AS `from_node_id`,`current_node_id` AS `current_node_id` FROM `bubble_data2`.`bubble_event2` WHERE `group_id` = 1696355752109068  AND  `action_type` IN ('prop_edit') ORDER BY `timestamp_ms` SETTINGS enable_optimize_predicate_expression=0,distributed_product_mode='global'
