<?php

use Phinx\Migration\AbstractMigration;

class DimensionByClassWord extends AbstractMigration
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
drop table if exists bible_parall_by_class_book ;
create table bible_parall_by_class_book as
with cte as
(
    SELECT
      e.id,
      f.name as form_name,
      c.name as class_name,
      e.name
    FROM sg_class C, sg_entry E, sg_form F
    WHERE E.id_class = C.id AND F.id_entry = E.id
    and c.id != 22
),prepare_data as
(
    SELECT
      lower(replace(c.form_name, ' ', '')) AS name,
      first(class_name)                    AS class_name
    FROM cte AS c
    GROUP BY c.form_name
), parall_data as
(
    SELECT
      row_number() over (ORDER BY null)  as id,
      bp.name as name,
      bo.id as book_id,
      class_name,
      count(*) as total_word
    FROM prepare_data s
    join bible_parall as bp on s.name  =bp.name
    JOIN bible AS b ON b.page_ts_vector @@ bp.ts_query_name
    join book as bo on b.book_id = bo.id
    GROUP BY bo.id,bp.name,class_name
)
select *
from parall_data;

create index bible_parall_by_class_book_book_id_class_nane on bible_parall_by_class_book(book_id,class_name);

create or replace function get_word_bible_normalize_info(a_book_id integer,out found_word numeric,out total_word numeric) returns SETOF RECORD
IMMUTABLE
LANGUAGE PlpgSQL
AS $$
BEGIN
      if(a_book_id = 10000)
      then

        RETURN query
          select (select sum(b.total_word) from bible_dim_book_type as b),
                 (select sum(length(page_ts_vector)) from bible)::numeric;

      elseif (a_book_id = 10001)
      then
            RETURN QUERY
            select   (select sum(b.total_word) from bible_dim_book_type as b
                    where book_id in (select id from book where is_new is false)),
                    (select sum(length(page_ts_vector)) from  bible
                                                    where book_id in (select id from book where is_new is false))::numeric;

      elseif (a_book_id = 10002)
      then
            RETURN QUERY
            select   (select sum(b.total_word)
                      from bible_dim_book_type as b
                    where book_id in (select id from book where is_new is true)),
                    (select sum(length(page_ts_vector)) from  bible
                                                    where book_id in (select id from book where is_new is true))::numeric;

      else
      RETURN QUERY
        select (select sum(b.total_word) from bible_dim_book_type as b
                                                    where book_id = a_book_id),
                            (select sum(length(page_ts_vector))
                                                      from  bible
                                                      where book_id = a_book_id)::numeric;
      END IF;
  END;
$$;


create or replace function get_bible_pie_chart_info(a_book_id integer,a_limit integer) returns jsonb
IMMUTABLE
LANGUAGE PlpgSQL
AS $$
DECLARE
val_result jsonb;
val_title text = (select name from book where id = a_book_id);
BEGIN
      if(a_book_id = 10000)
      then
        select json_build_object('pie_part_of_speech',json_build_object('title','Доля частей речи','subtitle','Библия','data',(select jsonb_agg(r)
                                                                                 from  (select "group" as name,sum(total_word) as y
                                                                                 from bible_parall
                                                                                  GROUP BY "group") as r)),
               'pie_word_by_part_of_speech',(select json_agg(json_build_object('title',r."group",'subtitle','Библия','data',rs))
        from
        (select r."group",(select json_agg(r) from (select name,total_word as y from bible_parall where r."group" = "group" order by total_word desc limit a_limit) as r) as rs
        from
      (select "group" from bible_parall GROUP BY "group") as r) as r))
          into val_result;

      elseif (a_book_id = 10001)
      then
        select json_build_object('pie_part_of_speech',json_build_object('title','Доля частей речи','subtitle','Cтарый завет','data',(select jsonb_agg(r)
                                                                                 from  (select bl.class_name as name,sum(total_word) as y
                                                                                 from bible_parall_by_class_book as bl
                                                                                   where bl.book_id in (select id
                                                                                                        from book  where is_new is false)
                                                                                  GROUP BY bl.class_name) as r)),
               'pie_word_by_part_of_speech',(select json_agg(json_build_object('title',rs."group",'subtitle','Cтарый завет','data',rs))
        from
        (select r."group",(select json_agg(r) from (
                select name,max(bl.total_word)
                from bible_parall_by_class_book  as bl
                where bl.class_name = r."group" and  bl.book_id in (select id from book  where is_new is false)
                GROUP BY name,class_name
                order by max(total_word) desc limit a_limit) as r)
        from
      (select "group"
       from bible_parall
       GROUP BY "group") as r) as rs))
          into val_result;


      elseif (a_book_id = 10002)
      then
            select json_build_object('pie_part_of_speech',json_build_object('title','Доля частей речи','subtitle','Новый завет','data',(select jsonb_agg(r)
                                                                                 from  (select bl.class_name as name,sum(total_word) as y
                                                                                 from bible_parall_by_class_book as bl
                                                                                   where bl.book_id in (select id
                                                                                                        from book  where is_new is true)
                                                                                  GROUP BY bl.class_name) as r)),
               'pie_word_by_part_of_speech',(select json_agg(json_build_object('title',rs."group",'subtitle','Новый завет','data',rs))
        from
        (select r."group",(select json_agg(r) from (
                select name,max(bl.total_word)
                from bible_parall_by_class_book  as bl
                where bl.class_name = r."group" and  bl.book_id in (select id from book  where is_new is true)
                GROUP BY name,class_name
                order by max(total_word) desc limit a_limit) as r)
        from
      (select "group"
       from bible_parall
       GROUP BY "group") as r) as rs))
              into val_result;
      else
 select json_build_object('pie_part_of_speech',json_build_object('title','Доля частей речий','subtitle','Новый завет','data',(select jsonb_agg(r)
                                                                                 from  (select bl.class_name as name,sum(total_word) as y
                                                                                 from bible_parall_by_class_book as bl
                                                                                   where bl.book_id in (a_book_id)
                                                                                  GROUP BY bl.class_name) as r)),
               'pie_word_by_part_of_speech',(select json_agg(json_build_object('title',rs."group",'subtitle',val_title,'data',rs))
        from
        (select r."group",(select json_agg(r) from (
                select name,max(bl.total_word) as y
                from bible_parall_by_class_book  as bl
                where bl.class_name = r."group" and  bl.book_id in (a_book_id)
                GROUP BY name,class_name
                order by max(total_word) desc limit a_limit) as r)
        from
      (select "group"
       from bible_parall
       GROUP BY "group") as r) as rs))
              into val_result;

      END IF;

RETURN val_result;
  END;
$$;

create table bible_tree as
select 10000 as id,'#' as parent,'Библия' as text,(get_word_bible_normalize_info(10000)).*,get_bible_pie_chart_info(10000,20) as charts
union all
select 10001,'10000' as parent,'Старый завет' as text,(get_word_bible_normalize_info(10001)).*,get_bible_pie_chart_info(10001,20)
UNION ALL
select 10002,'10000' as parent,'Новый завет' as text,(get_word_bible_normalize_info(10002)).*,get_bible_pie_chart_info(10002,30)
UNION ALL
select b.id,'10001',b.name,(get_word_bible_normalize_info(b.id)).*,get_bible_pie_chart_info(10002,20)
from book as b
where is_new is false
UNION ALL
select b.id,'10002',b.name,(get_word_bible_normalize_info(b.id)).*,get_bible_pie_chart_info(id,10)
from book as b;

EOD;
        $this->execute($query);
    }
};
