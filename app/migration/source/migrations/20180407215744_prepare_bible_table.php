<?php

use Phinx\Migration\AbstractMigration;

class PrepareBibleTable extends AbstractMigration
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

CREATE OR REPLACE FUNCTION public.normalize_bible_data()
  RETURNS integer
AS
$BODY$
DECLARE
    row record;
    val_book text;
    val_chapter text;
BEGIN
    for row in (select * from bible order by id)
      LOOP
      if(row.book is not null and val_book is null or (row.book != val_book and row.book is not null and val_book is not null))
        then
            val_book = row.book;
        END IF;
      
      if(row.chapter is not null and val_chapter is null or (row.chapter != val_chapter and row.chapter is not null and val_chapter is not null))
        then
            val_chapter = row.chapter;
        END IF;

      update bible
      set book= val_book,chapter = val_chapter,row = Coalesce(str2integer(split_part(page, ' ', 1)),str2integer(split_part(page, ' ', 1)))
      where id = row.id;

      END LOOP;

  return 1;
END;
$BODY$
LANGUAGE plpgsql volatile;

select normalize_bible_data();

update bible
set page = replace(page,row,'');

update bible
set page_ts_vector = to_tsvector(page);

create table bible_parall as
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
      lower(replace(c.form_name,' ','')) as name,
      first(class_name) as class_name
    FROM cte AS c
    GROUP BY c.form_name
) , prepare_parall as
(
    SELECT
       row_number() over (ORDER BY null) as id,
      s.name,
      s.name::tsquery as ts_query_name,
      first(s.class_name) as "group",
      count(*) as total_word,
      NULL :: INTEGER      "0_5000_old",
      NULL :: INTEGER      "5000_10000_old",
      NULL :: INTEGER      "10000_15000_old",
      NULL :: INTEGER      "15000_20000_old",
      NULL :: INTEGER      "20000_25000_old",
      NULL :: INTEGER      "25000_30000_old",
      NULL :: INTEGER      "30000_35000_new",
      NULL :: INTEGER      "35000_38546_new"
    FROM prepare_data s
    JOIN bible AS b ON b.page_ts_vector @@ s.name :: TSQUERY
      where b.page !=''
    GROUP BY s.name
)
select *
  from prepare_parall;


EOD;
        $this->execute($query);
    }
}
