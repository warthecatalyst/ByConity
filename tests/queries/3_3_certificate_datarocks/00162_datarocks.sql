SELECT `tuwen_chushen_daya_ratio_2` AS `tuwen_chushen_daya_ratio_2`,`tuwen_fushen_daya_ratio_2` AS `tuwen_fushen_daya_ratio_2`,`weitoutiao_chushen_daya_ratio_2` AS `weitoutiao_chushen_daya_ratio_2`,`weitoutiao_fushen_daya_ratio_2` AS `weitoutiao_fushen_daya_ratio_2`,`short_video_chushen_daya_ratio_2` AS `short_video_chushen_daya_ratio_2`,`short_video_fushen_daya_ratio_2` AS `short_video_fushen_daya_ratio_2`,`wenda_chushen_daya_ratio_2` AS `wenda_chushen_daya_ratio_2`,`wenda_fushen_daya_ratio_2` AS `wenda_fushen_daya_ratio_2`,`tuwen_chushen_shanchu_ratio` AS `tuwen_chushen_shanchu_ratio`,`weitoutiao_chushen_shanchu_ratio` AS `weitoutiao_chushen_shanchu_ratio`,`wenda_chushen_shanchu_ratio` AS `wenda_chushen_shanchu_ratio`,`short_video_chushen_shanchu_ratio` AS `short_video_chushen_shanchu_ratio`,`tuwen_fawen_cnt` AS `tuwen_fawen_cnt`,`short_video_fawen_cnt` AS `short_video_fawen_cnt`,`wenda_fawen_cnt` AS `wenda_fawen_cnt`,`weitoutiao_fawen_cnt` AS `weitoutiao_fawen_cnt` FROM `content_online_cloud`.`huati__toutiao_user_tcs_daya_ratio_fully_daily_5410` WHERE (`p_date` = '20210406'  AND  `uid` = 2129095875640083) LIMIT 20 SETTINGS enable_optimize_predicate_expression=0,distributed_product_mode='global'
