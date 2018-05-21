<?php

use Phinx\Migration\AbstractMigration;

class FixBibleTree extends AbstractMigration
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

drop table bible_tree;

CREATE TABLE bible_tree as
select 10000 as id,'#' as parent,'Библия' as text,(get_word_bible_normalize_info(10000)).*,get_bible_pie_chart_info(10000,20) as charts
union all
select 10001,'10000' as parent,'Старый завет' as text,(get_word_bible_normalize_info(10001)).*,get_bible_pie_chart_info(10001,20)
UNION ALL
select 10002,'10000' as parent,'Новый завет' as text,(get_word_bible_normalize_info(10002)).*,get_bible_pie_chart_info(10002,20)
UNION ALL
select b.id,'10001',b.name,(get_word_bible_normalize_info(b.id)).*,get_bible_pie_chart_info(id,20)
from book as b
where is_new is false
UNION ALL
select b.id,'10002',b.name,(get_word_bible_normalize_info(b.id)).*,get_bible_pie_chart_info(id,20)
from book as b
where is_new is true;

EOD;
        $this->execute($query);
    }
}
