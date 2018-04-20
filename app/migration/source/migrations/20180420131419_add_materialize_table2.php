<?php

use Phinx\Migration\AbstractMigration;

class AddMaterializeTable2 extends AbstractMigration
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
update paging_table
  set last_paging_table_materialize_info_id = null
where name ='paging_table';

delete from paging_table_materialize_info
  where paging_table_id in
        (select id from paging_table
where name ='paging_table');

delete from paging_table
where name ='paging_table';

create or replace function get_set_paging_table_object(a_name text, a_descr text, a_type text, a_is_mat boolean) returns integer
LANGUAGE plpgsql
AS $$
declare
  val_id integer = (select id from paging_table where name = $1);
  val_type_id integer = (select id from paging_table_type where name = $3);
BEGIN
      if (val_id is null)
        then
              insert into paging_table(name, descr,paging_table_type_id,is_materialize)
                select $1,$2,Coalesce(val_type_id,1),coalesce(a_is_mat,false)
              RETURNING id
              into val_id;
        END IF;
      RETURN val_id;
END;
$$;



EOD;
$this->execute($query);
}
}
