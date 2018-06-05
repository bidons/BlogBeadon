<?php

use Phinx\Migration\AbstractMigration;

class BibleParallFixPie extends AbstractMigration
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
update bible_tree
set text = 
case
    when text = 'Книга пророка Исаии' then 'Книга Исаии'
    when text = 'Книга пророка Малахии' then 'Книга Малахии'
    when text = 'Книга пророка Ионы' then 'Книга Ионы'
    when text = 'Книга пророка Аввакума' then 'Книга Аввакума'
    when text = 'Книга пророка Софонии' then 'Книга Софонии'
    when text = 'Книга пророка Аггея' then 'Книга Аггея'
    when text = 'Книга пророка Иеремии' then 'Книга Иеремии'
    when text = 'Книга пророка Осии' then 'Книга Осии'
    when text = 'Книга пророка Михея' then 'Книга Михея'
    when text = 'Книга пророка Захарии' then 'Книга Захарии'
    when text = 'Книга пророка Наума' then 'Книга Наума'
    when text = 'Книга премудрости Соломона *' then 'Книга Соломона *'
    when text = 'Книга пророка Варуха *' then 'Книга Варуха *'
    when text = 'Книга пророка Иоиля' then 'Книга Иоиля'
    when text = 'Книга пророка Иезекииля' then 'Книга Иезекииля'
    when text = 'Книга пророка Даниила' then 'Книга Даниила'
    when text = 'Книга Екклезиаста, или Проповедника' then 'Книга Екклезиаста'
    when text = 'Книга пророка Амоса' then 'Книга Амоса'
    when text = 'Откровение святого Иоанна Богослова (Апокалипсис)' then 'Откровение Иоанна Богослова' else text end;


EOD;
        $this->execute($query);
    }
}
