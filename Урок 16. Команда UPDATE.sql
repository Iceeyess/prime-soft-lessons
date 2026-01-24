--SQL. Урок 16. Команда UPDATE
--https://rutube.ru/video/private/a74185e08d69ad136eed8aa1fa969366/?p=01XixaMinWJmCpcxhNgjUw
--Решение предыдущей задачи урока 15 № 3 
INSERT INTO personpayments
(personid, sum, period)
SELECT pp.personid
      ,pp.SUM
      + nvl((SELECT SUM(c.price)
           FROM personcanteenorder pco
     INNER JOIN canteendishes c ON c.dishid = pco.dishid
          WHERE pco.personid = pp.personid
            AND pco.dateorder BETWEEN TO_DATE('01.05.2019', 'dd.mm.yyyy') 
                    AND TO_DATE('31.05.2019', 'dd.mm.yyyy')), 0) * 0.5
      ,ADD_MONTHS(pp.period, 1)
FROM personpayments pp
WHERE pp.period BETWEEN TO_DATE('01.05.2019', 'dd.mm.yyyy') 
                    AND TO_DATE('31.05.2019', 'dd.mm.yyyy');
ROLLBACK;

--обновление простых данных у Лимонадова Анна Васильевна
UPDATE persons
SET filialid = 1,
    birthdate = TO_DATE('12.03.77', 'dd.mm.rr')
WHERE personid = 5;

-- изменение данных по зпл за июнь для тех, у кого авто дают больше % от зпл на 10%
UPDATE personpayments
SET SUM = SUM + SUM * CASE
                  WHEN personid IN (SELECT personid IN personcars) THEN
                    100 * 20
                  ELSE
                    100 * 10
                END 
FROM personpayments
WHERE period BETWEEN TO_DATE('01.06.2019', 'dd.mm.yyyy') 
                 AND TO_DATE('30.06.2019', 'dd.mm.yyyy')
  AND personid IN (SELECT DISTINCT personid FROM personcars);
  
/*Практические задачи к Уроку 16
Изменить у сотрудника с PersonID = 2 значение в графе DepartamentID со значения 3 на 1.
Сотрудница «Сливкина Наталья Эдуардовна» вышла замуж. Надо в графе ФИО проставить «Марковна Наталья Эдуардовна».
Сотрудникам, которые являются автовладельцами, необходимо в графу NAME дописать после их ФИО значение «(автовладелец)».
Сотрудникам, которые являются поварами, необходимо за последний месяц доначислить оклад, увеличить его на 5%.
Увеличить стоимость (цену) закупаемых товаров, реализуемых в столовой, на 7%. Результат должен быть округлен до целых рублей по правилам математики.*/

--Урок 16 ДЗ № 1
UPDATE persons
SET departamentid = 1
WHERE personid = 2;
ROLLBACK; -- для отката изменений в БД

--Урок 16 ДЗ № 2
UPDATE persons
SET name = 'Марковна Наталья Эдуардовна'
WHERE name = 'Сливкина Наталья Эдуардовна';
ROLLBACK; -- для отката изменений в БД

--Урок 16 ДЗ № 3 v1
UPDATE persons
SET name = CONCAT(name, ' (автовладелец)')
WHERE EXISTS (SELECT 1 FROM personcars WHERE personcars.personid = persons.personid);
ROLLBACK; -- для отката изменений в БД

--Урок 16 ДЗ № 3 v2
UPDATE persons
SET name = name || ' (автовладелец)'
WHERE personid IN (SELECT DISTINCT personid FROM  personcars);
ROLLBACK; -- для отката изменений в БД
COMMIT;

--Урок 16 ДЗ № 4 v1
UPDATE personpayments
SET sum = sum * 1.05
WHERE period = (SELECT MAX(period) FROM personpayments)
  AND personid IN (SELECT DISTINCT cookid FROM canteendishes WHERE cookid IS NOT NULL);
ROLLBACK; -- для отката изменений в БД

--Урок 16 ДЗ № 4 v2
SET SERVEROUTPUT ON
DECLARE
  TYPE personid_type IS TABLE OF persons.personid%TYPE;
  l_personid_arr personid_type;
  l_modified_personid personid_type;
BEGIN

  SELECT DISTINCT cookid BULK COLLECT INTO l_personid_arr
  FROM canteendishes
  WHERE cookid IS NOT NULL;
  --DBMS_OUTPUT.PUT_LINE(l_personid_arr.COUNT);
  FORALL ind IN l_personid_arr.FIRST..l_personid_arr.LAST
  UPDATE personpayments
  SET sum = sum * 1.05
  WHERE period = (SELECT MAX(period) FROM personpayments)
    AND personid = l_personid_arr(ind)
  RETURNING personid BULK COLLECT INTO l_modified_personid;
  -- исключения обрабатывать не стал, т.к. тест, COMMIT тоже не делал
  FOR i IN l_modified_personid.FIRST..l_modified_personid.LAST
  LOOP
    DBMS_OUTPUT.PUT_LINE('Исправил зпл для personid ' || l_modified_personid(i));
  END LOOP;
END;
/
ROLLBACK; -- для отката изменений в БД

--Урок 16 ДЗ № 5
UPDATE canteendishes
SET price = price * 1.07
WHERE cookid IS NULL;
ROLLBACK; -- для отката изменений в БД