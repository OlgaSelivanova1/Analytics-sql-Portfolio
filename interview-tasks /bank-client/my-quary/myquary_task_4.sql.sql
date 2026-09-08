WITH tbl_balance AS(select to_date('31.01.2025','dd.mm.yy') day,'40817810099910004312' account,'1100' balance from dual
                    union all
                    select to_date('01.02.2025','dd.mm.yy') day,'40817810099910004312' account,'1100' balance from dual
                    union all
                    select to_date('02.02.2025','dd.mm.yy') day,'40817810099910004312' account,'500' balance from dual
                    union all
                    select to_date('03.02.2025','dd.mm.yy') day,'40817810099910004312' account,'500' balance from dual
                    union all
                    select to_date('04.02.2025','dd.mm.yy') day,'40817810099910004312' account,'500' balance from dual
                    union all
                    select to_date('05.02.2025','dd.mm.yy') day,'40817810099910004312' account,'50000' balance from dual
                    union all
                    select to_date('06.02.2025','dd.mm.yy') day,'40817810099910004312' account,'50000' balance from dual
                    union all
                    select to_date('07.02.2025','dd.mm.yy') day,'40817810099910004312' account,'50000' balance from dual
                    union all
                    select to_date('13.03.2025','dd.mm.yy') day,'40817810099910004315' account,'30000' balance from dual
                    union all
                    select to_date('09.02.2025','dd.mm.yy') day,'40817810099910004312' account,'77000' balance from dual
                    union all
                    select to_date('10.02.2025','dd.mm.yy') day,'40817810099910004312' account,'77000' balance from dual
                    union all
                    select to_date('14.03.2025','dd.mm.yy') day,'40817810099910004315' account,'30000' balance from dual
                    union all
                    select to_date('14.03.2025','dd.mm.yy') day,'40817810099910004315' account,NULL AS balance from dual --'0' на счету, но он не отображается(NULL)(не хранится значение в БД)
/*Ищем и размещаем по группам дни, когда на счету один остаток*/
),grp_tbl AS (SELECT day,account,balance                                   
                     ,LAG(balance) OVER (PARTITION BY account ORDER BY day) AS pre_balance
                     ,LAG(day) OVER (PARTITION BY account ORDER BY day) AS pre_day
              FROM tbl_balance
/*Вычисляем текущую сумму нулей и единиц, возвращенных в CASE,чтобы распределить все строки по группам*/
),group_flags AS(SELECT day,account,NVL(balance,0) AS balance
                    ,SUM(new_grp) OVER (PARTITION BY account ORDER BY day ROWS UNBOUNDED PRECEDING) AS grp
                 FROM(SELECT account,day, balance
                            ,(CASE WHEN balance = pre_balance AND day = pre_day + 1--проходимся по дням, попадающим в (непрерывные дни)период с одинаковым остатком
                         THEN 0 ELSE 1 END) new_grp
                  FROM grp_tbl
                  )
)-- Периоды с ненулевым остатком
,non_zero_per AS(SELECT MIN(day)from_date
                        ,MAX(day) to_date
                        ,account
                        ,balance
                 FROM group_flags
                WHERE balance != 0
                GROUP BY account, grp, balance
/*Нулевой остаток*/
),zero_per AS(SELECT MIN(day)from_date
                        ,MAX(day) to_date
                        ,account
                        ,balance
                 FROM group_flags
                WHERE balance = 0
                GROUP BY account, grp, balance    
),
union_zero_nonzero AS
    (SELECT from_date,to_date,account,balance
    FROM non_zero_per
    union all
    SELECT from_date,to_date,account,balance
    FROM zero_per
    order by from_date,to_date,account,balance
)
,next_period AS
    (SELECT from_date,to_date,account,balance
            ,LEAD(from_date) OVER (PARTITION BY account ORDER BY from_date,balance) AS new_fdate
                   -- ,lag(to_date)OVER (PARTITION BY account ORDER BY from_date) AS new_to_date
    FROM union_zero_nonzero
    ORDER BY from_date,to_date,new_fdate,account,balance
)
SELECT from_date
       /*Предположим, что ЕСЛИ запись об остатке отсутвует, есть только одна,а нам надо создать период */
       /*сделаем его нулевым на текущую дату.Пока не появится новая запись с остатком NOT NULL*/
      ,(CASE WHEN new_fdate IS NULL THEN SYSDATE ELSE new_fdate END) AS to_date/*Либо: NVL(new_fdate,SYSDATE)*/
      /*Для удобства можно было б добавить поле, которое будет указывать на нулевой остаток*/
      /*(например кодировка 2-есть деньги, 1 - отсутсвуют, 0 - отрицательный баланс)*/
      ,account,balance
FROM next_period;
