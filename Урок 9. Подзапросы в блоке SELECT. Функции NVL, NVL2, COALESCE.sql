SELECT p.personid
      , p.name
      , p.birthdate
      , p.departamentid
      , nvl((SELECT departamentname FROM departament WHERE departamentid=p.departamentid),0) as departament
      , nvl((SELECT filialname FROM filial WHERE filialid = p.filialid), 0) as filial
FROM persons p;

SELECT p.*
      , (SELECT count(*)
          FROM personcars
          WHERE personid = p.personid) count_cars
FROM persons p;

SELECT p.*
      , periods.*
FROM persons p, (SELECT pp.personid, to_char(pp.period, 'Month-Year')
                  , sum(pp.sum)
                  FROM personpayments pp
                  GROUP BY pp.personid, to_char(pp.period, 'Month-Year') 
          ) periods
WHERE 1=1
  AND p.personid = periods.personid;
  
SELECT p.personid Tabnum
      , p.name FIO
      , NVL((SELECT SUM(sum)
          FROM personpayments 
          WHERE personid = p.personid
            AND period BETWEEN to_date('01.04.2019', 'dd.mm.yyyy') AND 
                               to_date('30.04.2019', 'dd.mm.yyyy')
                               ), 0) as nachisleno
      , NVL((SELECT SUM((SELECT cd.price FROM canteendishes cd WHERE c.dishid = cd.dishid))
          FROM personcanteenorder c
          WHERE c.personid = p.personid
            AND c.dateorder BETWEEN to_date('01.03.2019', 'dd.mm.yyyy') AND 
                               to_date('31.03.2019', 'dd.mm.yyyy')),0) zakaz_pred_month
      , NVL((SELECT SUM(sum)
          FROM personpayments 
          WHERE personid = p.personid
            AND period BETWEEN to_date('01.04.2019', 'dd.mm.yyyy') AND 
                               to_date('30.04.2019', 'dd.mm.yyyy')
                               ),0)
      - 
      NVL((SELECT SUM((SELECT cd.price FROM canteendishes cd WHERE c.dishid = cd.dishid))
          FROM personcanteenorder c
          WHERE c.personid = p.personid
            AND c.dateorder BETWEEN to_date('01.03.2019', 'dd.mm.yyyy') AND 
                               to_date('31.03.2019', 'dd.mm.yyyy')), 0) to_transfer
FROM persons p;

--Урок 9 ДЗ №1.
SELECT p.name
      , (SELECT COUNT(*) 
          FROM phones 
          WHERE phones.personid = p.personid 
            AND phones.phone_type = 'мобильный') as count_mobile_phones
      , (SELECT COUNT(*) 
          FROM phones 
          WHERE phones.personid = p.personid 
            AND phones.phone_type = 'рабочий') as count_work_phones
FROM persons p;

--Урок 9 ДЗ №2.
SELECT food.name
      , (SELECT COUNT(1)
          FROM canteendishes c
          WHERE c.dishtype = food.dishtype) as category_qty
FROM dishtype food;

--Урок 9 ДЗ №3. Первый вариант
SELECT c.dishid
      , c.dishname
FROM canteendishes c 
LEFT JOIN personcanteenorder pco ON pco.dishid = c.dishid AND pco.dateorder 
                                BETWEEN to_date('01.03.2019', 'dd.mm.yyyy')
                                    AND to_date('31.03.2019', 'dd.mm.yyyy')
WHERE pco.personid IS NULL
ORDER BY c.dishid;

--Урок 9 ДЗ №3. Второй вариант
SELECT c.dishid
      , c.dishname
FROM canteendishes c
WHERE NOT EXISTS(SELECT * 
              FROM personcanteenorder
              WHERE dishid = c.dishid
                AND dateorder BETWEEN to_date('01.03.2019', 'dd.mm.yyyy')
                                    AND to_date('31.03.2019', 'dd.mm.yyyy')
                )
ORDER BY c.dishid;

--Урок 9 ДЗ №3. Третий вариант
SELECT c.dishid
      , c.dishname
FROM canteendishes c
WHERE c.dishid NOT IN (
                        SELECT dishid
                        FROM personcanteenorder 
                        WHERE dateorder >= to_date('01.03.2019', 'dd.mm.rrrr')
                          AND dateorder <= to_date('31.03.2019', 'dd.mm.rrrr')
                          );
 --Урок 9 ДЗ №3. Четвертый вариант здесь часа 3 потратил и понял, что
 -- предыдущие 3 задачи сделал неправильно до этого момента, у меня не выводило 
 --1шт с dishid=35 , а около 23 штук dishid )) Заодно повторил коллекции,
 -- переменные среды и курсоры, еще и научился вычислять из коллекций разницы
DEFINE month_num = 3
SET SERVEROUTPUT ON
DECLARE
  
  TYPE cur_dish_month_type IS TABLE OF NUMBER;
  v_cur_dish_month  cur_dish_month_type;
  v_cur_dish_all        cur_dish_month_type;
  v_cur_dish_result cur_dish_month_type;
  
  v_dishname canteendishes.dishname%TYPE;
  
BEGIN
  --Записываем данные с данными месяца
  SELECT DISTINCT dishid
  BULK COLLECT INTO v_cur_dish_month
  FROM personcanteenorder
  WHERE &month_num = EXTRACT(month FROM dateorder);

  --Записываем общие данные
  SELECT dishid
  BULK COLLECT INTO v_cur_dish_all
  FROM canteendishes;

  --вычисляем разницу между двумя массивами
  v_cur_dish_result := v_cur_dish_all MULTISET EXCEPT v_cur_dish_month;
  
  IF v_cur_dish_result.COUNT >= 1 THEN
    FOR dish IN 1..v_cur_dish_result.COUNT
    LOOP
      SELECT dishname
      INTO v_dishname
      FROM canteendishes
      WHERE dishid=v_cur_dish_result(dish);
    
      DBMS_OUTPUT.PUT('dishid=' || v_cur_dish_result(dish) || ',');
      DBMS_OUTPUT.PUT_LINE('dishname=' || v_dishname);
    END LOOP;
  ELSE
      DBMS_OUTPUT.PUT_LINE('Нет коллекции');
  END IF;

END;
/

 --Урок 9 ДЗ №4.
 SELECT c.dishid
      , c.dishname
      , (SELECT count(pco.dishid) 
          FROM personcanteenorder pco
          WHERE pco.dateorder >= to_date('01/04/2019', 'dd/mm/yyyy')
            AND pco.dateorder <= to_date('30/04/2019', 'dd/mm/yyyy')
            AND pco.dishid = c.dishid
          ) as qty_sold
     , TO_CHAR((SELECT count(pco.dishid) 
          FROM personcanteenorder pco
          WHERE pco.dateorder >= to_date('01/04/2019', 'dd/mm/yyyy')
            AND pco.dateorder <= to_date('30/04/2019', 'dd/mm/yyyy')
            AND pco.dishid = c.dishid
          ) 
          * c.price,'999G999G999G999D00') as total_sold_amount
 FROM canteendishes c
 ORDER BY total_sold_amount DESC