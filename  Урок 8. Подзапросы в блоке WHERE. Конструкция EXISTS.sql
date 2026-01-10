--SQL. Урок 8. Подзапросы в блоке WHERE. Конструкция EXISTS
--https://rutube.ru/video/private/b5bdc358b888a443b7d129467b5e7f2b/?p=tK5Q02rbxi8Ut5uCbrvULw
SELECT count(pc.personid)
FROM personcars pc, persons p
WHERE 1=1
  AND pc.personid(+)=p.personid;
--GROUP BY pc.personid

SELECT *
FROM persons p
WHERE p.personid IN (SELECT DISTINCT personid FROM personcars);

SELECT *
FROM persons p
WHERE EXISTS(SELECT * FROM personcars WHERE personid = p.personid);

SELECT count(*)
FROM persons p
WHERE EXISTS(SELECT * 
              FROM phones 
              WHERE personid = p.personid
                AND phone_type = 'мобильный' 
                )
      AND
      EXISTS(SELECT * 
              FROM phones 
              WHERE personid = p.personid
                AND phone_type = 'рабочий'
                );

--Здесь ошибка специальная, чтобы показать, что вернутся все данные, и это ошибка начинающщих разработчиков    
--подзапрос будет брать сверять personid с таким же полем personid той же таблицы
SELECT *
FROM persons
WHERE EXISTS(SELECT * FROM personcars WHERE personid=personid);

SELECT *
FROM persons p
WHERE EXISTS(SELECT * FROM personcars WHERE p.personid=personid);

SELECT p.name
      , length(p.name)
      , UPPER(p.name)
      , LOWER(p.name)
FROM persons p;

SELECT ' Василий ' FROM dual
UNION ALL
SELECT trim(' Василий ') FROM dual
UNION ALL
SELECT rtrim(' Василий ') FROM dual
UNION ALL
SELECT ltrim(' Василий ') FROM dual;

--Урок №8 ДЗ № 1
SELECT name
FROM persons p
WHERE 1=1
  AND EXISTS(SELECT 1 FROM personcars pc WHERE pc.personid = p.personid)
  AND NOT EXISTS(SELECT 1 FROM personcanteenorder pco WHERE pco.personid=p.personid);
  
--Урок №8 ДЗ № 2
SELECT p.name
      , ph.phone_number
FROM persons p
  INNER JOIN filial f USING(filialid)
  INNER JOIN phones ph USING(personid)
WHERE f.filialname = 'Москва';

--Урок №8 ДЗ № 3 Классная задачка, тут пришлось подумать
SELECT p.name 
      , count(ph.phone_type) as phone_qty
FROM persons p
LEFT JOIN phones ph ON p.personid = ph.personid AND phone_type = 'рабочий'
GROUP BY p.name;

--Урок №8 ДЗ № 4
SELECT p.name
FROM persons p
WHERE NOT EXISTS
  (SELECT 1 FROM phones WHERE phones.personid = p.personid);
  
--Урок №8 ДЗ № 5 Первый способ
SELECT p.name
FROM persons p
LEFT OUTER JOIN canteendishes c ON c.cookid = p.personid
GROUP BY p.name
HAVING count(*) > 8;

--Урок №8 ДЗ № 5 Второй способ
SELECT name
FROM persons
WHERE personid in (
      SELECT c.cookid
      FROM canteendishes c
      GROUP BY c.cookid
      HAVING count(*)> 8);
      
--Урок №8 ДЗ № 5 Третий способ
SELECT name
FROM persons p
WHERE EXISTS(SELECT 1 
              FROM 
              (SELECT canteendishes.cookid
                FROM canteendishes
                GROUP BY canteendishes.cookid
                HAVING count(*) > 8) champ_cooks
              WHERE p.personid = champ_cooks.cookid);
              
--Урок №8 ДЗ № 6
SELECT *
FROM canteendishes c
WHERE c.price = (SELECT MAX(PRICE) FROM canteendishes);
              
--Урок №8 ДЗ № 7 Как лучше? Как более профессиональней с этим (SELECT 1 FROM DUAL)?
SELECT *
FROM persons p
WHERE EXISTS (SELECT 1 FROM DUAL WHERE LENGTH(p.name) = (SELECT MAX(LENGTH(persons.name)) FROM persons));

--Урок №8 ДЗ № 7 второй способ по синтаксису более симпатичный
SELECT *
FROM persons p
WHERE LENGTH(p.name) = (SELECT MAX(LENGTH(persons.name)) FROM persons);