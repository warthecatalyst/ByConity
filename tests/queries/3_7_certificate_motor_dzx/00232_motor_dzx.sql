SET output_format_write_statistics = 0;
SELECT cast(sum(if(emotion_tag = '正向',type_value,0)) as BIGINT) AS positive_value, cast(sum(if(emotion_tag = '中性',type_value,0)) as BIGINT) AS neutral_value, cast(sum(if(emotion_tag = '负向',type_value,0)) as BIGINT) AS negative_value, p_date FROM dzx.app_business_mental_prefro_di WHERE ( account_id = 10081 AND  series_id = 283 AND  p_date >= '2021-05-25' AND  p_date <= '2021-06-30' AND  cart_id = '6964326154866000671' AND  type = 1) GROUP BY p_date ORDER BY p_date ASC SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact