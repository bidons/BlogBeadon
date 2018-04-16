<?php

use Phinx\Migration\AbstractMigration;

class AddData extends AbstractMigration
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
        {
            $query = <<<'EOD'
   update bible_tree
set  text = 'Книга Сираха'
where text = 'Книга премудрости Иисуса, сына Сирахова *';

update bible_tree
set  text = 'Книга Исаии'
where text = 'Книга пророка Исаии';


update bible_tree
set  text = 'Книга Екклезиаста'
where text = 'Книга Екклезиаста, или Проповедника';


update bible_tree
set  text = 'Книга Амоса'
where text = 'Книга пророка Амоса';

update bible_tree
set  text = 'Откровение святого Иоанна Богослова'
where text = 'Откровение святого Иоанна Богослова (Апокалипсис)';
 
EOD;
            $this->execute($query);
        }
    }
}
     