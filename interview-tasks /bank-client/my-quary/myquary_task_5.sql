WITH 
period_tbl AS(
            select to_date('01.04.2023','dd.mm.yy') from_date, to_date('10.04.2023','dd.mm.yy') to_date, '1' ATTR from dual 
            union all
            select to_date('11.04.2023','dd.mm.yy') from_date, to_date('14.04.2023','dd.mm.yy') to_date, '1' ATTR from dual 
            union all
            select to_date('16.04.2023','dd.mm.yy') from_date, to_date('20.04.2023','dd.mm.yy') to_date, '2' ATTR from dual
            union all
            select to_date('22.04.2023','dd.mm.yy') from_date, to_date('23.04.2023','dd.mm.yy') to_date, '1' ATTR from dual
            union all
            select to_date('24.04.2023','dd.mm.yy') from_date, to_date('25.04.2023','dd.mm.yy') to_date, '1' ATTR from dual 
            union all
            select to_date('26.04.2023','dd.mm.yy') from_date, to_date('27.04.2023','dd.mm.yy') to_date, '1' ATTR from dual 
            union all
            select to_date('05.05.2023','dd.mm.yy') from_date, to_date('06.05.2023','dd.mm.yy') to_date, '1' ATTR from dual
)
,new_group AS(SELECT from_date,to_date,ATTR,flag
                    ,(CASE WHEN from_date <= flag + 1 then 0 else 1 END)new_grp
              FROM(SELECT from_date,to_date,ATTR
                        ,LAG(to_date) OVER (PARTITION BY ATTR ORDER BY from_date)flag
                  FROM period_tbl
                 )
)
,wth_groups AS (
               SELECT
                   ATTR,
                   from_date,
                   to_date,
                   SUM(new_grp) OVER (PARTITION BY ATTR ORDER BY from_date ROWS UNBOUNDED PRECEDING) AS group_id
               FROM new_group
)
-- Финальная группировка: для каждого ID и номера группы берём min начала и max конца
SELECT
    MIN(from_date) AS from_date,
    MAX(to_date)   AS to_date
    ,attr
FROM wth_groups
GROUP BY attr, group_id
ORDER BY from_date,attr;
