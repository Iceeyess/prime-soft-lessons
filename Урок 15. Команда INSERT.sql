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
      , ADD_MONTHS(t.period, 1)
FROM PersonPayments t 
WHERE EXTRACT(MONTH FROM t.period) = 5;

  

