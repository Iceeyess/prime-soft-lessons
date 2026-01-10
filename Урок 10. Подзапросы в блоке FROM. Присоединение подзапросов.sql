--SQL. Урок 10. Подзапросы в блоке FROM. Присоединение подзапросов
--https://rutube.ru/video/private/e2db6b6058a92dfcc609f628add31418/?p=7evZ31IbYgsFklQzSrvNhg
SELECT t.*
      , NVL(t.total_payment, 0) - nvl(t.sold_items, 0) as to_receive
      , CASE 
        WHEN t.total_payment IS NULL
        THEN 0
        ELSE t.total_payment
      END as total_payment_2
      , CASE 
        WHEN t.sold_items IS NULL
        THEN 0
        ELSE t.sold_items
      END as sold_items_2
FROM(
SELECT p.personid as Tab_num
      , p.name as FIO
      , (SELECT SUM(sum) 
          FROM personpayments 
          WHERE personid = p.personid
            AND period BETWEEN to_date('01.04.2019', 'dd.mm.yyyy')
            AND to_date('30.04.2019', 'dd.mm.yyyy')) as total_payment
      , (SELECT sum(cd.price)
          FROM personcanteenorder pco
          INNER JOIN canteendishes cd ON cd.dishid=pco.dishid
          WHERE pco.personid=p.personid 
            AND pco.dateorder BETWEEN to_date('01.03.2019', 'dd.mm.yyyy')
            AND to_date('31.03.2019', 'dd.mm.yyyy')) as sold_items
FROM persons p
) t;

SELECT  pco.personid
      , SUM(cd.price) as SUM_ZAKAZOV
FROM personcanteenorder pco
INNER JOIN canteendishes cd ON cd.dishid = pco.dishid
WHERE pco.dateorder BETWEEN to_date('01.03.2019', 'dd.mm.rrrr')
                        AND to_date('31.03.2019', 'dd.mm.rrrr')
GROUP BY pco.personid;

SELECT *
FROM persons p
LEFT OUTER JOIN (SELECT  pco.personid
                    , SUM(cd.price) as SUM_ZAKAZOV
                  FROM personcanteenorder pco
                  INNER JOIN canteendishes cd ON cd.dishid = pco.dishid
                  WHERE pco.dateorder BETWEEN to_date('01.03.2019', 'dd.mm.rrrr')
                                          AND to_date('31.03.2019', 'dd.mm.rrrr')
                  GROUP BY pco.personid) so ON so.personid = p.personid;
                  
-- Урок 10. ДЗ № 1 
SELECT d.departamentname
      , dep_car_dr.qty_car_drivers
FROM departament d
INNER JOIN
      (SELECT p.departamentid
            , COUNT(car_drivers.personid) qty_car_drivers
      FROM persons p
      LEFT OUTER JOIN (SELECT DISTINCT personid
                        FROM personcars) car_drivers ON car_drivers.personid = p.personid
      GROUP BY p.departamentid) dep_car_dr ON dep_car_dr.departamentid = d.departamentid;
      
-- Урок 10. ДЗ № 2 -- У нас три чемпиона, поэтому повозился так, чтобы выводило 
--всех personid, у кого максимум заказов
SELECT p.name as "ФИО"
      , p.birthdate as "Дата рождения"
      , (SELECT departamentname 
          FROM departament 
          WHERE p.departamentid=departamentid) as "Название отдела"
FROM persons p
INNER JOIN (
      SELECT max_personid.*
      FROM (
            SELECT pco.personid
                  , COUNT(*) as counts
            FROM personcanteenorder pco
            WHERE pco.dateorder BETWEEN to_date('01.03.2019', 'dd.mm.yyyy')
                                    AND to_date('31.03.2019', 'dd.mm.yyyy')
            GROUP BY pco.personid
            ORDER BY counts DESC) max_personid
      WHERE max_personid.counts = (SELECT counts
                                    FROM (
                                    SELECT pco.personid
                                          , COUNT(*) as counts
                                    FROM personcanteenorder pco
                                    WHERE pco.dateorder BETWEEN to_date('01.03.2019', 'dd.mm.yyyy')
                                                            AND to_date('31.03.2019', 'dd.mm.yyyy')
                                    GROUP BY pco.personid
                                    ORDER BY counts DESC)
                                    WHERE rownum=1)
           ) champions
ON champions.personid = p.personid
