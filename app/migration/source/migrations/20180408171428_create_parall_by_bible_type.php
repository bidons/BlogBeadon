<?php

use Phinx\Migration\AbstractMigration;

class CreateParallByBibleType extends AbstractMigration
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
create index bible_book_id_idx on bible(book_id);
create table bible_parall_by_type as  
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
      first(c.id)                          AS id,
      lower(replace(c.form_name, ' ', '')) AS name,
      first(class_name)                    AS class_name
    FROM cte AS c
    GROUP BY c.form_name
), parall_data as
(
    SELECT
      first(s.id) as id,
      bp.name as name,
      case when bo.is_new then 'Новый завет' else 'Старый завет' end as group,
      count(*) as total_word,
      count(*) filter (where s.class_name = 'ЧАСТИЦА') as "ЧАСТИЦА",
      count(*) filter (where s.class_name = 'МЕСТОИМ_СУЩ') as "МЕСТОИМ_СУЩ",
      count(*) filter (where s.class_name = 'БЕЗЛИЧ_ГЛАГОЛ') as "БЕЗЛИЧ_ГЛАГОЛ",
      count(*) filter (where s.class_name = 'СУЩЕСТВИТЕЛЬНОЕ') as "СУЩЕСТВИТЕЛЬНОЕ",
      count(*) filter (where s.class_name = 'СОЮЗ')            as "СОЮЗ",
      count(*) filter (where s.class_name = 'ЧИСЛИТЕЛЬНОЕ')    as "ЧИСЛИТЕЛЬНОЕ",
      count(*) filter (where s.class_name = 'ПРИЛАГАТЕЛЬНОЕ')  as "ПРИЛАГАТЕЛЬНОЕ",
      count(*) filter (where s.class_name = 'МЕСТОИМЕНИЕ')     as "МЕСТОИМЕНИЕ",
      count(*) filter (where s.class_name = 'ВВОДНОЕ')         as "ВВОДНОЕ",
      count(*) filter (where s.class_name = 'ИНФИНИТИВ')       as "ИНФИНИТИВ",
      count(*) filter (where s.class_name = 'ПРЕДЛОГ')         as "ПРЕДЛОГ",
      count(*) filter (where s.class_name = 'ПОСЛЕЛОГ')        as "ПОСЛЕЛОГ",
      count(*) filter (where s.class_name = 'ГЛАГОЛ')          as "ГЛАГОЛ",
      count(*) filter (where s.class_name = 'НАРЕЧИЕ')         as "НАРЕЧИЕ",
      count(*) filter (where s.class_name = 'ДЕЕПРИЧАСТИЕ')    as "ДЕЕПРИЧАСТИЕ"
    FROM prepare_data s
    join bible_parall as bp on s.name  =bp.name
    JOIN bible AS b ON b.page_ts_vector @@ bp.ts_query_name
    join book as bo on b.book_id = bo.id
    GROUP BY bo.is_new,bp.name
)
select *
from parall_data;
EOD;
        $this->execute($query);
    }
}
