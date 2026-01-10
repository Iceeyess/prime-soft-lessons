--SQL. Урок 4. Дополнительные примеры соединений, работа с NULL, DISTINCT
--https://rutube.ru/video/private/7f79999d739ddadc61383130a6adaaee/?p=9aYJjOG1ToyUU4HwIR2Urw
--Метод 1
SELECT     pers.*
           ,dep.departamentname
           ,fil.filialname
           ,p.phone_number
FROM       persons pers
INNER JOIN departament dep ON pers.departamentid = dep.departamentid
INNER JOIN filial fil ON pers.filialid = fil.filialid
LEFT JOIN  phones p ON pers.personid = p.personid
WHERE 1=1
  AND p.phone_number = '8(963)116-12-12';

--Метод 2
SELECT *
FROM persons pers
--INNER JOIN departament dep ON pers.departamentid = dep.departamentid
INNER JOIN departament dep USING(departamentid)
INNER JOIN filial fil USING(filialid)
LEFT JOIN phones p USING(personid);

--Метод 3
SELECT *
FROM persons pers, departament dep, filial fil, phones p
WHERE 1=1
  AND pers.departamentid = dep.departamentid
  AND fil.filialid = pers.filialid
  AND p.personid(+) = pers.personid;
  
  
SELECT *
FROM persons p, personcars pc
WHERE 1=1
  AND p.personid(+) = pc.personid;
  
SELECT UNIQUE p.name as name, pc.carname
FROM persons p
INNER JOIN personcars pc ON p.personid = pc.personid
WHERE p.name LIKE '%Иван%'
ORDER BY name;


SELECT *
FROM persons p
WHERE REGEXP_LIKE(p.name, '((И)|(и)ван)|(Серг)');
--WHERE REGEXP_LIKE(p.name, '(Иван)|(Серг)');

--ДЗ№ 1 Урок 4 Вывел через UNIQUE - это старое, но доброе выражение.
SELECT UNIQUE p.NAME
FROM (SELECT * FROM canteendishes WHERE cookid IS NOT NULL) c
INNER JOIN persons p ON c.cookid = p.personid;

--ДЗ№ 1 Урок 4 Сцепил таблицы по другому
SELECT UNIQUE p.NAME
FROM (SELECT * FROM canteendishes WHERE cookid IS NOT NULL) c, persons p
WHERE 1=1
  AND c.cookid = p.personid;
  
--ДЗ№ 2 Урок 4 Не хочу решить задачу как все ибо изи
SELECT p.name as "Владелецавто"
FROM persons p
LEFT OUTER JOIN personcars c ON (p.personid = c.personid)
EXCEPT
SELECT p.name as "Владелецавто"
FROM persons p
RIGHT OUTER JOIN personcars c ON (p.personid = c.personid)
ORDER BY "Владелецавто";

--ДЗ№ 2 Урок 4 Теперь обычное решение, но сцепил таблицы по-другому
SELECT p.name as "Владелецавто"
FROM persons p
LEFT OUTER JOIN personcars c USING(personid)
WHERE 1=1
  AND c.carname IS NULL
ORDER BY "Владелецавто";

--ДЗ№ 3 Урок 4 Теперь с regexp функцией, немного прошелся по паттернам
SELECT p.name as "ФИО" 
       ,d.departamentname as "Название отдела"
       ,f.filialname as "Название филиала"
       ,carname as "Марка авто"
FROM persons p
INNER JOIN personcars c USING(personid)
INNER JOIN filial f USING(filialid)
INNER JOIN departament d USING(departamentid)
WHERE 1=1
  AND lower(c.carname) like '%ауди%';
  
--ДЗ№ 3 Урок 4 по-другому решил, а так же немного по другому сцепил таблицы через LEFT JOIN
SELECT p.name as "ФИО" 
       ,d.departamentname as "Название отдела"
       ,f.filialname as "Название филиала"
       ,carname as "Марка авто"
FROM persons p,  personcars c, departament d, filial f
WHERE 1=1
  AND c.personid = p.personid(+) AND REGEXP_LIKE(carname, '(А)уди|(а)уди')
  AND d.departamentid=p.departamentid
  AND f.filialid=p.filialid