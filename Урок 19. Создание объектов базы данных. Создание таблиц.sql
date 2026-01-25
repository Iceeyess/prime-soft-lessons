--Урок 19. Создание объектов базы данных. Создание таблиц
--https://rutube.ru/video/private/caef19b5b3d6b58e0ec5d447dd787495/?p=Zl1pBaaq_86gyiswk8yMxg
--не допускаются арифметические символы в названии объектов, а так же цифры в начале этого объекта, например, 2025GOODS - нельзя или GOODS+1 тоже.
--однако GOOD_2026 можно, т.к. использованы не арифметические цифры.
CREATE TABLE TOVAR (
ID_TOVAR    NUMBER(4)             PRIMARY KEY    ,
NAME_TOVAR  VARCHAR2(100 CHAR) NOT NULL       ,
NOTE        VARCHAR2(100 CHAR) NULL           ,
DATE_CREATE DATE               DEFAULT SYSDATE
);
--DDL command - data definition language.
DROP TABLE TOVAR; -- удалить таблицу
DROP TABLE PRICE_LIST;


  CREATE TABLE PRICE_LIST
   (ID_TOVAR NUMBER(4) NOT NULL, 
	DATE_PRICE DATE NOT NULL, 
	PRICE NUMBER(9,2), 
	 CONSTRAINT PK_PL PRIMARY KEY (ID_TOVAR, DATE_PRICE), 
	 CONSTRAINT FK_TOVAR FOREIGN KEY (ID_TOVAR)
	  REFERENCES TOVAR (ID_TOVAR) ON DELETE CASCADE 
   );
   --SQL запрос создания таблицы про движение товара (PRO) от слова "ПРОВОДКИ".
CREATE TABLE PRO(
ID NUMBER NULL PRIMARY KEY,
DATE_OPERATION DATE DEFAULT SYSDATE,
ID_TOVAR NUMBER(4, 0),
IS_PRIHOD NUMBER(1),
QTY INTEGER,
CONSTRAINT FK_TOVAR_2 FOREIGN KEY (ID_TOVAR) REFERENCES TOVAR(ID_TOVAR)
);
COMMENT ON COLUMN DIMA.PRO.DATE_OPERATION IS 'Дата операции прихода или расхода';
COMMENT ON COLUMN DIMA.PRO.IS_PRIHOD IS '0=расход, 1=приход';
COMMENT ON COLUMN DIMA.PRO.QTY IS 'Количество товара';
COMMENT ON COLUMN DIMA.PRO.ID_TOVAR IS 'Товар'; 
DROP TABLE PRO;
--------------------------------------------------------------------------------
--Домашнее задание Урок 19.
--1. Реализовать таблицу «Группы товаров» со столбцами ID_GROUP и NAME_GROUP.
--2. Доработать таблицу «Товаров». Добавить в нее столбец ID_GROUP со ссылкой на таблицу «Групп товаров». То есть сделать возможность назначать товарам группы.
--------------------------------------------------------------------------------
--Реализация задания №1
--------------------------------------------------------------------------------
CREATE TABLE GROUP_TOVAR(
ID_GROUP INTEGER PRIMARY KEY,
NAME_GROUP VARCHAR2(150 CHAR) NOT NULL
);
COMMENT ON COLUMN GROUP_TOVAR.ID_GROUP IS 'ID GROUP';
COMMENT ON COLUMN GROUP_TOVAR.NAME_GROUP IS 'НАИМЕНОВАНИЕ';
--------------------------------------------------------------------------------
--Реализация задания №2
--------------------------------------------------------------------------------
ALTER TABLE TOVAR
ADD (ID_GROUP INTEGER);
-----------------------запускать раздельно
ALTER TABLE TOVAR 
ADD CONSTRAINT FK_ID_GROUP FOREIGN KEY (ID_GROUP)REFERENCES GROUP_TOVAR(ID_GROUP);