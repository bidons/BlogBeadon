<?php

use Phinx\Migration\AbstractMigration;

class CreateViewsTrgLezems extends AbstractMigration
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

drop view if EXISTS vw_sg_generate_lihotop;
drop view if EXISTS vw_sg_generate_grek;

update paging_table_type
set name = 'full_text_search',descr ='Лексемы-Триграммы'
where name = 'view';
/*
create view vw_sg_generate_lihotop as
select *
from sg_generate_lihotop as sg;

create view vw_sg_generate_grek as
select *
from sg_generate_grek as sg;

select rebuild_paging_prop('vw_sg_generate_grek','Лексемный поиск','full_text_search',false);
select rebuild_paging_prop('vw_sg_generate_lihotop','Триграмный поиск','full_text_search',false);*/

update paging_table
set paging_table_type_id = 4
where id in (100012,100013,100014,100015);

CREATE OR REPLACE FUNCTION public.get_paging_table_total_count()
  RETURNS VOID
AS
$BODY$
DECLARE
  row record ;
  val_count integer;
BEGIN
    for row in (select * from paging_table)
    LOOP
          EXECUTE  concat_ws(' ','select count(*)','from', row.name)
          into val_count;

      update paging_table
        set m_count = val_count
      where id = row.id;
    END LOOP;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

select get_paging_table_total_count();
EOD;
        $this->execute($query);
    }
}
