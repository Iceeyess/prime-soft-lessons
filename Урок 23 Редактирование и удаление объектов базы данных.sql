--https://rutube.ru/video/private/c7d3e83e8a568a369bb1c3dd25f86897/?p=yZUeFXQitzCAbpWC0jyOwg
--SQL. Урок 23 Редактирование и удаление объектов базы данных

--Изменение объекта
--1)добавления столбца
ALTER TABLE persons ADD has_dms NUMBER(1) DEFAULT 0;
-- команды DDL не требует подтверждения записи транзакции через DTL (COMMIT/ROLLBACK) Сразу применяются в БД.

--2)Удаление столбца
ALTER TABLE persons DROP COLUMN has_dms;

--для того чтобы удалить любой другой объект БД надо сделать через команду DROP
DROP TRIGGER FILIAL_TRG_INSERT;

--**Практические задачи к Уроку 23**
--1. Добавить столбец в таблицу Persons – HAS_CHILDREN Типа number(1) и с примечанием 0=нет детей, 1=дети есть. По-умолчанию 0.
--2. Удалить триггер, созданный для таблицы CanteenDishes.
--3. Доработать CanteenDishes, сделать автоустановку DishID из сиквенса, сделанного на прошлом уроке для этой таблицы, с помощью свойства Default столбца.
--Выполнение:

--Задание № 1
ALTER TABLE persons ADD HAS_CHILDREN NUMBER(1) DEFAULT 0;
COMMENT ON COLUMN persons.HAS_CHILDREN IS '0=нет детей, 1=дети есть';
--Задание № 2
DROP TRIGGER create_dish_id_t;
--Задание № 3
ALTER TABLE canteendishes MODIFY (dishid DEFAULT canteendishes_s.NEXTVAL);