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