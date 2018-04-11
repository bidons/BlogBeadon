<?php

use Phinx\Migration\AbstractMigration;

class AddIndexes extends AbstractMigration
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

create extension pg_trgm;
/*create index sg_generate_lihotop_id_idx on sg_generate_lihotop(id);
create index sg_generate_lihotop_gen_date_trg_idx ON sg_generate_lihotop USING gist (gen_text gist_trgm_ops);
create index sg_generate_grek_gen_date_vector ON sg_generate_grek USING gist (to_tsvector('russian',gen_text));
create index sg_generate_grek_idx on sg_generate_grek(id);*/



update paging_column
set condition ='["select2dynamic"]'
where id in
      (select id
from paging_column
where paging_table_id in
      (select id from paging_table
where name = 'vw_sg_generate_lihotop'));

update paging_column
set condition ='["select2dynamic"]'
where id in
      (select id
from paging_column
where paging_table_id in
      (select id from paging_table
where name = 'vw_sg_generate_grek'));


EOD;
        $this->execute($query);
    }
}
