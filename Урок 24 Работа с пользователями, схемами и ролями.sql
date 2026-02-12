--https://rutube.ru/video/private/c2dccf26b65cbdb7c51c035393c48ffa/?p=Vv4gc3gNNLVt4haYjoD8eQ
--SQL. Базы данных. ORACLE. Урок 24 Работа с пользователями, схемами и ролями
--Для моей 21C версии OEBS новый подход с изменением паролей, ролей и т.п.

/*
Поскольку у меня БД контейнизированная через докер, то придется переключаться между 

CREATE USER dima_2 IDENTIFIED BY 1234;

SELECT banner FROM v$version WHERE ROWNUM = 1;

SHOW CON_NAME;

ALTER SESSION SET CONTAINER = XEPDB1;

Отлично! Рад, что получилось! ✅

## 🔄 Как вернуться в CDB$ROOT:

### Способ 1: Самый простой
```sql
ALTER SESSION SET CONTAINER = CDB$ROOT;
SHOW CON_NAME;  -- Проверим, должно быть CDB$ROOT
```

### Способ 2: Переподключиться
```sql
-- Выйти из текущей сессии и зайти снова как SYS
CONNECT / AS SYSDBA;
-- или
CONNECT sys AS SYSDBA;
```

## 📊 Быстрая шпаргалка по переключениям:

```sql
-- Из CDB в PDB:
ALTER SESSION SET CONTAINER = XEPDB1;

-- Из PDB в CDB:
ALTER SESSION SET CONTAINER = CDB$ROOT;

-- Из любой PDB в другую PDB:
ALTER SESSION SET CONTAINER = PDB_NAME;
```

## 🔍 Проверка, где мы сейчас:
```sql
-- Показать текущий контейнер
SHOW CON_NAME;

-- Показать все доступные контейнеры
SELECT name, open_mode FROM v$pdbs;
```

## 🎯 Практический пример полного цикла:
```sql
-- 1. Начинаем в CDB
SHOW CON_NAME;  -- CDB$ROOT

-- 2. Переходим в PDB
ALTER SESSION SET CONTAINER = XEPDB1;
SHOW CON_NAME;  -- XEPDB1

-- 3. Работаем в PDB (создаем пользователя)
CREATE USER dima_app IDENTIFIED BY "MyPass123";
GRANT CONNECT, RESOURCE TO dima_app;

-- 4. Возвращаемся в CDB
ALTER SESSION SET CONTAINER = CDB$ROOT;
SHOW CON_NAME;  -- CDB$ROOT

-- 5. Можем создать common user в CDB
CREATE USER c##admin_global IDENTIFIED BY "AdminPass456";
GRANT CONNECT TO c##admin_global;
```

## ⚠️ Важно знать:

1. **Пользователи созданные в PDB (XEPDB1)** видны ТОЛЬКО в этой PDB
2. **Пользователи созданные в CDB с C##** видны ВО ВСЕХ PDB
3. **Переключение между контейнерами** требует прав SYSDBA

## 📝 Пример для запоминания:

```sql
-- В CDB можно:
CREATE USER c##имя ...  -- Общие пользователи
CREATE USER имя ...      -- НЕЛЬЗЯ! Ошибка ORA-65096

-- В PDB можно:
CREATE USER имя ...      -- Локальные пользователи
CREATE USER c##имя ...   -- Тоже можно, но зачем?
```

## 💡 Полезные команды для навигации:

```sql
-- Увидеть всех пользователей в текущем контейнере
SELECT username, common FROM dba_users ORDER BY username;

-- Узнать детали о контейнерах
SELECT con_id, name, open_mode FROM v$containers;

-- Узнать имя и тип текущей базы
SELECT name, cdb FROM v$database;
```

## ❓ Когда нужно возвращаться в CDB:

1. **Для администрирования всей системы**
2. **Создания общих пользователей (с C##)**
3. **Управления всеми PDB сразу**
4. **Резервного копирования всего CDB**

**В 90% случаев вы будете работать в PDB**, возвращаться в CDB нужно редко.

Теперь попробуйте сами:
```sql
-- Перейдите в CDB
ALTER SESSION SET CONTAINER = CDB$ROOT;
SHOW CON_NAME;

-- Вернитесь в PDB
ALTER SESSION SET CONTAINER = XEPDB1;
SHOW CON_NAME;
```
*/

SELECT *
FROM user_sys_privs; -- все системные привилегии пользователя

SELECT *
FROM user_role_privs; -- все ролевые привилегии пользователя

SELECT *
FROM user_tab_privs;  -- все привилегии по объектам пользователя

 -- для dba меняется user на dba, например, dba_sys_privs, dba_role_privs, dba_tab_privs - и т.д.

SELECT *
FROM SESSION_PRIVS; -- привилегии действующей сессии.

/*
Чтобы выдать все привилегии DBA для пользователя DIMA в Oracle 21c, выполните следующие шаги из учётной записи SYS:

1. Подключение под SYS
sql
CONNECT SYS AS SYSDBA;
-- или
CONNECT / AS SYSDBA;
2. Выдать роль DBA (рекомендуемый способ)
sql
GRANT DBA TO DIMA;
-- Если нужно с возможностью делегирования:
GRANT DBA TO DIMA WITH ADMIN OPTION;
3. Сделать роль DBA ролей по умолчанию (опционально)
sql
ALTER USER DIMA DEFAULT ROLE DBA;
4. Проверить выдачу привилегий
sql
-- Проверить роли пользователя DIMA
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'DIMA';

-- Проверить все привилегии в сессии
CONNECT DIMA; -- подключиться под DIMA
SELECT * FROM SESSION_PRIVS; -- посмотреть все привилегии
SELECT * FROM SESSION_ROLES; -- посмотреть все активные роли
*/

--1. Сначала подключаемся как sysdba.
--2. Меняем контейнер
ALTER SESSION SET CONTAINER = XEPDB1;
--3. Меняем пароль
ALTER USER DIMA IDENTIFIED BY 1234;

--4. Смотрим где мы:
SHOW CON_NAME;
--Если так: 
------------------------------
--XEPDB1

--, то меняем обратно контейнер
--5. 
ALTER SESSION SET CONTAINER = CDB$ROOT;
--6. Смотрим где мы:
SHOW CON_NAME;
--Должно быть так:
--CON_NAME 
------------------------------
--CDB$ROOT

--------------------------------------------------------------------------------
--ГРАНТЫ

--GRANT <какие права дать> ON <на какой объект> to <какому пользователю>;
-- вместо пользователя можно дать права public - даются абсолютно всем пользователям, привер:
--GRANT SELECT ON persons TO PUBLIC;

--Убрать права через REVOKE 
--REVOKE SELECT ON persons FROM someusername;  -- у самого себя нельзя их отбирать, это тоже самое что съесть себя - не получится) 
 
 
 -------------------------------------------------------------------------------
--РОЛИ
CREATE ROLE tester; --создание Роли
-- снабжаем роль кучей прав
GRANT ALL ON user0.persons TO tester;
--или
GRANT SELECT ON user0.canteendishes TO tester;
-- Суть такая, что сначала создается роль, а потом к роли привязываются полномочия( то , что может делать внутри БД)
GRANT tester to new_some_user; -- дается роль кому-то новому.
REVOKE tester FROM some_user; -- убираются права

--Практические задачи к Уроку 24
--Домашка
--1. Написать команду создания пользователя TEST с паролем test.  
--2. Написать команду предоставления прав на чтение (SELECT) таблицы Persons пользователю TEST.  
--3. Написать команду снятия привилегий на чтение (SELECT) таблицы Persons с пользователя TEST.  
--4. Написать команду удаления пользователя TEST.
--------------------------------------------------------------------------------
--Не тестировал! Написал по памяти!!!!!!!!!!!!!!
--1. выполнение 1 задания, но делают под правами DBA:
CREATE USER test IDENTIFIED BY test;
--2.
GRANT SELECT ON persons TO test;
--3.
REVOKE SELECT ON persons FROM test;
--4.
DROP USER test;