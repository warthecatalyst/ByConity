SET output_format_write_statistics = 0;
SELECT p_date, type_id, user_level, user_number, spot_one_name, spot_one_user_number, spot_two_name, spot_two_user_number, spot_three_name, spot_three_user_number FROM mct.business_app_user_touch_spot_5a_daily WHERE ( p_date = '2021-07-17' AND  user_level = 15 AND  type_id IN (10055) AND  type = 'outer_account') ORDER BY spot_one_user_number DESC SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact