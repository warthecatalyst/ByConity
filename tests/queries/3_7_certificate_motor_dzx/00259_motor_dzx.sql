SET output_format_write_statistics = 0;
SELECT p_date, user_number AS score FROM mct.business_app_user_5a_trend_daily WHERE ( industry_name = '新车' AND  p_date >= '2020-06-17' AND  p_date <= '2021-07-17' AND  type = 'outer_account' AND  type_id = 10055 AND  mold_name = '15' AND  class_one_name = '每日减少用户' AND  class_two_name = '本品') ORDER BY p_date ASC SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact