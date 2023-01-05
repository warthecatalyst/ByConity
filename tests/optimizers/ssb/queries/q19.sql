SELECT
    sum(LO_REVENUE),
    toYear(LO_ORDERDATE) AS year,
    P_BRAND
FROM lineorder_flat
WHERE P_BRAND = 'MFGR#2239' AND S_REGION = 'EUROPE'
GROUP BY
    toYear(LO_ORDERDATE),
    P_BRAND
ORDER BY
    toYear(LO_ORDERDATE),
    P_BRAND;
