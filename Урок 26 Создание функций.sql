--https://rutube.ru/video/private/02799061454902e02ddc17ce7cb95cb1/?p=RLmxnmbEnj4ZrCmqtDbI2Q
--SQL. Урок 26 Создание функций

CREATE OR REPLACE FUNCTION GET_NDS(SUMMA IN NUMBER)
RETURN NUMBER
IS
RES NUMBER;
BEGIN
  RES := SUMMA * CASE
                   WHEN SYSDATE >= TO_DATE('01-01-2026' ,'dd-mm-yyyy') THEN 0.22
                   WHEN SYSDATE >= TO_DATE('01-01-2019' ,'dd-mm-yyyy') THEN 0.20
                   ELSE 0.18
                 END;
  RETURN RES;
END;
/

SELECT GET_NDS(100) NDS FROM DUAL;

SELECT dishname
      , price
      , GET_NDS(price)NDS
FROM canteendishes;

SELECT *
FROM pro;


CREATE OR REPLACE FUNCTION GET_OSTATOK(p_id_tovar IN tovar.id_tovar%TYPE)
RETURN NUMBER AS
  l_prihod NUMBER;
  l_rashod NUMBER;
  l_itog   NUMBER;
BEGIN

  SELECT nvl(SUM(qty), 0)
    INTO l_prihod
    FROM PRO
   WHERE id_tovar = p_id_tovar
     AND is_prihod = 1;
     
  SELECT nvl(SUM(qty), 0)
    INTO l_rashod
    FROM PRO
   WHERE id_tovar = p_id_tovar
     AND is_prihod = 0;
     
  l_itog := l_prihod - l_rashod;
  RETURN l_itog;
  
END;
/

SELECT t.id_tovar
      , t.name_tovar
      , GET_OSTATOK(t.id_tovar) ostatok
FROM tovar t;

select 1 - null from dual;  --число минус пусто будет пусто

--------------------------------------------------------------------------------
На скриншоте представлен текст:

---
/*
# Практические задачи к Уроку 26
1. Написать функцию, возвращающую номер мобильного телефона сотрудника по 
переданному PersonID. Если у сотрудника более одного мобильного телефона, то 
возвращать любой. Если у сотрудника нет ни одного мобильного телефона, то возвращать 
любой рабочий. Если нет рабочего телефона, то возвращать текст "Телефон отсутствует".

2. Написать функцию, возвращающую цену товара по переданному ид товара. Необходимо 
возвращать текущую цену товара, то есть на максимально позднюю дату установки цены, 
но не позднее текущей даты. **Задача повышенной сложности.**
*/
--------------------------------------------------------------------------------
--Реализация задания №1
CREATE OR REPLACE FUNCTION get_phone(p_person_id IN persons.personid%TYPE)
RETURN phones.phone_number%TYPE IS
  v_mobile_num phones.phone_number%TYPE;
  v_work_num   phones.phone_number%TYPE;
  v_result     phones.phone_number%TYPE;
BEGIN
  SELECT MAX(phone_number) --чтобы не уходила в ошибку и давала максимальный тел.
    INTO v_mobile_num
    FROM phones
   WHERE personid = p_person_id AND lower(phone_type) = lower('мобильный');
   
  SELECT MAX(phone_number)
    INTO v_work_num
    FROM phones
   WHERE personid = p_person_id AND lower(phone_type) = lower('рабочий');
  
  v_result := COALESCE(v_mobile_num, v_work_num, 'Телефон отсутствует');
   RETURN v_result;
END;
/
--for verification:
SELECT p.*
      , GET_PHONE(p.personid)
FROM persons p;
--------------------------------------------------------------------------------
--Реализация задания №2
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_price(p_id_tovar IN price_list.id_tovar%TYPE)
RETURN  price_list.price%TYPE IS
v_price price_list.price%TYPE;
BEGIN
  SELECT MAX(price)
    INTO v_price
    FROM price_list
   WHERE id_tovar = p_id_tovar AND date_price <= SYSDATE;
  RETURN v_price;
END;
/

SELECT t.*
      , GET_PRICE(t.id_tovar)
FROM tovar t;