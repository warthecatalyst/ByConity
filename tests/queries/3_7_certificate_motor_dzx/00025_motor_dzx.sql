SET output_format_write_statistics = 0;
SELECT project.project_id, project.project_name, project.project_start_time, project.project_end_time, project.special_day_type, project.special_day, project.series_id, project.compete_series_ids, plan.plan_type FROM ( SELECT project_id AS project_id, project_name AS project_name, project_start_time AS project_start_time, project_end_time AS project_end_time, special_day_type AS special_day_type, sepcial_day AS special_day, series_id AS series_id, competitor AS compete_series_ids FROM dzx.motor_ad_market_project_dict WHERE ( project_id = 6974340961941852191 AND p_date = '2021-07-12' AND project_start_time <= '2021-07-12' AND is_deleted = 0 ) ORDER BY project_start_time DESC LIMIT 200 ) AS project INNER JOIN ( SELECT project_id, CASE plan_strategy WHEN 1 THEN '拉新' WHEN 2 THEN '培育' WHEN 3 THEN '收割' ELSE '' END AS plan_type FROM dzx.motor_ad_market_plan_dict WHERE ( p_date = '2021-07-12' ) ) AS plan USING (project_id) SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact