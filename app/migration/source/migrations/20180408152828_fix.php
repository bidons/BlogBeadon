<?php

use Phinx\Migration\AbstractMigration;

class Fix extends AbstractMigration
{
    /**
     * Change Method.
     *
     * Write your reversible migrations using this method.
     *
     * More information on writing migrations is available here:
     * http://docs.phinx.org/en/latest/migrations.html#the-abstractmigration-class
     *
     * The following commands can be used in this method and Phinx will
     * automatically reverse them when rolling back:
     *
     *    createTable
     *    renameTable
     *    addColumn
     *    renameColumn
     *    addIndex
     *    addForeignKey
     *
     * Remember to call "create()" or "update()" and NOT "save()" when working
     * with the Table class.
     */
    public function change()
    {
$query =<<<'EOD'

delete from bible
where row is null;

update bible
    set book ='Псалтирь'
where book = 'Знаком * отмечены книги неканонические.';

update bible
    set book ='Вторая книга Ездры *'
where book = 'Вторая книга Ездры[1 - Знаком * отмечены книги неканонические.]';

create table book
  (
      id serial primary key,
      name text not null UNIQUE,
      is_new boolean default false
  );

CREATE OR REPLACE FUNCTION public.book_id(a text)
  RETURNS int4
AS
$BODY$
      select id
      from book
      where name = $1;
$BODY$
LANGUAGE sql IMMUTABLE;


CREATE OR REPLACE FUNCTION public.book_name(a integer)
  RETURNS text
AS
$BODY$
      select name
      from book
      where id = $1;

$BODY$
LANGUAGE sql IMMUTABLE;

alter table bible add COLUMN  book_id integer REFERENCES book(id);



insert into book(name)
select "book"
from bible
group by "book";

update bible
set book_id = book_id(book);

alter table bible ALTER COLUMN book_id set not null;

alter table bible drop column book;

update book
set name =
case when 
      name = 'От Матфея святое благовествование' then 'Евангелие от Матфея'
  when name = 'От Марка святое благовествование' then 'Евангелие от Марка'
  when name = 'От Луки святое благовествование' then  'Евангелие от Луки'
  when name = 'От Иоанна святое благовествование' then 'Евангелие от Иоанна'
  when name = 'Деяния святых апостолов' then 'Деяния святых апостолов'
  when name = 'Соборное послание святого апостола Иакова' then 'Послание Иакова'
  when name = 'Первое соборное послание святого апостола Петра' then '1-е послание Петра'
  when name = 'Второе соборное послание святого апостола Петра' then '2-е послание Петра'
  when name = 'Первое соборное послание святого апостола Иоанна Богослова' then '1-е послание Иоанна'
  when name = 'Второе соборное послание святого апостола Иоанна Богослова' then '2-е послание Иоанна'
  when name = 'Третье соборное послание святого апостола Иоанна Богослова' then  '3-е послание Иоанна'
  when name = 'Соборное послание святого апостола Иуды' then 'Послание Иуды'
  when name = 'Послание к Римлянам святого апостола Павла' then 'Послание к Римлянам'
  when name = 'Первое послание к Коринфянам святого апостола Павла' then '1-е послание к Коринфянам'
  when name = 'Второе послание к Коринфянам святого апостола Павла' then '2-е послание к Коринфянам'
  when name = 'Послание к Галатам святого апостола Павла' then 'Послание к Галатам'
  when name = 'Послание к Ефесянам святого апостола Павла' then 'Послание к Ефесянам'
  when name = 'Послание к Филиппийцам святого апостола Павла' then 'Послание к Филиппийцам'
  when name = 'Послание к Колоссянам святого апостола Павла' then 'Послание к Колоссянам'
  when name = 'Первое послание к Фессалоникийцам святого Апостола Павла' then '1-е послание к Фессалоникийцам'
  when name = 'Второе послание к Фессалоникийцам святого апостола Павла' then '2-е послание к Фессалоникийцам'
  when name = 'Первое послание к Тимофею святого апостола Павла' then '1-е послание к Тимофею'
  when name = 'Второе послание к Тимофею святого апостола Павла' then '2-е послание к Тимофею'
  when name = 'Послание к Титу святого апостола Павла' then 'Послание к Титу'
  when name = 'Послание к Филимону святого апостола Павла' then 'Послание к Филимону'
  when name = 'Послание к Евреям святого апостола Павла' then 'Послание к Евреям'
  when name = 'Послание к Евреям святого апостола Павла' then 'Откровение Иоанна Богослова' else name end,
  is_new = case when name = 'От Матфея святое благовествование' then true
  when name = 'От Марка святое благовествование' then true
  when name = 'От Луки святое благовествование' then  true
  when name = 'От Иоанна святое благовествование' then true
  when name = 'Деяния святых апостолов' then true
  when name = 'Соборное послание святого апостола Иакова' then true
  when name = 'Первое соборное послание святого апостола Петра' then true
  when name = 'Второе соборное послание святого апостола Петра' then true
  when name = 'Первое соборное послание святого апостола Иоанна Богослова' then true
  when name = 'Второе соборное послание святого апостола Иоанна Богослова' then true
  when name = 'Третье соборное послание святого апостола Иоанна Богослова' then true
  when name = 'Соборное послание святого апостола Иуды' then true
  when name = 'Послание к Римлянам святого апостола Павла' then true
  when name = 'Первое послание к Коринфянам святого апостола Павла' then true
  when name = 'Второе послание к Коринфянам святого апостола Павла' then true
  when name = 'Послание к Галатам святого апостола Павла' then true
  when name = 'Послание к Ефесянам святого апостола Павла' then true
  when name = 'Послание к Филиппийцам святого апостола Павла' then true
  when name = 'Послание к Колоссянам святого апостола Павла' then true
  when name = 'Первое послание к Фессалоникийцам святого Апостола Павла' then true
  when name = 'Второе послание к Фессалоникийцам святого апостола Павла' then true
  when name = 'Первое послание к Тимофею святого апостола Павла' then true
  when name = 'Второе послание к Тимофею святого апостола Павла' then true
  when name = 'Послание к Титу святого апостола Павла' then true
  when name = 'Послание к Филимону святого апостола Павла' then true
  when name = 'Послание к Евреям святого апостола Павла' then true
  when name = 'Послание к Евреям святого апостола Павла' then true else false end;



EOD;
        $this->execute($query);
    }
}
