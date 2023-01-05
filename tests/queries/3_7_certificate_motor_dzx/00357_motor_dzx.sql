SET output_format_write_statistics = 0;
SELECT cast(activity_id as String) AS id, concat(spot_name,'-',activity_name) AS name, user_number AS cnt FROM mct.business_app_user_wave_crest_activity_daily WHERE ( type_id = 729 AND  industry_name = '新车' AND  mold_name = '15' AND  p_date = '2021-04-19' AND  form = 'ad' AND  type = 'outer_series') ORDER BY user_number DESC LIMIT 3 SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact