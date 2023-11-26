--разные СУБД могут использовать разные типы данных и разные названия этих данных, главная причина несовместимости разных СУБД
--первичными ключами может являться любой столбец в котором, 1) две разные строки не могут повторяться, 2) не иметь Null
--3)не может быть изменено, 4)нельзя использовать дважды, даже после удаления.

--Извличение данных из таблицы =2
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

--Сортировка полученных данных =3
SELECT price
FROM Products
ORDER BY price;        --сортировка по алфавиту для столбца price. можно сортировать по другому столбцу который не извлекается
ORDER BY price, prod_name;     --сортировка сразу по двум столбцам.  ORDER BY всегда указывается последним в инструкции.

ORDER BY prod DESC;         --сортировка в порядке убывания
ORDER BY price DESC, prod_name DESC;     --сортировка сначала по убыванию price, затем по убыванию prod_name. 
                                            --Есть инструкция ASC, по возрастанию, но она указана по умолчанию.

--Фильтрация данных =4
SELECT prod_name, price
FROM Products
WHERE price = 45.5;   --извелкает два столбца, но возвращает значение только тех строк у которых price = 45.5

WHERE price <= 10;    --фильтрует и вернёт только те строки которые меньше либо равны 10.

WHERE prod_name != 'Regi';      --вернёт те строки которые не равны Regi, все строковые значения заключаются в кавычки

WHERE price BETWEEN 5 AND 9;        --филтрует на соновании строк price между 5 и 9 (включительн)

WHERE price IS NULL;            --фидьтрует на основании пустых строк, строка имеющая 0 не вялется пустой.

--Расширенная фильтрация данных =5
SELECT prod, price, prod_name
FROM Products
WHERE vend_id = 'DL11' AND price >= 34;   --фильтрация по двум столбмцам при помощи оператора AND

WHERE vend_id = 'RR10' OR vend_id = 'HG45';     --фильтрация по одному из указанных значений.
WHERE vend_id IN ('RR10', 'HG45');               --IN равносильно опертору OR, но компактней и выполняеется быстрее.

WHERE (vend_id = 'RR10' OR vend_id = 'HG45') AND price <= 12; --сначала фильтрует в скобках в затем оператор AND

WHERE NOT vend_id = 'TR09';    --отфилтрует все строки которе равно TR09, тоже самое что и vend_id != 'TR09'.

--Фильтрация с использованием метасимволов =6
SELECT price, prod_name
FROM Products
WHERE prod_name LIKE 'Dec%';   --Предикат LIKE указывает на использование какого либо метасимвола. 'Dec%' указвает на то что строка 
                               --должна начинаться с Dec а дальше любые символы, чтобы поиск происходил внутри строки '%Dec%' или окончания 'D%c'
WHERE prod_name LIKE 'neve_';  --указывает на начало строки neve и ещё _ 1 символ, __ 2 символа.

WHERE prod LIKE '[MT]%';       --в [] набор символов с которых может начинатся строка.

WHERE prod LIKE '[^DR]%';      --символ ^ указывает на то с каких символов не должна начинатся строка.
WHERE NOT prod LIKE '[DR]%';   --с использованием NOT получим одни и те же ресультаты.

--Создание вычисляемых полей =7
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

--Использование функций обработки данных =8
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

--Итоговые вычисления - обрабатывают набор строк для вычисления обобщающего значения. =9
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

--Группировка данных =10
SELECT vend_id, COUNT(*) AS num_prods
FROM Products       --group by может работать только с теми столбцами которые указаны в select
GROUP BY vend_id;   --сортирует и группирует одинаковые записи в vend_id и выдаст результат группировки в num_prods

SELECT vend_id, COUNT(*) AS num_prods
FROM Products
GROUP BY vend_id       --HAVING может использовать все те же операторы и символы что и WHERE. только where фильтрует строки до того как они
HAVING COUNT(*) >= 2;     --были сгруппированы, а HAVING фильтрует после группировки, HAVING не может использоваться без GROUP BY

SELECT vend_id, COUNT(*) AS num_prods
FROM Products
WHERE price >=5       --так же можно добавить WHERE, и group by будет группироваться уже на основе данных отфильтрованных where
GROUP BY vend_id
HAVING COUNT(*) >= 2;

SELECT vend_id, COUNT(*) AS num_prods
FROM Products
WHERE price > 3
GROUP BY vend_id
HAVING COUNT(*) >= 2   --возвращает столбцы с 2 и более числом
ORDER BY num_prods;     --и сортирует полученные строки.

--Подзапросы =11
--пример. есть две разных таблицы, где на основании купленного товара "RG11" нужно узнать id покупателя,
--в другой таблице имя покупателя на основании этих id
SELECT order_id
FROM Products
WHERE prod_number = 'RG11';      --получаем order_id (2003, 3045)
SELECT name_us
FROM Orders
WHERE order_id IN (2003, 3045);   --записываем полученные данные во второй запрос

SELECT name_us
FROM Orders
WHERE order_id IN (SELECT order_id       --приведённые выше запросы, можно сделать с подзапросом.
                   FROM Products
                   WHERE prod_number = 'RG11');

SELECT number_tel
FROM Pfone
WHERE name_us IN (SELECT name_us                --число подзапросов не ограничено
                  FROM Orders
                  WHERE order_id IN (SELECT order_id       
                                     FROM Products
                                     WHERE prod_number = 'RG11'));

SELECT num_cust,      --использование подзапросов в качестве вычисляемых полей
       cust_state,
       (SELECT COUNT(*) 
       FROM Orders
       WHERE Orders.order_id = Costum.cust_id) AS orders  --сравниваем id в двух разных таблицах.
FROM Costum
ORDER BY num_cust;

--Объединение таблиц =12
SELECT vend_name, vend_country, prod_number   --запрашиваем 3 столбца из двух таблиц
FROM Vendors, Products                        --обращаемся к двум таблицам.
WHERE Vendors.vend_id = Products.vend_id;     --объеденяем две таблицы при помощи сравнения двух индификаторов(первичных ключей)
--если не указазать where то строки объеденяться в разнобой без какой либо связи.декартово произведение.(перекрёсное объединение)

SELECT vend_name, vend_country, prod_number      --точное такое же объединение как и предыдущее
FROM Vendors INNER JOIN Products              --но с использованием инструкции INNER JOIN
      ON Vendors.vend_id = Products.vend_id;  --в ON указываем условия связи, тоже самое что и указывали в WHERE

SELECT vend_name, vend_country, prod_number, quantity  
FROM Vendors, Products, Orders                        --объединение 3 таблиц
WHERE Vendors.vend_id = Products.vend_id
  AND Orders.vend_id = Vendors.vend_id            --сравнение их идентификаторов, для того чтобы строки имели связь между собой
  AND order_id = 203;                     --и дополнительное условие с указанием id

--Создание расширенных объединений =13
SELECT vend_name, prod_number, quantity  
FROM Vendors AS V, Products AS P, Orders AS O   --Указание псевдонимов таблиц для сокращения дальнейших записей
WHERE V.vend_id = P.vend_id
  AND O.vend_id = V.vend_id            
  AND order_id = 203;

SELECT P1.prod_id, P1.prod_number, P1.prod_name 
FROM Products AS P1, Products AS P2          --самообъединение
WHERE P1.prod_name = P2.prod_name           --если нужно два условия или больше в одной таблице то можно задать разные псевдонимы
  AND P2.prod_number = 845;                 --одной и той же таблице

SELECT V.*, P.prod_number, O.quantity           -- символ * вернёт все столбцы из V таблицы которые уникальны по отношению к другим излвекаемым столбцам
FROM Vendors AS V, Products AS P, Orders AS O   --естественное объединение
WHERE V.vend_id = P.vend_id
  AND O.vend_id = V.vend_id            
  AND order_id = 203;

SELECT Vendors.vend_name, Products.prod_number      
FROM Vendors LEFT OUTER JOIN Products              --внешнее объединение, если имеются пустые строки то она из так же извлекёт
      ON Vendors.vend_id = Products.vend_id        --LEFT извлекёт все троки левой таблицы, RIGHT правой таблицы - Products
GROUP BY Vendors.vend_name;     --дополнительно групперуем по vend_name

--Комбинированные запросы =14 (многократное использование SELECT)
