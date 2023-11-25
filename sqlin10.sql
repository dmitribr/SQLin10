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
SELECT price, prod_name
FROM Products
WHERE prod_name LIKE 'Dec%';   --Предикат LIKE указывает на использование какого либо метасимвола. 'Dec%' указвает на то что строка 
                               --должна начинаться с Dec а дальше любые символы, чтобы поиск происходил внутри строки '%Dec%' или окончания 'D%c'
WHERE prod_name LIKE 'neve_';  --указывает на начало строки neve и ещё _ 1 символ, __ 2 символа.

WHERE prod LIKE '[MT]%';       --в [] набор символов с которых может начинатся строка.

WHERE prod LIKE '[^DR]%';      --символ ^ указывает на то с каких символов не должна начинатся строка.
WHERE NOT prod LIKE '[DR]%';   --с использованием NOT получим одни и те же ресультаты.

--Создание вычисляемых полей
SELECT vend_name + '(' + vend_country + ')'  --получим Имя (Страна). конкатенация полей(столбцов). 
FROM Vendors;
SELECT vend_name || '(' || vend_country || ')'   --конкатенация для PostgreSQL
SELECT Concat(vend_name, '(', vend_country, ')')  --функция конкатенации для MariaDB/MySQL

SELECT RTRIM(vend_name) + '(' + vend_country + ')'  --функция RTRIM убирает пробелы справа у vend_name, LTRIM - слева. TRIM - с обоих сторон

SELECT RTRIM(vend_name) + '(' + vend_country + ')'
        AS vend_new                                 --AS создаёт вычисляемое поле(столбец) с псевдонимом vend_new
                                                    --в который помещается предыдущая конкатенация
SELECT prod,
       price,                       --математические вычисления *, /, +, -
       price * quantity AS result   --умнажаем одну строку на другую и помещаем в столбец result
FROM Order
WHERE price <= 1400;

--Использование функций обработки данных
SELECT UPPER(vend_name) AS vend_name_upcase  --функция UPPER преобразует строку в верхний регистр. и AS помещает в новый столбец.
FROM Vendors;
--строковые функции
/*LEFT(),RIGHT() - возвращает из левой или правой части строки.
  LENGTH(), DATALENGTH(), LEN() -возвращают длинну строки
  LOWER(), LCASE(), UPPER(), UCASE()  -преобразуют строку в нижний или верхний регистр*/
SELECT price, prod_name
FROM Products
WHERE prod_name = SOUNDEX('Michel'); --данная функция вернёт все строки где слово Michel созвучно по произношению 
--функции для работы с датой и временем
SELECT price
FROM Products
WHERE DATAPART(yy, order_date) = 2020; --DATAPART по фрагменту даты (1 аргумент) и 2 аргумент дата. возваращает строки с годом равным 2020
WHERE DATA_PART('year', order_date) = 2015;  --та же функция только для PostgreSQL
WHERE YEAR(order_date) = 2017;   --та же функция для MySQL и MariaDB
--функции для работы с числами
/*ABS() -модуль числа
  COS(),SIN(),TAN() - косинус/синус/тангенс заданного угла
  EXP() - экспонента заданного числа
  PI() - число Пи
  SQRT() - квадратный корень */

--Итоговые вычисления - обрабатывают набор строк для вычисления обобщающего значения.
/*AVG() - среднее значение по столбцу 
  COUNT() - число чтрок в столбце
  SUM() - сумма значений столбца
  MAX(),MIN() -наибольшее/наименьшее значние в столбце 
*/
SELECT AVG(price) AS medium_price   --возвращает одно значение - среднюю цену всех товаров, чей vend_id равен DF233
SELECT AVG(DISTINCT price) AS medium_price  --DISTINCT при вычислении среднего значения учитываются только уникальные цены
FROM Products
WHERE vend_id = 'DF233';

SELECT COUNT(*) AS num_cust   --используется для подсчёта всех строк, не зависимо от их содержимого
FROM Products;
SELECT COUNT(cust_email) AS num_cust   --подсчитывает строки которые имеюют не нулевое значение в столбце cust_email

SELECT MAX(price) AS max_price  --возваращет максимальное значение для столбца price, если MIN(price) то вернёть минимальное значение
FROM Products;

SELECT SUM(quantity) AS item_order  --суммирует все строки столбца quantity и возвращает одно число
FROM Products;

SELECT COUNT() AS num_cust,           
       MIN(price) AS price_min,
       MAX(price) AS price_max,         --комбинирование функций
       AVG(price) AS price_avg
FROM Products;

--Группировка данных











