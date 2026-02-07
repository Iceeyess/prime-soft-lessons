--https://rutube.ru/video/private/c2dccf26b65cbdb7c51c035393c48ffa/?p=Vv4gc3gNNLVt4haYjoD8eQ
--SQL. Базы данных. ORACLE. Урок 24 Работа с пользователями, схемами и ролями
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

