WITH t1 AS 
    (SELECT '1' a, '3' b, '1' c FROM dual 
    UNION ALL
    SELECT '1' a , '4' b, '2' c FROM dual 
    UNION ALL
    SELECT '2' a , '1' b, '3' c FROM dual 
    UNION ALL
    SELECT '1' a , '7' b, '4' c FROM dual
    UNION ALL
    SELECT '2' a , '6' b, '5' c FROM dual 
    UNION ALL
    SELECT '2' a , '5' b, '6' c FROM dual 
    UNION ALL
    SELECT '1' a , '8' b, '7' c FROM dual 
    UNION ALL
    SELECT '1' a , '9' b, '8' c FROM dual
)
SELECT a, b ,c
FROM (SELECT a, b ,c 
,row_number () OVER (PARTITION BY a ORDER BY b DESC) r_n
FROM t1)
WHERE r_n=1;