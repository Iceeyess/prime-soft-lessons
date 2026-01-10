--https://rutube.ru/video/private/7ae0abfc849f0517296c9ce7af744f00/?p=Bb5uONjqayFQaJl4LFKl6g

INSERT INTO persons
(personid, name, birthdate, departamentid, filialid)
VALUES(
        NVL((SELECT MAX(personid) FROM persons), 0) + 1, 
        'Газманова Александра Алексеевна', 
        to_date('12.03.1981', 'dd.mm.rr'), 
        1, 
        1
        );
COMMIT;


UPDATE persons 
SET personid = 22 
WHERE personid = 23;

INSERT INTO PersonPayments
(personid, sum, period)
(SELECT t.personid
      , t.sum
      , to_date(TO_CHAR(t.period, 'DD') || '.' || TO_CHAR(TO_NUMBER(TO_CHAR(t.period, 'MM')) + 1) || '.' || TO_CHAR(t.period, 'YYYY'), 'dd.mm.yyyy')
FROM PersonPayments t 
WHERE EXTRACT(MONTH FROM t.period) = 5);
COMMIT;

--можно было и проще поступить:
SELECT t.personid
      , t.sum
      , t.period --ADD_MONTHS(t.period, 1)
FROM PersonPayments t 
WHERE EXTRACT(MONTH FROM t.period) = 7;

INSERT INTO personpayments
(personid, sum, period)
SELECT t.personid
      , CASE
          WHEN EXISTS(SELECT * FROM personcars WHERE personid = t.personid)
            THEN ROUND(t.SUM * 1.02, 2)
          ELSE
            t.sum
        END
      , to_date('01.07.2019', 'dd.mm.rr')
FROM PersonPayments t 
WHERE t.period BETWEEN TO_DATE('01.06.2019', 'dd.mm.yyyy') AND 
              LAST_DAY('01.06.2019');
COMMIT;


--Практические задачи к Уроку 15
--Добавить новый филиал в таблицу Filials.
--Добавить новое закупаемое блюдо, указав название, категорию блюда, цену.
--Начислить всем сотрудникам зарплату за июнь такую же как за май, но с надбавкой сотрудникам, делавшим заказы в столовой за май на сумму, большую на 50% от той суммы, на которую был сделан заказ.

-- Урок № 15 ДЗ № 1
INSERT INTO filial
(filialid, filialname)
VALUES
((SELECT MAX(filialid) + 1 FROM filial), 'Калуга');
COMMIT;

-- Урок № 15 ДЗ № 2 Решил сделать через PL/SQL анонимный блок, с явной блокировкой таблицы, чтобы dishid никто не смог параллельно читать
SET SERVEROUTPUT ON  -- для работы с буфером через пакет DBMS_OUTPUT / вывод на экран
DECLARE
l_dishid canteendishes.dishid%TYPE;
l_dishname canteendishes.dishname%type;
l_dishtype dishtype.dishtype%TYPE;
l_price canteendishes.price%TYPE;
BEGIN
  --Явная блокировка таблицы в эксклюзивном режиме
  LOCK TABLE canteendishes IN EXCLUSIVE MODE NOWAIT;
  
  SELECT nvl(MAX(dishid), 0) + 1
  INTO l_dishid
  FROM canteendishes;
  l_dishname := 'филе сёмги';
  SELECT dishtype
  INTO l_dishtype
  FROM dishtype
  WHERE dishtype = 3;
  
  l_price := 1000;
  -- Далее, вставляем данные в таблицу и коммитим
  INSERT INTO canteendishes
  (dishid, dishname, dishtype, price)
  VALUES
  (l_dishid, l_dishname, l_dishtype, l_price);
  DBMS_OUTPUT.PUT_LINE('В таблицу canteendishes были вставлены данные ID ' || dishid);
  
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Что-то явно пошло не так, проверьте код.');
    ROLLBACK;
END;
/

-- Урок № 15 ДЗ № 3
INSERT INTO personpayments (personid, sum, period)
SELECT pp.personid
      , CASE 
          --Если закупался в мае , то прибавляется 50% от стоимости закупок еды по price колонки canteendishes в мае.
          WHEN nvl((SELECT 
                      SUM((SELECT price 
                            FROM canteendishes 
                            WHERE canteendishes.dishid = pco.dishid))
                    FROM personcanteenorder pco
                    WHERE pco.personid = pp.personid and pco.dateorder BETWEEN TO_DATE('01.05.2019', 'dd.mm.rrrr') AND 
                        LAST_DAY('01.05.2019')), 0) > 0 
                    THEN
                    pp.sum + 
                    (SELECT SUM((SELECT price FROM canteendishes WHERE canteendishes.dishid = pco.dishid))
                    FROM personcanteenorder pco
                    WHERE pco.personid = pp.personid AND pco.dateorder BETWEEN TO_DATE('01.05.2019', 'dd.mm.rrrr') AND 
                        LAST_DAY('01.05.2019')) * 0.5
          --Если не закупались в мае, то просто начисление оклада мая в июнь
          ELSE
            pp.sum
        END as new_sum
        , ADD_MONTHS(pp.period, 1)
FROM (SELECT * FROM personpayments WHERE period BETWEEN TO_DATE('01.05.2019', 'dd.mm.rrrr') AND 
                        LAST_DAY('01.05.2019')) pp;
COMMIT; -- не забудьте закоммитить.
    
    
-- Вспомогательный запрос показывает реальные покупки персонала еды в мае и на точную сумму
select pco.personid, SUM(c.price) 
from personcanteenorder pco, canteendishes c 
WHERE c.dishid = pco.dishid 
  And extract(month from dateorder) = 5
group by pco.personid;
              
-- В этом запросе показано неверное сцепление таблиц, поскольку поле personid таблицы personpayments имеет 5-кратное повторение                        
select pp.personid, SUM(c.price) 
from personpayments pp, personcanteenorder pco, canteendishes c 
where pp.personid = pco.personid
  AND c.dishid = pco.dishid 
  And extract(month from pp.period) = 5
group by pp.personid;
                        
-- В условии приходится двукратно добавлять 2 условия с датами, поскольку у нас надо, чтобы даты брались из окладов выплаченных в мае, а так же закупках еды, тоже в мае, иначе будет неверная сумма                      
select pp.personid, SUM(c.price) 
from personpayments pp, personcanteenorder pco, canteendishes c 
where pp.personid = pco.personid
  AND c.dishid = pco.dishid 
  And extract(month from pp.period) = 5
  AND extract(month from pco.dateorder) = 5
group by pp.personid;                      
                        