<?php

use Phinx\Migration\AbstractMigration;

class GenerateTableLexems10 extends AbstractMigration
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

insert into sg_generate_lihotop(id,gen_text)
select generate_series(800000,900000 -1,1), concat_ws(' ',
                 random_int_btw(126,15),  --ПРЕДЛОГВОСКЛ_ГЛАГОЛ
                 random_int_btw(2399,10), --ПРИЛАГАТЕЛЬНОЕ
                 random_int_btw(73,16),   --БЕЗЛИЧ_ГЛАГОЛ
                 random_int_btw(126,15),  --ПРЕДЛОГ
                 random_int_btw(8385,7));  --СУЩЕСТВИТЕЛЬНОЕ
                                  
insert into sg_generate_lihotop(id,gen_text)
select generate_series(900000,1000000,1), concat_ws(' ',
                 random_int_btw(126,15),  --ПРЕДЛОГВОСКЛ_ГЛАГОЛ
                 random_int_btw(2399,10), --ПРИЛАГАТЕЛЬНОЕ
                 random_int_btw(73,16),   --БЕЗЛИЧ_ГЛАГОЛ
                 random_int_btw(126,15),  --ПРЕДЛОГ
                 random_int_btw(8385,7));  --СУЩЕСТВИТЕЛЬНОЕ
                 
                 
EOD;
        $this->execute($query);
    }
}
