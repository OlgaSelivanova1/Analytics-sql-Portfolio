# ORACLE SQL Query - Портфолио аналитических задач для банковской сферы из пройденного интервью.
<p>Список задач для прохождения интервью от компаниии "Эксперт ЭХД" с применением оконных функций и CTE.</p>
<p>СУБД ORACLE, использование таблицы DUAL с тестовыми данными.</p>

### Использованные навыки:
<p><li><li>WITH table__name AS...</li></li></p>
<p><li>row_number () OVER (PARTITION BY a ORDER BY b DESC)</li></p>
<p><li>UNION ALL</li></p>
<p><li>CASE WHEN ...THEN..ELSE...END</li></p>
<p><li>FULL JOIN</li></p>
<p><li>NVL(name_column,0)</li></p>
<p><li>LAG(name_column) OVER (ORDER BY name_column_1,name_column_n)</li></p>
<p><li>LEAD(name_column) OVER (ORDER BY name_column_1,name_column_n)</li></p>
<p><li>MAX(name_column) OVER (ORDER BY name_column_1,name_column_n)</li></p>
<p><li>WHERE name_column IS NOT NULL</li></p>
<p><li>MAX/MIN</li></p>
<p><li>GROUP BY/ ORDER BY</li></p>

## Что содержит данный репозиторий?
| Папка        | Contents                                                  |
| ------------- | --------------------------------------------------------- |
| `Analytics-sql-Portfolio/`   | Общая папка с файлом описания задач .docx и папка с решениями .sql     |
| `Zadachi.docx` | ТЗ: постановка задач в количестве 5 шт |
| `my-quary/`    | Выполненные cкрипты в формате .sql    |
| `images.png/`  | Описание исходных таблиц и ожидаемых результатов в формате.png    |


## Обзор задач
<p>(Дословная постановка задач от компании без редактирования текста).</p>
<p>Задачи требуется решить в формате 1 sql запроса (без какого-либо pl/sqlкода), в котором через CTE будут введены исходные данные набором селектов из dual.</p>

### Задача №1
![Исходные данные](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/images.png/task_1_dscrptntbl.png)
 
<p>Постановка задачи:</p>
<p>Есть автоматически рассчитанные значения атрибута 1 по сделкам, а есть ручные.
В ручных (mnl) есть дополнительный атрибут is_deleted_src
Is_deleted_src = 1 означает, что если такая сделка есть в авт.расчете, и ее оттуда нужно удалить(не использовать в результате отчета)
Задача вывести все сделки и значения их атрибутовс учетом ручных корректировок. Логика ручных корректировок: удалить из таблицы с автоматическими значениями записи, у которых Is_deleted_src= 1, а записям с Is_deleted_src= 0 вывести значение атрибута из mnl таблицы.</p>
<p>Результат:</p>

 ![Ожидаемый результат](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/images.png/task_1_resultbl.png)

 [Ссылка на решение](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/my-quary/myquary_task_1.sql)

### Задача №2
 ![Таблицы с данными](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/images.png/task_2_tbl+result.png)
<p>Постановка задачи: вывести уникальные значения из столбца «a», в которых максимальное значение в столбце «b» и соответствующее значение в столбце «c».</p>

[Ссылка на решение](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/my-quary/myquary_task_2.sql)

### Задача №3
 ![Условие](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/images.png/task_3_tbl.png)
<p>Необходимо из 2х заданных таблиц получить итоговую таблицу, в которой требуется создать новые интервалы с уникальной комбинацией полей nm_amt, client_name</p>

[Ссылка на решение](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/my-quary/myquary_task_3.sql)

<p>Дополнительно:</p>
<p>В итоговой таблице добавить отсутствующие периоды. Считаем, что значения полей nm_amt и client_nameотсутствуют в пропущенных периодах.</p>

![Доп условие](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/images.png/task_3_add_condition.png)
[Ссылка на решение](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/my-quary/myquary_task_3_dopchast.sql)


### Задача №4
<p>Есть исходные данные по дням формата:</p>
| День | Номер счета | Остаток на счете |

<p>В некоторые дни значений нет (нет как таковой записи в принципе).
Отсутствие значения подразумевает под собой нулевой остаток, но такие данные не хранятся.
Если значение остатка по счету изо дня в день одинаковое – в исходных данных на каждый день лежит одинаковый остаток.
Нужно предложить вариант раскладки значений из дней в периоды постоянства остатка. Периоды когда остаток равен нулю тоже надо показывать.</p>

<p>Структура итоговой таблицы:</p>
| Дата с  | Дата по | Номер счета | Остаток на счете |

[Ссылка на решение](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/my-quary/myquary_task_4.sql.sql)

### Задача №5
<p>Схлопнуть периоды, если у них все атрибуты одинаковые</p>

![Условие данных](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/images.png/task_5_tbl.png).

[Ссылка на решение](https://github.com/OlgaSelivanova1/Analytics-sql-Portfolio/blob/main/interview-tasks%20/bank-client/my-quary/myquary_task_5.sql)

