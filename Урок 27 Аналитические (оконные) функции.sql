--https://rutube.ru/video/private/b2110ebc10f74c74d05b0ae5687afb06/?p=9oRhUA8z6VTRchyn6_Wf5g
--SQL. Урок 27 Аналитические (оконные) функции

--предыдущее решение ДЗ к Уроку 26
CREATE OR REPLACE FUNCTION GET_PRICE(pID_TOV IN NUMBER)
RETURN NUMBER IS
Res NUMBER;
BEGIN
  SELECT price
    INTO RES
    FROM price_list l
   WHERE l.ID_TOVAR = pID_TOV
     AND l.DATE_PRICE = (SELECT MAX(DATE_PRICE)
                           FROM price_list
                          WHERE ID_TOVAR=l.ID_TOVAR
                            AND DATE_PRICE <= SYSDATE);
  RETURN RES;
END GET_PRICE;
/
--------------------------------------------------------------------------------

select t.*
      , get_price(t.id_tovar)
from tovar t;
--------------------------------------------------------------------------------
select p.*
      , ROW_NUMBER() OVER(PARTITION BY p.id_tovar ORDER BY p.id_Tovar) rn -- нумерует id_tovar, каждый id_tovar нумеруется отдельно, полезная функция, проверка на дубликаты
from price_list p;
--------------------------------------------------------------------------------
--OVER - функция , которая делает из агрегатной функции аналитическую(оконную)
--может иметь в себе параметры, а может не иметь, где-то она обязательно долна иметь параметры:
--partition by - параметр, по которому ведется действие функции стоящей перед OVER , то есть по какому принципу ведется порядок обработки
--order by - параметр, по которому ведется сортировка внутри оконной функции.
--------------------------------------------------------------------------------
--вывести самого пожилого сотрудника:
--Способ №1
select * from(
              select rownum, name, birthdate
                from persons
            order by birthdate)
WHERE rownum = 1; -- данные список плох, потому что кол-во людей может быть большим, не в кол-ве 1 шт.
--------------------------------------------------------------------------------
--Способ №2
select name, birthdate
  from persons
  where birthdate = (select min(birthdate)
                      from persons); -- этот способ гибче
--------------------------------------------------------------------------------
--Способ №3
select *
from (select name, birthdate, dense_rank() over(order by birthdate) note
      from persons)
where note=1; --третий вариант поиска самого возрастного персонала
--------------------------------------------------------------------------------
select *
from (
      select name
            , birthdate
            , filialid
            , dense_rank() over(partition by filialid order by birthdate) note
        from persons)
where note=1;    
--------------------------------------------------------------------------------
select *
from (
      select name
            , birthdate
            , filialid
            , dense_rank() over(order by birthdate) note
        from persons)
where note in (1,2,3); -- вывод первых трех самый возрастных людей
--------------------------------------------------------------------------------
select *
from (
      select c.dishname
            , c.dishtype
            , c.price
            , round(avg(c.price) over(partition by c.dishtype) ,2) avg_price
            , count(c.price) over(partition by c.dishtype) cnt
      from canteendishes c
      )
where price >= avg_price;
--------------------------------------------------------------------------------
select c.*
      , dense_rank() over(partition by c.price order by c.price) --непонятно, почему для одинаковых ценников не определяется группировка через 1,2,3 и т.д., а только через 1,1,1.
from canteendishes c;
--------------------------------------------------------------------------------
select p.name
      , p.departamentid
      , p.birthdate
      , first_value(p.name) over(partition by p.departamentid order by p.birthdate) colleage
from persons p; -- вывод самого возрастного коллеги, после анализируемого
--------------------------------------------------------------------------------
-- Практические задачи к Уроку 27
--1. Вывести три самых дорогих блюда (для решения использовать аналитические функции).
--2. Вывести список блюд столовой, в еще одном дополнительном столбце вывести название самого 
--дорогого блюда в категории выводимого блюда (для решения использовать аналитические функции).
--------------------------------------------------------------------------------
--РЕШЕНИЕ:
--------------------------------------------------------------------------------
--Задание № 1
SELECT DISHNAME
      , price
FROM(
    SELECT 
          cd.dishname
          , cd.price
          , DENSE_RANK() OVER(ORDER BY cd.price desc) price_cat
    FROM canteendishes cd
    )
WHERE price_cat <= 3;
--РЕШЕНИЕ:
--------------------------------------------------------------------------------
--Задание № 2
SELECT 
      cd.dishname
      , cd.price
      , cd.dishtype
      , MAX(cd.price) OVER(PARTITION BY cd.dishtype) max_price_cat
FROM canteendishes cd