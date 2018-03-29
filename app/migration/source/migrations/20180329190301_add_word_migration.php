<?php

use Phinx\Migration\AbstractMigration;

class AddWordMigration extends AbstractMigration
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
create INDEX sg_entry_name on sg_entry(lower(name));
create INDEX sg_class_name on sg_class(lower(name));

create view vw_word_with_prop as
select sg.name as word,freq,sgc.name as class_name,sgl.name as language
from sg_entry sg
left join sg_class as sgc on sgc.id = sg.id_class
left join sg_language as sgl on sgl.id = sgc.id_lang;

select rebuild_paging_prop('vw_word_with_prop','Части речи и типы','part_of_speech',FALSE);


update paging_column
set condition = json_build_array('select2dynamic')
where paging_column.paging_table_id in (select id from paging_table where name = 'vw_word_with_prop');


select get_paging_table_total_count();
EOD;
        $this->execute($query);
    }
}
