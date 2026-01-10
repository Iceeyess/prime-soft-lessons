--SQL. Урок 12. Объединение множеств с помощью UNION и UNION ALL
--https://rutube.ru/video/private/4f14dc456c847c052d9ddce14ecab354/?p=zcGNUHIhlVCyLYTb_vmKiA
SELECT p.name
      , p.birthdate
      , p.departamentid
FROM persons p
UNION ALL
select FIO
      , NULL
      , departamentid
FROM personsexternal;

SELECT name, birthdate, departamentid
FROM persons
WHERE EXISTS (SELECT * 
              FROM personcars
              WHERE personid = persons.personid)
UNION ALL
SELECT name, birthdate, departamentid
FROM persons
WHERE EXISTS (SELECT * 
              FROM filial
              WHERE filialname = 'Москва'
              AND filialid = persons.filialid)
UNION   -- Если хотя бы 1н есть UNION , то делается уникальность ко всем данным, несмотря даже на то, что будеь UNION ALL выше.
SELECT name, birthdate, departamentid
FROM persons
WHERE EXISTS (SELECT * 
              FROM personcars
              WHERE personid = persons.personid);

SELECT TO_CHAR(TO_DATE(mm.NN, 'mm'), 'MONTH')
      , TO_CHAR(TO_DATE('01.' || LPAD(mm.NN, 2, '0') || '.2019', 'dd.mm.yyyy'), 'Month')
      , (SELECT COUNT(*)
        FROM persons p
        WHERE EXTRACT(MONTH FROM p.birthdate) = mm.NN) CNT_PERSONS
FROM(
    SELECT 1 NN FROM dual
    UNION
    SELECT 2 FROM dual
    UNION
    SELECT 3 FROM dual
    UNION
    SELECT 4 FROM dual
    UNION
    SELECT 5 FROM dual
    UNION
    SELECT 6 FROM dual
    UNION
    SELECT 7 FROM dual
    UNION
    SELECT 8 FROM dual
    UNION
    SELECT 9 FROM dual
    UNION
    SELECT 10 FROM dual
    UNION
    SELECT 11 FROM dual
    UNION
    SELECT 12 FROM dual
) mm;

--Урок 12 ДЗ № 1
SELECT name "ФИО"
      , birthdate "День Варенья"
      , (SELECT phone_number
          FROM phones 
          WHERE phones.personid=p.personid
          AND phones.phone_type = 'мобильный'
          AND ROWNUM = 1 --на всякий пожарный
          ) as "Мобильный"
FROM persons p
UNION
SELECT  FIO
      , NULL
      , CONTACT_MOBILE_PHONE
FROM personsexternal;

--Урок 12 ДЗ № 2 Версия 1
-- Не особо понятно точно в каком виде хотел получить группировку, поэтому разделю на версии
SELECT (SELECT departamentname 
        FROM departament 
        WHERE departament.departamentid = t.departamentid) as "Департамент"
      , COUNT(*) as "Кол-во сотрудников"
FROM (SELECT departamentid
              , personid
              , name
        FROM persons p
        UNION ALL  -- all потому что вдруг, и там, и там есть один и тот же сотрудник, но в разных департаментах )) смешанная должность или не усппели удалить из старой должности
        SELECT  departamentid
              , pe.id
              , pe.FIO
        FROM personsexternal pe
      ) t
GROUP BY departamentid;

--Урок 12 ДЗ № 2 Версия 2
SELECT Employee_location as "Местонахождение"
      , (SELECT departamentname 
        FROM departament 
        WHERE departament.departamentid = t.departamentid) as "Департамент"
      , COUNT(personid) as "Кол-во сотрудников"
FROM(
SELECT 'Собственные' as employee_location
       , p1.*
FROM (SELECT departamentid
              , personid
              , name
          FROM persons p) p1
UNION ALL
SELECT 'Внештатные' as employee_location
       , p2.*
FROM (SELECT  departamentid
              , pe.id
              , pe.FIO
        FROM personsexternal pe) p2
        ) t
GROUP BY Employee_location
        , departamentid;

--Урок 12 ДЗ № 3
SELECT COUNT(*) as "Общее кол-в внештатных сотрудников"
FROM personsexternal