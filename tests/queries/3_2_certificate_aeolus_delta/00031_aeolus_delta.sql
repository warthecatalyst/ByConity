SET output_format_write_statistics = 0;
SELECT (p_date) AS _1499526, (case when object_category=1000115 then '鲁班落地页审核'   when object_category=1000056 then 'dsp抖音广告（新）'    when object_category=1000057 then 'dsp创建广告（新）' else    second_item end) AS _1503054, (sum(valid_audit_cnt+null_valid_audit_cnt+non_valid_audit_cnt)) AS _1500405, (sum(valid_audit_cnt+null_valid_audit_cnt)) AS _1535251, (sum(case when department like '%成都%' then valid_audit_cnt+null_valid_audit_cnt+non_valid_audit_cnt else 0 end)) AS _1700006225743, (sum(case when department like '%合肥%' then valid_audit_cnt+null_valid_audit_cnt+non_valid_audit_cnt else 0 end)) AS _1700006225730, ((sum(case when department like '%合肥%' then valid_audit_cnt+null_valid_audit_cnt+non_valid_audit_cnt else 0 end))/(sum(valid_audit_cnt+null_valid_audit_cnt+non_valid_audit_cnt))) AS _1700006291566, (sum(manual_audit_time_total)/sum(valid_audit_cnt+null_valid_audit_cnt)) AS _1499544, (sum(case when department like '%成都%' then manual_audit_time_total else 0 end ) /sum(case when department like '%成都%' then valid_audit_cnt+null_valid_audit_cnt else 0 end )) AS _1700006225747, (sum(case when department like '%合肥%' then manual_audit_time_total else 0 end ) /sum(case when department like '%合肥%' then valid_audit_cnt+null_valid_audit_cnt else 0 end )) AS _1700006225734, (sum(manual_pass_cnt)/sum(valid_audit_cnt+null_valid_audit_cnt)) AS _1700003698738, (sum(case when department like '%成都%' then manual_pass_cnt else 0 end)/sum(case when department like '%成都%' then valid_audit_cnt+null_valid_audit_cnt else 0 end)) AS _1700006225752, (sum(case when department like '%合肥%' then manual_pass_cnt else 0 end)/sum(case when department like '%合肥%' then valid_audit_cnt+null_valid_audit_cnt else 0 end)) AS _1700006225739, (sum(manual_delay_time_total)/sum(valid_audit_cnt+null_valid_audit_cnt)/60) AS _1700003698790, (sum(case when department like '%成都%' then manual_delay_time_total else 0 end)/sum(case when department like '%成都%' then valid_audit_cnt+null_valid_audit_cnt else 0 end)/60) AS _1700006225753, (sum(case when department like '%合肥%' then manual_delay_time_total else 0 end)/sum(case when department like '%合肥%' then valid_audit_cnt+null_valid_audit_cnt else 0 end)/60) AS _1700006225740, (count(distinct staff_id)) AS _1700004760857, (count( 	distinct( 		case when department like '%成都%' then cast(staff_id,'String') else '' end 			) 			)) AS _1700006225754, (count( 	distinct( 		case when department like '%合肥%' then cast(staff_id,'String') else '' end 			) 			)) AS _1700006225741 FROM `aeolus_data_db_aeolus_delta_202002`.`aeolus_data_table_29307_prod` SAMPLE 1.0 WHERE (((((p_date >= '2021-07-28') AND (p_date <= '2021-07-30')) AND ((case when object_category=1000115 then '鲁班落地页审核'   when object_category=1000056 then 'dsp抖音广告（新）'    when object_category=1000057 then 'dsp创建广告（新）' else    second_item end) = ('游戏视频'))))) GROUP BY p_date, case when object_category=1000115 then '鲁班落地页审核'   when object_category=1000056 then 'dsp抖音广告（新）'    when object_category=1000057 then 'dsp创建广告（新）' else    second_item end ORDER BY _1503054 DESC LIMIT 1000 FORMAT JSONCompact  SETTINGS fallback_to_stale_replicas_for_distributed_queries=0,max_replica_delay_for_distributed_queries = 1 