--https://rutube.ru/video/private/2c37d4ad02aa8371289bb0745bc8d943/?p=T20mcOxKwM1kEMdkTpHcCw
--SQL Урок 21. Создание представлений (VIEW)

CREATE OR REPLACE VIEW PersonsInfo_v as  --OR REPLACE - если объект уже есть, то она заменяет
SELECT 
        p.*
      , d.departamentname
      , f.filialname
      , f.address
      , (SELECT TO_CHAR(MIN(period), 'Month yyyy')
           FROM personpayments
         WHERE personid = p.personid) as date_begin  --в представлении в подзапросах имена обязательны
         --Названия столбцов в представлении не должны пересекаться между собой/конфликтовать/повторяться. 
     , d.departamentid as d_departamentid 
FROM persons p
LEFT JOIN departament d
  ON d.departamentid = p.departamentid
LEFT JOIN filial f
  ON f.filialid = p.filialid;

--Созданное выше представление:
select *
from PERSONSINFO_V;

DROP view PERSONSINFO_V;

--Однако представление нельзя изменить через DML операции (UPDATE, DELETE, INSERT)

--Добавляем колонку Address через SQL запрос
ALTER TABLE filial ADD (Address VARCHAR2(200));
COMMIT;

-- Наполняем данными в адрес
UPDATE filial
SET address = 'г. Москва, ул. Красивых Молдавских партизан, д.1'
WHERE filialid = 1;
COMMIT;

CREATE MATERIALIZED VIEW PersonsInfo_v2 
REFRESH FORCE ON DEMAND  -- или ON COMMIT, в зависимости от ваших потребностей
AS
SELECT 
        p.PERSONID
      , p.name
      , p.BIRTHDATE
      , p.DEPARTAMENTID
      , p.filialid
      , d.departamentname
      , f.filialname
      , f.address
      , TO_CHAR(pp.min_period, 'Month yyyy')
     , d.departamentid as d_departamentid 
FROM persons p
LEFT JOIN departament d
  ON d.departamentid = p.departamentid
LEFT JOIN filial f
  ON f.filialid = p.filialid
LEFT JOIN (SELECT personid, MIN(period) as min_period
    FROM personpayments
    GROUP BY personid) pp
  ON pp.personid = p.personid;