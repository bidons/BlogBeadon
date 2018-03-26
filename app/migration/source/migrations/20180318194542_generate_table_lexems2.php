<?php

use Phinx\Migration\AbstractMigration;

class GenerateTableLexems2 extends AbstractMigration
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
set ENABLE_SEQSCAN =false;
insert into sg_generate_grek(id,gen_text)
select generate_series(400000 ,500000 -1,1), concat_ws(' ',
                 random_int_btw(1093,14),  -- ДЕЕПРИЧАСТИЕ
                 random_int_btw(126,15),   -- ПРЕДЛОГ
                 random_int_btw(3441,13),  -- ГЛАГОЛ
                 random_int_btw(44,11),    -- ЧИСЛИТЕЛЬНОЕ
                 random_int_btw(2399,10),  -- ПРИЛАГАТЕЛЬНОЕ
                 random_int_btw(8385,7));   --СУЩЕСТВИТЕЛЬНОЕ

insert into sg_generate_grek(id,gen_text)
select generate_series(500000,600000 -1,1), concat_ws(' ',
                 random_int_btw(1093,14),  -- ДЕЕПРИЧАСТИЕ
                 random_int_btw(126,15),   -- ПРЕДЛОГ
                 random_int_btw(3441,13),  -- ГЛАГОЛ
                 random_int_btw(44,11),    -- ЧИСЛИТЕЛЬНОЕ
                 random_int_btw(2399,10),  -- ПРИЛАГАТЕЛЬНОЕ
                 random_int_btw(8385,7));   --СУЩЕСТВИТЕЛЬНОЕ             
EOD;
        $this->execute($query);
    }
}
