--Урок 17. Команда DELETE
--https://rutube.ru/video/private/7855b4c5c3db0288ba02a97d46b93457/?p=hh-SNbwuZeEzesU5rDySow

--1. Удалить филиал «Ярославль» (FiliallD = 4).
--2. Удалить все начисления заработных плат за июнь 2019 года.
--3. Удалить сотрудников, не имеющих автомобиля.
--4. Удалить в графе «ФИО» фразу «(автовладелец)» во всех случаях её присутствия.
--5. Удалить мобильные номера телефонов из базы данных.

--ДЗ № 17 Задание № 1
DELETE FROM filial
WHERE filialname = 'Ярославль';
rollback;

--ДЗ № 17 Задание № 2 Решил немного вспомнить преобразовательные функции и Bind переменные. Запускать все вместе от "VARIABLE" до "LAST_DAY(TO_DATE(:month, 'mm-yyyy'));"
VARIABLE month VARCHAR2(20);
EXEC :month := '06-2019';
DELETE FROM personpayments
WHERE period BETWEEN TO_DATE(:month, 'mm-yyyy') AND LAST_DAY(TO_DATE(:month, 'mm-yyyy'));
rollback;

--ДЗ № 17 Задание № 2 вариант 2 без выпендривания
DELETE FROM personpayments
WHERE period BETWEEN TO_DATE('01-06-2019', 'dd-mm-yyyy') AND TO_DATE('30-06-2019', 'dd-mm-yyyy');
rollback;

--ДЗ № 17 Задание № 3 v.1
DELETE FROM persons p
WHERE NOT EXISTS(SELECT 1 FROM personcars WHERE personcars.personid = p.personid);
rollback;

--ДЗ № 17 Задание № 3 v.2
DELETE FROM persons p
WHERE p.personid NOT IN (SELECT personid FROM personcars);

--ДЗ № 17 Задание № 4 v.1
UPDATE persons
SET name = SUBSTR(name, 1, INSTR(name, '(автовладелец)') - 2)
WHERE name LIKE '%(автовладелец)';
ROLLBACK;
COMMIT; -- выберите по желанию

--ДЗ № 17 Задание № 4 v.2
UPDATE persons
SET name = RTRIM(name, ' (автовладелец)')
WHERE name LIKE '%(автовладелец)%';

--ДЗ № 17 Задание № 5
DELETE FROM phones
WHERE phone_type = 'мобильный';
ROLLBACK; -- выберите по желанию
COMMIT; -- выберите по желанию

