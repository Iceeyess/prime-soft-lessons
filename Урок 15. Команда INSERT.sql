https://rutube.ru/video/private/7ae0abfc849f0517296c9ce7af744f00/?p=Bb5uONjqayFQaJl4LFKl6g

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


