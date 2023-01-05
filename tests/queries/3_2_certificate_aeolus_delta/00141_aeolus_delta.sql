SET output_format_write_statistics = 0;
SELECT (case when toDayOfWeek(p_date)= 6 then '周末' when toDayOfWeek(p_date)= 7 then '周末' else '工作日'end) AS _1700004551800, (sum(manual_delay_time_total)/sum(valid_audit_cnt+null_valid_audit_cnt)/60) AS _1700003698790 FROM `aeolus_data_db_aeolus_delta_202002`.`aeolus_data_table_29307_prod` SAMPLE 1.0 WHERE (((((p_date >= '2021-08-04') AND (p_date <= '2021-08-10')) AND ((first_item) IS NOT NULL) AND ((case when object_category=1000115 then '鲁班落地页审核'   when object_category=1000056 then 'dsp抖音广告（新）'    when object_category=1000057 then 'dsp创建广告（新）' else    second_item end) IN (('dsp抖音广告（新）'), ('DSP抖音广告2.0'), ('dsp抖音广告'), ('DSP抖音优选'), ('DSP创建优选'), ('dsp创建广告'), ('dsp创建广告（新）'), ('拼多多RTB优选素材召回'), ('DSP创建广告2.0'), ('拼多多RTB素材召回'), ('星图Link直播组件'), ('品牌号-商家主页'), ('创意组件审核'), ('懂车帝卖车通'), ('第三方小程序'), ('建站小程序'), ('自营广告'), ('playable审核'), ('微信个人号审核'), ('线索通组件审核'), ('门店推广审核'), ('卡券审核'), ('微信公众号审核'), ('即合审核'), ('门店-团购券送审队列'), ('门店-门店审核队列'), ('星图行业锚点组件'))) AND ((case when hour in ('00','01','02','03','04','05','06','07','08','09') then '0-9' when hour in ('10','11','12','13','14','15','16','17','18','19','20','21','22','23') then '10-23' else '未知时段，请联系虞劭康' end) = ('10-23')) AND ((case when toDayOfWeek(p_date)= 6 then '周末' when toDayOfWeek(p_date)= 7 then '周末' else '工作日'end) IN (('周末'), ('工作日')))))) GROUP BY case when toDayOfWeek(p_date)= 6 then '周末' when toDayOfWeek(p_date)= 7 then '周末' else '工作日'end LIMIT 10000 FORMAT JSONCompact  SETTINGS fallback_to_stale_replicas_for_distributed_queries=0,max_replica_delay_for_distributed_queries = 1 