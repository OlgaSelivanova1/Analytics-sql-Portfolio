with attr1 as 
(select to_date('03.11.2022','dd.mm.yy') from_date, to_date('06.11.2022','dd.mm.yy') to_date, '1100' nm_amt from dual 
union all
select to_date('11.11.2022','dd.mm.yy') from_date, to_date('13.11.2022','dd.mm.yy') to_date, '1000' nm_amt from dual 
union all
select to_date('14.11.2022','dd.mm.yy') from_date, to_date('14.11.2022','dd.mm.yy') to_date, '500' nm_amt from dual 
)
,attr2 as 
    (select to_date('03.11.2022','dd.mm.yy') from_date, to_date('05.11.2022','dd.mm.yy') to_date, 'name1' client_name from dual 
    union all
    select to_date('06.11.2022','dd.mm.yy') from_date, to_date('06.11.2022','dd.mm.yy') to_date, 'name2' client_name from dual
),union_tbl AS(SELECT from_date,to_date,nm_amt,client_name                    
                FROM(
                SELECT from_date,to_date,nm_amt,NULL  client_name    
                FROM  attr1
                UNION ALL
                SELECT  from_date,to_date,NULL,client_name                    
                FROM attr2)
),result_tbl
  AS(  SELECT from_date,to_date,new_mt nm_amt,client_name
    FROM(
    SELECT from_date,to_date
        ,LAG(from_date) OVER (ORDER BY nm_amt,client_name,to_date )from_date2
        ,LAG(to_date) OVER (ORDER BY nm_amt,client_name,from_date )to_date2
        ,MAX(nm_amt) OVER (PARTITION BY from_date)new_mt
        ,LEAD(client_name) OVER (ORDER BY from_date,nm_amt)client_name
    FROM union_tbl
    ORDER BY from_date,to_date
    )
    WHERE new_mt IS NOT NULL
    
)
/*ÑÎÇÄÀÅÌ ÊÀËÅÍÄÀĞÜ ÈÇ ÂÑÅÕ ÄÀÒ ÌÅÆÄÓ ÌÀÊÑ FROM_DATE È MIN(FROM_DATE) ÏÅĞÅÄ ÎÑÍÎÂÍÛÌ ÇÀÏĞÎÑÎÌ*/
,calendar_month AS(/*Ãåíåğèğóåì âñå äàòû ìåæäó max(from_date) è min(from_date) â âûáîğêå */
                    SELECT gen_date FROM
                    (
                    SELECT min_fd + LEVEL - 1 gen_date
                    FROM(
                        SELECT MIN(from_date)min_fd
                               ,MAX(from_date)max_fd
                               
                        FROM result_tbl
                    )
                    CONNECT BY LEVEL <= (max_fd - min_fd + 1)
                )
),new_interval
  AS( SELECT MIN(gen_date)from_date,MAX(gen_date)to_date,nm_amt,client_name
    FROM(
    SELECT from_date,to_date, gen_date
        ,LAG(to_date)OVER ( ORDER BY from_date,gen_date)
        ,nm_amt,client_name
    FROM result_tbl
    FULL JOIN calendar_month
    ON calendar_month.gen_date BETWEEN from_date AND to_date
    ORDER BY gen_date
    )
    GROUP BY from_date,to_date,nm_amt,client_name
    ORDER BY from_date,to_date,nm_amt,client_name
)
SELECT * FROM new_interval;
