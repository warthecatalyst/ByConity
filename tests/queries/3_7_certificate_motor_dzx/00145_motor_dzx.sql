SET output_format_write_statistics = 0;
SELECT p_date AS date FROM mct.business_app_user_wave_crest_activity_stats_live_daily WHERE ( date <= '2021-07-18' AND  date >= '2021-06-13') ORDER BY p_date DESC LIMIT 1 SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact