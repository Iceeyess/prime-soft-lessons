select *
from persons
where 1=1
and birthdate <= to_date('01.01.85', 'dd.mm.rr');


select *
from nls_database_parameters


-- Урок 2, Задание 1. Вывожу список именно сотрудников, как по заданию.
SELECT NAME
FROM Persons
WHERE FILIALID = 1 OR FILIALID = 2;

-- Урок 2, Задание 2.
SELECT NAME
FROM Persons
WHERE FILIALID = 1 AND NOT BIRTHDATE < TO_DATE('01-01-1980', 'DD-MM-YYYY');

-- Урок 2, Задание 3.
SELECT NAME
FROM Persons
WHERE 1=1 
  AND NAME LIKE 'А%';
  
-- Урок 2, Задание 3. Так потешнее. Для проверки введи "Б"
SELECT NAME
FROM Persons
WHERE 1=1 
  AND ASCii(UPPER(SUBSTR(NAME, 1, 1))) = ASCii('А');
  
 -- Урок 2, Задание 4. 
SELECT DISHNAME
FROM Canteendishes
WHERE 1=1
  AND PRICE BETWEEN 70 AND 100
ORDER BY PRICE DESC;

 -- Урок 2, Задание 5.
 SELECT DISHNAME
FROM Canteendishes
WHERE 1=1
  AND COOKID IS NOT NULL
ORDER BY DISHNAME;