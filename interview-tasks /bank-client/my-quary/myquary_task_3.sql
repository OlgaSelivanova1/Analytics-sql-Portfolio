with attr1 as 
(select to_date('03.11.2022','dd.mm.yy') from_date, to_date('06.11.2022','dd.mm.yy') to_date, '1100' nm_amt from dual 
union all
select to_date('11.11.2022','dd.mm.yy') from_date, to_date('13.11.2022','dd.mm.yy') to_date, '1000' nm_amt from dual 
union all
select to_date('14.11.2022','dd.mm.yy') from_date, to_date('14.11.2022','dd.mm.yy') to_date, '500' nm_amt from dual 
)
,
attr2 as 
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
)
SELECT from_date,to_date,new_mt nm_amt,client_name
FROM(
SELECT from_date,to_date
    ,LAG(from_date) OVER (ORDER BY nm_amt,client_name,to_date )from_date2
    ,LAG(to_date) OVER (ORDER BY nm_amt,client_name,from_date )to_date2
    ,MAX(nm_amt) OVER (PARTITION BY from_date)new_mt
    ,LEAD(client_name) OVER (ORDER BY from_date,nm_amt)client_name
FROM union_tbl
ORDER BY from_date,to_date
)
WHERE new_mt IS NOT NULL;