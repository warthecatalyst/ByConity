SET output_format_write_statistics = 0;
SELECT ad_id, ad_name, cart_id, cart_name FROM dzx.dim_business_ad WHERE ( p_date = '2021-07-16' AND  type = 1) SETTINGS enable_optimize_predicate_expression=0 FORMAT JSONCompact