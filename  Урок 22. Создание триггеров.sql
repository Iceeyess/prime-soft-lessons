--https://rutube.ru/video/private/6e3b57480bde5aadf60848c8b36b5b2e/?p=Q2_ZMj9sUUMjMdb9ox1xlQ
--SQL. Урок 22. Создание триггеров
/*
CREATE [OR REPLACE] TRIGGER имя_триггера
{BEFORE | AFTER}
{INSERT | DELETE | UPDATE | UPDATE OF список_столбцов } ON имя_таблицы
[FOR EACH ROW]
[WHEN (...)]
[DECLARE ... ]
BEGIN
...исполняемые команды...
[EXCEPTION ... ]
END [имя_триггера];
*/

-- Создание триггера для добавления записей в personcars мой вариант до просмотра видео
--Так же реализовал логику обновления записи в persons, если 'автовладелец еще не определен'
CREATE OR REPLACE TRIGGER add_car_mark_trigger
AFTER
INSERT ON personcars
FOR EACH ROW
DECLARE
l_name_value persons.name%TYPE;
l_personid persons.personid%TYPE;
BEGIN
  --получение значения полей name, periodid
  SELECT NVL(MAX(name), '0'), NVL(MAX(personid), 0)  -- MAX чтобы не падала в NO_DATA_FOUND и внизу выполнялась команда INSERT
  INTO l_name_value, l_personid
    FROM persons
  WHERE :NEW.personid = personid;
  DBMS_OUTPUT.PUT_LINE('continue');  
  CASE 
    WHEN l_name_value = '0' AND l_personid = 0 THEN
      INSERT INTO persons (personid) VALUES(:NEW.personid);
    WHEN l_name_value NOT LIKE '%(автовладелец)%' THEN
      UPDATE persons
      SET name = name || ' (автовладелец)'
      WHERE personid = :NEW.personid;
  END CASE;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Произошла ошибка, нечего изменять. Текст ошибки:' || SQLERRM);
END add_car_mark_trigger;
/

select *
from persons where name NOT like '%автовладелец%';
ROLLBACK;
select *
from personcars where carname like '%автовладелец%';
INSERT INTO personcars(personid, carregnumber, carname) VALUES(18, 'Е495ВК77', 'Volkswager Touran');
INSERT INTO personcars(personid, carregnumber, carname) VALUES(20, 'Е495ВК77', 'Volkswager Touran');
INSERT INTO personcars(personid, carregnumber, carname) VALUES(24, 'Е495ВК77', 'Volkswager Touran');
INSERT INTO personcars(personid, carregnumber, carname) VALUES(1, 'БМВ1', 'Бумер');
--Решение учителя той же задачи, но решение проще, без вставки в personcars
CREATE TRIGGER TRG_PERSONCARS_INS
BEFORE INSERT ON personcars
FOR EACH ROW
BEGIN
  UPDATE persons
  SET name = name || ' (автовладелец)'
  WHERE personid = :new.personid
    AND name NOT LIKE '%автовладелец%';
    
  :new.carregnumber := '*****';
END;
/

alter trigger trigger_name  compile;

--------------------------------------------------------------------------------
select *
from filial;

CREATE SEQUENCE S_FILIAL
MINVALUE 1
START WITH 6
INCREMENT BY 1;
/
DROP SEQUENCE S_FILIAL;

CREATE OR REPLACE TRIGGER FILIAL_TRG_INSERT
BEFORE INSERT ON FILIAL
FOR EACH ROW
BEGIN
  :NEW.filialid := S_FILIAL.NEXTVAL;
END;
/
INSERT INTO filial
(filialname) values('Смоленск');
--------------------------------------------------------------------------------
--Домашнее задание урока 22
--1. Добавить в таблицу "Сотрудники"(persons) столбец "Дата увольнения" и сделать его по умолчанию NULL – то есть, если дата увольнения не указана, сотрудник считается работающим.
--2. Создать триггер, который срабатывает при обновлении записи в таблице "Сотрудники". Если в поле "Дата увольнения" указана дата, удалить все мобильные телефоны увольняющегося сотрудника.
--3. Создать сиквенс (последовательность) для таблицы CanteenDishes**, учитывая последний выданный DishID.
--4. Создать триггер, который срабатывает перед вставкой записи в таблицу CanteenDishes, чтобы сгенерировать новый идентификатор с использованием сиквенса из задания 3.

--Выполнение
--1.
ALTER TABLE persons ADD termination_date DATE DEFAULT NULL;
--2.
CREATE OR REPLACE TRIGGER delete_mobile_phones
BEFORE UPDATE OF termination_date
ON persons
FOR EACH ROW
WHEN (NEW.termination_date IS NOT NULL AND OLD.termination_date IS NULL)
  BEGIN
    UPDATE phones
    SET phones.phone_number = NULL
    WHERE UPPER(phones.phone_type) = UPPER('Мобильный')
          AND :NEW.personid = phones.personid;
    --Коммит не делаю, т.к. их не рекомендуют делать. Но все равно не пойму почему.
  END;
/
-------------------------------------------------------------------------------
--Для проверки--
select *
from persons;
update persons
set termination_date = TRUNC(sysdate)
where personid = 1;
-------------------------------------------------------------------------------
--3.
CREATE SEQUENCE canteendishes_s
MINVALUE 1
START WITH 42
MAXVALUE 9999999999999999
INCREMENT BY 1
CYCLE
CACHE 20;
--4.
CREATE OR REPLACE TRIGGER create_dish_id_t
BEFORE INSERT ON canteendishes
FOR EACH ROW
BEGIN
  :NEW.dishid := canteendishes_s.NEXTVAL;
END;
/
INSERT INTO canteendishes(dishname, dishtype, price, cookid) values
('Жареная утка под апельсиновым соусом', 3, 1500, 1);  --тестирование
ROLLBACK; --тестирование