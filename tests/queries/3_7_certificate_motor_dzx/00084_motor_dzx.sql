SET output_format_write_statistics = 0;
SELECT compete_account_id AS compete_id, compete_name, pk_rank FROM dzx.dim_account_pk_info_fully WHERE ( account_id = 10027 AND  p_date = '2021-07-12') ORDER BY pk_rank ASC LIMIT 5 SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact