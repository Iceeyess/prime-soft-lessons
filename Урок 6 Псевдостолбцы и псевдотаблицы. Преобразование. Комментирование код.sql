SELECT d.departamentname
      , SUM(pp.sum) as zp
FROM departament d
INNER JOIN persons p ON p.departamentid = d.departamentid
INNER JOIN personpayments pp ON pp.personid = p.personid
  AND pp.period BETWEEN TO_DATE('01.03.2019', 'dd.mm.yyyy') AND 
                        TO_DATE('31.03.2019', 'dd.mm.yyyy')
GROUP BY d.departamentname;

SELECT name
      , birthdate
      , rowid
      , rownum
      , 1 as num
      , sysdate
      , systimestamp
      , row_number() over(partition by name order by name)
FROM persons
ORDER BY rowid;


SELECT p.*
      , to_char(birthdate) birthdate_char
      , to_number('234637357342,34', '999999999999D99') as a
      , to_number('4636456,34', '999999999999D99') as b
      , a + b as c
FROM persons p;

SELECT p.*
      , to_char(p.birthdate, 'Q')
     -- , systimestamp(p.birthdate)
FROM persons p;

select *
from v$nls_parameters;

SELECT c.*
      , to_char(10000000000, '9G000G0009G000D000')
FROM canteendishes c;

select p.*
      , extract(year from birthdate) as a
      , extract(month from birthdate) as b
      , to_char(birthdate, 'MM') as c
      , extract(month from birthdate) - to_char(birthdate, 'MM') as d
      , dump(extract(year from birthdate)) as e
from persons p;
--------------------------------------

SELECT 'ЯНВАРЬ' from dual
UNION
SELECT 'ФЕВРАЛЬ' from dual
UNION
SELECT 'МАРТ' from dual
UNION
SELECT 'АПРЕЛЬ' from dual
UNION
SELECT 'МАЙ' from dual
UNION
SELECT 'ИЮНЬ' from dual
UNION
SELECT 'ИЮЛЬ' from dual
UNION
SELECT 'АВГУСТ' from dual
UNION
SELECT 'СЕНТЯБРЬ' from dual
UNION
SELECT 'ОКТЯБРЬ' from dual
UNION
SELECT 'НОЯБРЬ' from dual
UNION
SELECT 'ДЕКАБРЬ' from dual;

----------------------------------

--Урок 6. ДЗ №1
SELECT f.filialname
      , count(*) as quantity_persons
FROM filial f, persons p
WHERE 1=1
  AND f.filialid = p.filialid
GROUP BY f.filialname
HAVING count(*) >= 5;

--Урок 6. ДЗ №2
 SELECT p.name
      , p.birthdate
      , extract(month from p.birthdate)
 FROM canteendishes cd
 INNER JOIN persons p ON cd.cookid = p.personid
 GROUP BY p.name, p.birthdate;
 
 --Урок 6. ДЗ №2 второй вариант, более гибкий
  SELECT DISTINCT p.name
      , to_char(p.birthdate, 'MONTH')
 FROM canteendishes cd
 INNER JOIN persons p ON cd.cookid = p.personid;
 
  --Урок 6. ДЗ №3
 SELECT p.personid
      , p.name
      , count(*)
 FROM phones ph
 INNER JOIN persons p ON p.personid = ph.personid
 GROUP BY p.personid, p.name
 HAVING count(*) > 1;
 
--Урок 6. ДЗ №3 немного добавил вариативности
SELECT name
FROM (SELECT p.name
      , ROW_NUMBER() OVER(PARTITION BY p.personid ORDER BY p.personid) as duplicates
FROM persons p
LEFT JOIN phones ph ON ph.personid = p.personid)
WHERE duplicates = 2;

 
--Урок 6. ДЗ №4
SELECT p.name
from persons p
LEFT OUTER JOIN phones ph ON p.personid = ph.personid
WHERE ph.phoneid IS NULL;
 
--Урок 6. ДЗ №5
SELECT name
FROM persons 
WHERE TO_CHAR(birthdate, 'mm') = TO_CHAR(SYSDATE, 'mm');
 
--Урок 6. ДЗ №5
SELECT name
FROM persons 
WHERE EXTRACT(month FROM birthdate) = EXTRACT(month FROM SYSDATE);