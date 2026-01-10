--SQL. Урок 7. Подзапросы в блоке WHERE. Конструкция IN и NOT IN
--https://rutube.ru/video/private/5ffe7936575ead73b60eda79691145d9/?p=rmeZD0disuVbl9UYXJD8Aw
SELECT distinct p.name
FROM persons p
INNER JOIN personcars pc ON pc.personid = p.personid;

SELECT *
FROM persons p
WHERE 1=1
    AND p.personid in (select personid from personcars);
    
select *
from persons WHERE personid NOT IN (
                      SELECT UNIQUE personid FROM personcanteenorder);

--Урок 7 ДЗ Задание №1
SELECT name
FROM persons 
WHERE personid IN (SELECT UNIQUE cookid FROM canteendishes WHERE cookid IS NOT NULL);

--Урок 7 ДЗ Задание №2
SELECT p.name
FROM persons p
INNER JOIN filial f ON f.filialid = p.filialid AND f.filialname = 'Москва'
WHERE 1=1
  AND p.personid NOT in (SELECT UNIQUE personid FROM personcars);
  
--Урок 7 ДЗ Задание №2 без JOIN как по заданию
SELECT name
FROM persons
WHERE 1=1
  AND filialid IN (SELECT UNIQUE filialid FROM filial WHERE filialname = 'Москва')
  AND personid NOT IN (SELECT UNIQUE personid FROM personcars);
  
--Урок 7 ДЗ Задание №3
SELECT to_char(birthdate, 'month'), count(*)
FROM persons
GROUP BY to_char(birthdate, 'month');

--Урок 7 ДЗ Задание №3
SELECT month_letters, qty
FROM (SELECT to_number(to_char(birthdate, 'mm')) as month_num, 
  to_char(birthdate, 'month') as month_letters, 
  count(*) as qty
FROM persons
GROUP BY to_char(birthdate, 'mm'), to_char(birthdate, 'month')
ORDER BY month_num);

----Урок 7 ДЗ Задание №3
SELECT EXTRACT(month from birthdate), count(*)
FROM persons
GROUP BY EXTRACT(month from birthdate);