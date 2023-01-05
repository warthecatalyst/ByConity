SET output_format_write_statistics = 0;
SELECT (p_date) AS _1499526, (first_item) AS _1503043, (case when object_category=1000115 then '鲁班落地页审核'   when object_category=1000056 then 'dsp抖音广告（新）'    when object_category=1000057 then 'dsp创建广告（新）' else    second_item end) AS _1503054, (case                when department like '%巡检%' then '投后巡检部'  when department like '%标注%' then '智能标注部'  when department like '%账户%' then '资质审查部'           when department like '%投后巡检%' then '投后巡检部'  when department like '%智能标注%' then '智能标注部'  when department like '%资质审查%' then '资质审查部'   when department like '%复审%' then '复审' when department like '%质检%' then '质检'  when department like '%运营支持部%' then '运营支持部' when department like '%培训部%' then '培训部'         when department like '%一部%' then '一部' when department like '%二部%' then '二部' when department like '%三部%' then '三部' when department like '%四部%' then '四部'             when department like '%1部%' then '一部' when department like '%2部%' then '二部' when department like '%3部%' then '三部'  when department like '%外部联盟部%' then '外部联盟部' when department like '%综合审查部%' then '综合审查部' when department like '%自助审查部%' then '自助审查部' when department like '%巡查治理部%' then '巡查治理部'    else substring(department,49,999) end) AS _1530874, (split(department, '-广告内容审查成都-')[2]) AS _1530891, (sum(valid_audit_cnt+null_valid_audit_cnt)) AS _1535251, (sum(manual_audit_time_total)) AS _1535073, (sum(manual_audit_time_total)/sum(valid_audit_cnt+null_valid_audit_cnt)) AS _1499544, (sum(manual_pass_cnt)/sum(valid_audit_cnt+null_valid_audit_cnt)) AS _1700003698738, (sum(manual_delay_time_total)/sum(valid_audit_cnt+null_valid_audit_cnt)/60) AS _1700003698790 FROM `aeolus_data_db_aeolus_delta_202002`.`aeolus_data_table_29307_prod` SAMPLE 1.0 WHERE (((((p_date >= '2021-08-09') AND (p_date <= '2021-08-09')) AND ((first_item) IS NOT NULL) AND ((case when object_category=1000115 then '鲁班落地页审核'   when object_category=1000056 then 'dsp抖音广告（新）'    when object_category=1000057 then 'dsp创建广告（新）' else    second_item end) = ('普通分级')) AND ((case                when department like '%巡检%' then '投后巡检部'  when department like '%标注%' then '智能标注部'  when department like '%账户%' then '资质审查部'           when department like '%投后巡检%' then '投后巡检部'  when department like '%智能标注%' then '智能标注部'  when department like '%资质审查%' then '资质审查部'   when department like '%复审%' then '复审' when department like '%质检%' then '质检'  when department like '%运营支持部%' then '运营支持部' when department like '%培训部%' then '培训部'         when department like '%一部%' then '一部' when department like '%二部%' then '二部' when department like '%三部%' then '三部' when department like '%四部%' then '四部'             when department like '%1部%' then '一部' when department like '%2部%' then '二部' when department like '%3部%' then '三部'  when department like '%外部联盟部%' then '外部联盟部' when department like '%综合审查部%' then '综合审查部' when department like '%自助审查部%' then '自助审查部' when department like '%巡查治理部%' then '巡查治理部'    else substring(department,49,999) end) IN (('�内容审查成都-行业队列4部-A组'), ('�内容审查成都-行业队列4部-B组'), ('�内容审查成都-行业队列4部-C组'), ('�内容审查成都-行业队列4部-D组')))))) GROUP BY p_date, first_item, case when object_category=1000115 then '鲁班落地页审核'   when object_category=1000056 then 'dsp抖音广告（新）'    when object_category=1000057 then 'dsp创建广告（新）' else    second_item end, case                when department like '%巡检%' then '投后巡检部'  when department like '%标注%' then '智能标注部'  when department like '%账户%' then '资质审查部'           when department like '%投后巡检%' then '投后巡检部'  when department like '%智能标注%' then '智能标注部'  when department like '%资质审查%' then '资质审查部'   when department like '%复审%' then '复审' when department like '%质检%' then '质检'  when department like '%运营支持部%' then '运营支持部' when department like '%培训部%' then '培训部'         when department like '%一部%' then '一部' when department like '%二部%' then '二部' when department like '%三部%' then '三部' when department like '%四部%' then '四部'             when department like '%1部%' then '一部' when department like '%2部%' then '二部' when department like '%3部%' then '三部'  when department like '%外部联盟部%' then '外部联盟部' when department like '%综合审查部%' then '综合审查部' when department like '%自助审查部%' then '自助审查部' when department like '%巡查治理部%' then '巡查治理部'    else substring(department,49,999) end, split(department, '-广告内容审查成都-')[2] ORDER BY _1499526 ASC LIMIT 1000 FORMAT JSONCompact  SETTINGS fallback_to_stale_replicas_for_distributed_queries=0,max_replica_delay_for_distributed_queries = 1 