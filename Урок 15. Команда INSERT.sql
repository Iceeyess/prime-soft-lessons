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


