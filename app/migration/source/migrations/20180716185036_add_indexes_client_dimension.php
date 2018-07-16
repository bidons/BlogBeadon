<?php

use Phinx\Migration\AbstractMigration;

class AddIndexesClientDimension extends AbstractMigration
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
create index client_dimension_event_1_partial_idx on client_dimension(event_1) where event_1 > 0;
create index client_dimension_event_2_partial_idx on client_dimension(event_2) where event_2 > 0;
create index client_dimension_event_3_partial_idx on client_dimension(event_3) where event_3 > 0;
  
EOD;
        $this->execute($query);
    }
}
