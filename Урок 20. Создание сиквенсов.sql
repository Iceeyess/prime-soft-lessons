--SQL. Урок 20. Создание сиквенсов
--https://rutube.ru/video/private/6f3625686eb310fe8788c2112ade94bd/?p=TyljlnGeLwqfuLNRn_bkbA

--------------------------------------------------------------------------------
CREATE SEQUENCE S_TOVAR
MINVALUE 1  --необязательный элемент, показывает с чего будет начинаться номер после RECYCLE, то есть когда обнуление произойдет
MAXVALUE 5
START WITH 2  -- Этот параметр показывает с какой последовательности начнется нумерации при первом запуске последовательности до RECYCLE
INCREMENT BY 1
CYCLE
CACHE 2;  -- для кэширования и увеличения производительности

DROP SEQUENCE S_TOVAR;  -- удалить последовательность


select SYS_GUID() FROM DUAL; -- уникальный номер генерит, тоже может подойти как идентифкатор поля

SELECT S_TOVAR.NEXTVAL FROM DUAL;  --получение следующего числа последовательности
SELECT S_TOVAR.CURRVAL FROM DUAL;  -- текущая позиция последовательности текущей сессии, это важно!!!!!!!.
--при текущей сессии, если последовательность еще не была присвоена NEXTVAL при вызове CURRVAL даст ошибку:
--SQL Error [8002] [72000]: ORA-08002: sequence S_TOVAR.CURRVAL is not yet defined in this session
--Так же CURRVAL выдает текущее выданное следующее значение (NEXTVAL) при текущей сессии, а не в мире выданное текущее значение.Здесь большая разница.
/* Разберем пример:
Сессия 1:

sql
SELECT S_TOVAR.NEXTVAL FROM dual; -- Вернет 10
SELECT S_TOVAR.CURRVAL FROM dual; -- Вернет 10
-- CURRVAL в сессии 1 ЗАПОМНИЛСЯ как 10
Сессия 2 (параллельно):

sql
SELECT S_TOVAR.CURRVAL FROM dual; -- ОШИБКА! CURRVAL еще не определен
SELECT S_TOVAR.NEXTVAL FROM dual; -- Вернет 11 (это НОВОЕ значение)
-- Сессия 2 теперь имеет CURRVAL = 11

Сессия 1 (продолжение):

sql
SELECT S_TOVAR.CURRVAL FROM dual; -- ВСЕ ЕЩЕ 10!
-- Потому что CURRVAL - это ЛОКАЛЬНОЕ значение для сессии
*/

--команда вставки sequence 
ALTER TABLE TOVAR MODIFY (ID_TOVAR DEFAULT S_TOVAR.NEXTVAL);
--но лучше было сделать через триггер, т.к. универсальный способ для всех версий ОЕБС
-- но мы его еще не проходили.
--Пример:
CREATE OR REPLACE TRIGGER trigger_name
BEFORE INSERT ON TOVAR
FOR EACH ROW
BEGIN
  SELECT S_TOVAR.NEXTVAL INTO :new.ID_TOVAR FROM dual;
END;
--------------------------------------------------------------------------------
--Практические задачи к Уроку 20
--1. Создать сиквенсы для всех четырех таблиц: Товары, Группы товаров, Таблица прихода и расхода, Таблица изменения цен.
--2. Добавить в каждую таблицу минимум по одной строке. Убедиться, что сиквеньсы устанавливают корректные значения.
ALTER TABLE TOVAR MODIFY (ID_TOVAR DEFAULT S_TOVAR.NEXTVAL);

CREATE SEQUENCE S_PRO
MINVALUE 1
MAXVALUE 999999999999
START WITH 1
INCREMENT BY 1
NOCYCLE;

ALTER TABLE PRO MODIFY(ID DEFAULT S_PRO.NEXTVAL);

INSERT INTO PRO(
id_tovar
,is_prihod
,qty)
VALUES 
(1
,1
,1);

CREATE SEQUENCE S_GROUP_TOVAR
MINVALUE 1
MAXVALUE 999999999999
START WITH 1
INCREMENT BY 1
NOCYCLE;

ALTER TABLE GROUP_TOVAR MODIFY(ID_GROUP DEFAULT S_GROUP_TOVAR.NEXTVAL);

INSERT INTO GROUP_TOVAR(NAME_GROUP)
VALUES 
('Посуда');

CREATE SEQUENCE S_PRICE_LIST
MINVALUE 1
MAXVALUE 9999999999
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

INSERT INTO PRICE_LIST(ID_TOVAR, DATE_PRICE, PRICE)
VALUES 
(1, TO_DATE('01.01.2026', 'DD.MM.YYYY'), 30);
