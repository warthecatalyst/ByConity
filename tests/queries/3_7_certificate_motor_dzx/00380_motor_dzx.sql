SET output_format_write_statistics = 0;
SELECT cast(activity_id as String) AS id, concat(spot_name,'-',activity_name) AS activity_name, form, cast(user_number as Int64) AS user_number, p_date AS p_date FROM mct.business_app_user_wave_crest_activity_daily WHERE ( type_id = 1123 AND industry_name = '新车' AND mold_name in ('15') AND p_date = '2021-07-12' AND form in ('ad', 'live', 'content') AND type = 'outer_series' ) ORDER BY user_number DESC LIMIT 3 SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact