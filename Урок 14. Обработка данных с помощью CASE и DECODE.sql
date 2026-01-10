SELECT t.*
      , CASE
          WHEN filialid = 1 THEN
            'Главный офис'
          WHEN filialid = 2 THEN
            'Почти главный офис'
          ELSE
            'Филиал'
        END Type_filial_v1
      , DECODE(filialid, 
                1, 'Главный офис',
                2, 'Почти главный офис'
                , 'Филиал'
                ) Type_filial_v2
FROM persons t;

SELECT info_
      , COUNT(personid)
  FROM (
SELECT p.*
      , CASE
          WHEN (SELECT SUM(SUM)
                FROM personpayments
                WHERE personid = p.personid
                  AND period between to_date('01.05.2019', 'dd.mm.yyyy')
                  AND LAST_DAY('01.05.2019')
                ) >= 100000 THEN
                'Высокая'
          WHEN (SELECT SUM(SUM)
                FROM personpayments
                WHERE personid = p.personid
                  AND period between to_date('01.05.2019', 'dd.mm.yyyy')
                  AND LAST_DAY('01.05.2019')
                ) >= 80000 AND EXISTS (SELECT 1 
                                        from personcars 
                                        WHERE personid = p.personid) THEN
                'Хорошая'
          ELSE
            'Ниже среднего'
        END info_
  FROM persons p
)
GROUP BY info_;

--Урок № 14 ДЗ № 1 v1
SELECT p.name
  , CASE
      WHEN EXISTS(SELECT 1 FROM personcars WHERE personcars.personid = p.personid) THEN
        'автовладелец'
    END Cars
FROM persons p;

--Урок № 14 ДЗ № 1 v2
SELECT p.name
  , DECODE(
      (SELECT COUNT(*) FROM personcars WHERE personcars.personid = p.personid AND ROWNUM = 1), 0, NULL,
        '1', 'автовладелец') Cars
FROM persons p;

--Урок № 14 ДЗ № 1 v3
SELECT p.name
    , NVL2((SELECT MAX(1) FROM personcars WHERE personcars.personid = p.personid), 'автовладелец', NULL) Cars
FROM persons p;

--Урок № 14 ДЗ № 2
SELECT dish_cooks
      , COUNT(dish_cooks)
FROM (SELECT NVL2(cookid, 'готовящиеся', 'закупающиеся') as dish_cooks
      FROM canteendishes)
GROUP BY dish_cooks;

--Урок № 14 ДЗ № 3
SELECT t.filials "Филиалы"
      , count(t.filials) as "Кол-во сотрудников других филиалов"
FROM (SELECT DECODE(filialid, 1, 'Москва', 'Другой филиал') filials
FROM persons p) t
group by t.filials;