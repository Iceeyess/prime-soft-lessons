--SQL. Урок 11. ПОЛЕЗНЫЕ ФУНКЦИИ ДЛЯ РАБОТЫ С ДАННЫМИ
--https://rutube.ru/video/private/f0ceeb77db862ba6dc9409a3225a7290/?p=UsSSvxIdyKYuBeTZ9XJ3Jg
-- решали прошлую домашку вместе
SELECT d.departamentname
      , COUNT(DISTINCT pc.personid) as qty_cars
FROM departament d
LEFT OUTER JOIN persons p ON p.departamentid = d.departamentid
LEFT OUTER JOIN personcars pc ON pc.personid = p.personid
GROUP BY d.departamentname;
-- решали прошлую домашку вместе
SELECT t.*
FROM (SELECT p.*
            , (SELECT COUNT(*)
                FROM personcanteenorder pco
                WHERE pco.personid = p.personid AND pco.dateorder BETWEEN 
                    to_date('01.03.2019', 'dd.mm.yyyy')
                AND to_date('31.03.2019', 'dd.mm.yyyy')) as qty_orders
      FROM persons p) t
WHERE t.qty_orders = (SELECT MAX(COUNT(*))
                        FROM personcanteenorder pco
                      WHERE pco.dateorder BETWEEN 
                            to_date('01.03.2019', 'dd.mm.yyyy')
                        AND to_date('31.03.2019', 'dd.mm.yyyy')
                      GROUP BY pco.personid);

--текстовые функции
SELECT p.name
      , LENGTH(p.name) as l_length
      , INSTR(p.name, 'льевна', 4)
      , TRANSLATE(p.name, 'абвгде', 'бвгдеж')
      , SUBSTR(p.name, 1, INSTR(p.name, ' ') - 1)
      , REGEXP_SUBSTR(p.name, '\S+')
      , TRIM(' asda sdasd ')
FROM persons p;

--еще функции
SELECT ph.*
      , regexp_replace(ph.phone_number, '[^0-9]', '')
      , LPAD(ph.phone_number, 20, '0')
      , RPAD(ph.phone_number, 20, '0')
FROM phones ph;

--и еще функции
SELECT p.name || ' имеет машин ' || (SELECT COUNT(*) 
                                      FROM personcars 
                                      WHERE personid=p.personid) INFO
FROM persons p;

--математические функции
SELECT sum, CEIL(sum) FROM personpayments;
SELECT sum, ROUND(sum, 2) FROM personpayments;
SELECT sum, FLOOR(sum) FROM personpayments;

-- функции с датами
SELECT SYSDATE FROM DUAL;
SELECT SYSTIMESTAMP FROM DUAL;
SELECT to_date('10.01.2019', 'dd.mm.yyyy') - to_date('08.01.2019', 'dd.mm.yyyy')
FROM DUAL;
SELECT SYSDATE - to_date('08.01.2019', 'dd.mm.yyyy')
FROM DUAL;
SELECT SYSDATE - to_date('08.01.2019', 'dd.mm.yyyy')
FROM DUAL;
SELECT to_date('10.06.2019 10:00:00', 'dd.mm.yyyy hh24:mi:ss') + INTERVAL '1' MONTH
FROM DUAL;
SELECT ADD_MONTHS(to_date('10.06.2019 10:00:00', 'dd.mm.yyyy hh24:mi:ss'), 1) 
FROM DUAL;
SELECT ADD_MONTHS(to_date('10.06.2019 10:00:00', 'dd.mm.yyyy hh24:mi:ss'), -2) 
FROM DUAL;
SELECT MONTHS_BETWEEN(SYSDATE, to_date('08.01.2019 10:00:00', 'dd.mm.yyyy hh24:mi:ss'))
FROM DUAL;
/*
INSERT INTO persons (personid, name, birthdate, departamentid, filialid)values(22, 'Василий Али-бабаич', '02.02.1948', 1, 2);

SELECT *
FROM persons 
MINUS
SELECT *
FROM persons
AS OF timestamp SYSTIMESTAMP - INTERVAL '1' HOUR;

ROLLBACK;
*/
-- Урок 11 ДЗ № 1
SELECT p.name as "ФИО"
      , birthdate as "Дата рождения"
      , FLOOR((SYSDATE - birthdate) / 365) || ' года' as "Возраст" 
FROM persons p;

-- Урок 11 ДЗ № 2
SELECT dishname "Наименование блюда"
      , price "Цена без НДС"
      , ROUND(price * 0.2, 2) as "НДС 20%"
      , ROUND(price * 0.22, 2) as "НДС 22%"
FROM canteendishes;

-- Урок 11 ДЗ № 3 вариант 1
--List of birthdates
SELECT p.name
      , p.birthdate
FROM persons p
WHERE EXTRACT(MONTH FROM p.birthdate) = EXTRACT(MONTH FROM ADD_MONTHS(SYSDATE, 1));

-- Урок 11 ДЗ № 3 вариант 2
SELECT p.name
      , p.birthdate
FROM persons p
WHERE EXTRACT(MONTH FROM p.birthdate) = EXTRACT(MONTH FROM SYSTIMESTAMP + INTERVAL '1' MONTH);

-- Урок 11 ДЗ № 3 вариант 3

SELECT p.name
      , p.birthdate
FROM persons p
WHERE TO_NUMBER(TO_CHAR(p.birthdate, 'mm'), '99') =  TO_NUMBER(TO_CHAR(SYSTIMESTAMP + INTERVAL '1' MONTH, 'mm'), '99');
