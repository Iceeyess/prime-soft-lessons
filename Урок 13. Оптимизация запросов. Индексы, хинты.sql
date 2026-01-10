SELECT /*+ index pp PERSONPAYMPERSID */ * 
  FROM PersonPayments pp
  INNER JOIN Persons p
  ON p.personid = pp.personid
WHERE 1=1
  AND pp.personid = 12;
  
SELECT *
FROM Persons p
WHERE UPPER(p.name) = 'КА%';

-- Урок №13 ДЗ № 1
SELECT c.dishname "Наименование блюда"
       , count(dishname) as "Проданное кол-во"
  FROM canteendishes c
LEFT OUTER JOIN personcanteenorder pco ON pco.dishid = c.dishid
WHERE 1=1
      AND pco.dateorder between to_date('01.02.2019', 'dd.mm.yyyy') AND LAST_DAY('01.02.2019')
GROUP BY c.dishname
HAVING count(dishname) >= 15;

-- Урок №13 ДЗ № 2
SELECT c.dishname
       , c.price -- Поставил тебе не по заданию колонку, чтобы удобнее сравнивать, если не нужна закомментируй
       , avg_cat_price.avg_price -- Поставил тебе не по заданию колонку, чтобы удобнее сравнивать, если не нужна закомментируй
  FROM canteendishes c
INNER JOIN (SELECT c.dishtype, 
                   ROUND(AVG(c.price), 2) as avg_price
              FROM canteendishes c
              INNER JOIN dishtype dt ON c.dishtype = dt.dishtype
              GROUP BY c.dishtype
              ) avg_cat_price ON avg_cat_price.dishtype = c.dishtype
WHERE c.price > avg_cat_price.avg_price;

-- Урок №13 ДЗ № 3
SELECT *
FROM PersonCanteenOrder pco
WHERE pco.PersonID = 15;

-- Урок №13 ДЗ № 4
-- Через F5 просмотрел план запроса

-- Урок №13 ДЗ № 5
CREATE INDEX IndPersID ON PersonCanteenOrder (PersonID);

-- Урок №13 ДЗ № 6
SELECT /*+ index (pco) */ *
FROM PersonCanteenOrder pco
WHERE PersonID = 15;

-- Урок №13 ДЗ № 7
--Повторно посмотрел на план запроса, почему-то не увидел разницы
