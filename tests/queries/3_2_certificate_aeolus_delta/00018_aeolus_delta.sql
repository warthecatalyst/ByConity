SET output_format_write_statistics = 0;
SELECT (sum(valid_audit_cnt+null_valid_audit_cnt)) AS _1535251 FROM `aeolus_data_db_aeolus_delta_202002`.`aeolus_data_table_29307_prod` WHERE (((((case when object_category=1000115 then '鲁班落地页审核'   when object_category=1000056 then 'dsp抖音广告（新）'    when object_category=1000057 then 'dsp创建广告（新）' else    second_item end) = ('鲁班视频')) AND (department LIKE '%太原%') AND ((p_date >= '2021-08-05') AND (p_date <= '2021-08-09'))))) LIMIT 1000 FORMAT JSONCompact  SETTINGS fallback_to_stale_replicas_for_distributed_queries=0,max_replica_delay_for_distributed_queries = 1 