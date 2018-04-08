<?php

use Phinx\Migration\AbstractMigration;

class CreateBibleParall extends AbstractMigration
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

update bible_parall
set "0_5000_old" = (
                select count(*)
                from (select b.page_ts_vector
                from bible as b
                order by id limit 5000 OFFSET 0) as r
                where r.page_ts_vector @@ ts_query_name);




EOD;
        $this->execute($query);
    }
}
