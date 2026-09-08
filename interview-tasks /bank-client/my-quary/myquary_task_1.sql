WITH auto 
AS(
    SELECT 111 AS deal_id,'цфу1' AS attr1
    FROM DUAL
    UNION ALL
    SELECT 222 AS deal_id,'цфу2' AS attr1
    FROM DUAL
    UNION ALL
    SELECT 333 AS deal_id,'цфу3' AS attr1
    FROM DUAL
    UNION ALL
    SELECT 444 AS deal_id,'NoName' AS attr1
    FROM DUAL
),mnl 
AS(SELECT 111 AS deal_id,'NULL' AS attr1,1 AS is_deleted_src
    FROM DUAL
    UNION ALL
    SELECT 444 AS deal_id,'цфу4' AS attr1,0 AS is_deleted_src
    FROM DUAL
    UNION ALL
    SELECT 555 AS deal_id,'цфу5' AS attr1,0 AS is_deleted_src
    FROM DUAL
)
SELECT NVL(mnl.deal_id,auto.deal_id) deal_id --заменяем пустышки на нужные значения deal_id
,(CASE WHEN is_deleted_src = 0 
    THEN mnl.attr1 
    ELSE auto.attr1
    END) attr1--выводим ручную запись, если отсутвует в таблице auto.Иначе автом-ий
                --Тем самым  исключается NoName
FROM auto
FULL JOIN mnl
ON auto.deal_id = mnl.deal_id
WHERE NVL(mnl.is_deleted_src,0) != 1;--присваиваем полю is_deleted_src 0 и убираем запись с 1
