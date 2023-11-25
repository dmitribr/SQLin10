--разные СУБД могут использовать разные типы данных и разные названия этих данных, главная причина несовместимости разных СУБД
--первичными ключами может являться любой столбец в котором, 1) две разные строки не могут повторяться, 2) не иметь Null
--3)не может быть изменено, 4)нельзя использовать дважды, даже после удаления.

--Извличение данных из таблицы
SELECT prod_name    --извлекает столбец prod_name
FROM Products;      --из таблицы Products

SELECT prod, gred, price   --ивзлечение нескольких столбцов через запятую. 
FROM Products;

SELECT *             --извлечение всех столбцов
FROM Products;

SELECT DISTINCT vend_id     --DISTINCT отфильтрует все повторяющие строки в столбце vend_id и вернёт только уникальные.
FROM Products;

SELECT TOP 5 prod_name  --В Microsoft sql извлекает первые 5 строк из столбца prod_name
FROM Products;

SELECT prod_name
FROM Products
LIMIT 5;               --извлекает 5 строк. инструкция для PostgreSQL/MariaDB/MySQL/SQLite
LIMIT 5 OFFSET 3;      --извлекает 5 строк, начиная с 4 строки(так как счёт начинается с 0)
LIMIT 5, 3;            --сокарщённый варинат.

--Сортировка полученных данных
SELECT price
FROM Products
ORDER BY price;        --сортировка по алфавиту для столбца price. можно сортировать по другому столбцу который не извлекается
ORDER BY price, prod_name;     --сортировка сразу по двум столбцам.  ORDER BY всегда указывается последним в инструкции.

ORDER BY prod DESC;         --сортировка в порядке убывания
ORDER BY price DESC, prod_name DESC;     --сортировка сначала по убыванию price, затем по убыванию prod_name. 
                                            --Есть инструкция ASC, по возрастанию, но она указана по умолчанию.

--Фильтрация данных
SELECT prod_name, price
FROM Products
WHERE price = 45.5;   --извелкает два столбца, но возвращает значение только тех строк у которых price = 45.5

WHERE price <= 10;    --фильтрует и вернёт только те строки которые меньше либо равны 10.

WHERE prod_name != 'Regi';      --вернёт те строки которые не равны Regi, все строковые значения заключаются в кавычки

WHERE price BETWEEN 5 AND 9;        --филтрует на соновании строк price между 5 и 9 (включительн)

WHERE price IS NULL;            --фидьтрует на основании пустых строк, строка имеющая 0 не вялется пустой.

--Расширенная фильтрация данных
SELECT prod, price, prod_name
FROM Products
WHERE vend_id = 'DL11' AND price >= 34;   --фильтрация по двум столбмцам при помощи оператора AND

WHERE vend_id = 'RR10' OR vend_id = 'HG45';     --фильтрация по одному из указанных значений.
WHERE vend_id IN ('RR10', 'HG45');               --IN равносильно опертору OR, но компактней и выполняеется быстрее.

WHERE (vend_id = 'RR10' OR vend_id = 'HG45') AND price <= 12; --сначала фильтрует в скобках в затем оператор AND

WHERE NOT vend_id = 'TR09';    --отфилтрует все строки которе равно TR09, тоже самое что и vend_id != 'TR09'.

--Фильтрация с использованием метасимволов


























