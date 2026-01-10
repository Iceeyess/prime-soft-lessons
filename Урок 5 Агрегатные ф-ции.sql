SELECT * --min(p.birthdate) 
FROM persons p, personcars c
WHERE 1=1
  AND p.personid = c.personid(+);


 
DEFINE month = '01';
SELECT round(sum(pp.sum) ,2)
FROM personpayments pp
WHERE 1=1
  AND to_char(pp.period, 'mm') = '&month';
  
  
SELECT p.name FIO
      , count(c.carname) quantity_cars
FROM persons p
LEFT JOIN personcars c
  ON c.personid = p.personid
GROUP BY p.name
HAVING count(c.carname) >= 1
ORDER BY quantity_cars DESC;

SELECT d.departamentname
      , count(p.name) as count_persons
FROM departament d
LEFT JOIN persons p USING(departamentid)
GROUP BY d.departamentname
ORDER BY count_persons DESC;

SELECT d.name
      , avg(c.price) as avg_price
      , count(c.dishname) as count_dishes
      , max(c.price) as max_price
      , min(c.price) as min_price
FROM canteendishes c
INNER JOIN dishtype d USING(dishtype)
GROUP by d.name;

select name
      , carname
FROM (SELECT p.name
      , pc.carname
      , ROW_NUMBER() OVER(PARTITION BY p.name ORDER BY p.name)rn
      FROM persons p
      INNER JOIN personcars pc ON p.personid= pc.personid)
WHERE rn=1;

SELECT p.name
FROM persons p
INNER JOIN personcars pc ON p.personid= pc.personid
GROUP BY p.name;

SELECT DISTINCT p.name
FROM persons p
INNER JOIN personcars pc ON p.personid= pc.personid;


--ДЗ 1 Урок 5
SELECT f.filialname as "Filial name"
      , COUNT(p.personid) as "Person quantity"
FROM filial f
INNER JOIN persons p USING(filialid)
GROUP BY f.filialname;

--ДЗ 2 Урок 5
SELECT COUNT(f.filialname)
FROM filial f
INNER JOIN persons p USING(filialid)
WHERE 1=1
  AND f.filialname = 'Москва';
  
--ДЗ 3 Урок 5
SELECT d.departamentname as "Department name"
      , SUM(pp.sum) as "Total amount"
FROM persons p
INNER JOIN departament d ON p.departamentid = d.departamentid
INNER JOIN personpayments pp ON pp.personid = p.personid
WHERE 1=1
  AND pp.period BETWEEN 
            to_date('01.03.19', 'dd.mm.rr') AND to_date('31.03.19', 'dd.mm.rr')
GROUP BY d.departamentname;

--ДЗ 4 Урок 5
SELECT cd.dishname
      , COUNT(*) as sold_items
FROM canteendishes cd
INNER JOIN personcanteenorder pco ON cd.dishid = pco.dishid
WHERE 1=1
  AND pco.dateorder 
  BETWEEN to_date('01.04.19', 'dd.mm.yy') 
      AND to_date('30.04.19', 'dd.mm.yy')
GROUP BY cd.dishname
ORDER BY sold_items DESC;
      