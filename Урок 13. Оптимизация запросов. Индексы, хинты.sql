--SQL. Урок 13. Оптимизация запросов. Индексы, хинты
--В тринадцатом уроке есть небольшая опечатка. Правильный синтаксис хинта индекса:
/*+ index(имя_таблицы_или_алиас имя_индекса) */
--https://rutube.ru/video/private/c6815b137ec703230db339d5e2015648/?p=zn-Cs3dlSTtPM1OtcaGmOg
SELECT /*+ index pp PERSONPAYMPERSID */ * 
  FROM PersonPayments pp
  INNER JOIN Persons p
  ON p.personid = pp.personid
WHERE 1=1
  AND pp.personid = 12;
  
SELECT *
FROM Persons p
WHERE UPPER(p.name) = '��%';

-- ���� �13 �� � 1
SELECT c.dishname "������������ �����"
       , count(dishname) as "��������� ���-��"
  FROM canteendishes c
LEFT OUTER JOIN personcanteenorder pco ON pco.dishid = c.dishid
WHERE 1=1
      AND pco.dateorder between to_date('01.02.2019', 'dd.mm.yyyy') AND LAST_DAY('01.02.2019')
GROUP BY c.dishname
HAVING count(dishname) >= 15;

-- ���� �13 �� � 2
SELECT c.dishname
       , c.price -- �������� ���� �� �� ������� �������, ����� ������� ����������, ���� �� ����� �������������
       , avg_cat_price.avg_price -- �������� ���� �� �� ������� �������, ����� ������� ����������, ���� �� ����� �������������
  FROM canteendishes c
INNER JOIN (SELECT c.dishtype, 
                   ROUND(AVG(c.price), 2) as avg_price
              FROM canteendishes c
              INNER JOIN dishtype dt ON c.dishtype = dt.dishtype
              GROUP BY c.dishtype
              ) avg_cat_price ON avg_cat_price.dishtype = c.dishtype
WHERE c.price > avg_cat_price.avg_price;

-- ���� �13 �� � 3
SELECT *
FROM PersonCanteenOrder pco
WHERE pco.PersonID = 15;

-- ���� �13 �� � 4
-- ����� F5 ���������� ���� �������

-- ���� �13 �� � 5
CREATE INDEX IndPersID ON PersonCanteenOrder (PersonID);

-- ���� �13 �� � 6
SELECT /*+ index (pco) */ *
FROM PersonCanteenOrder pco
WHERE PersonID = 15;

-- ���� �13 �� � 7
--�������� ��������� �� ���� �������, ������-�� �� ������ �������
