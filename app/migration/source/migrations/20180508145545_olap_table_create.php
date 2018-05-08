<?php

use Phinx\Migration\AbstractMigration;

class OlapTableCreate extends AbstractMigration
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
CREATE TABLE client_dimension   
(
  create_time                   TIMESTAMP,
  value                         TEXT,
  client_id                     INTEGER,
  value_id                      INTEGER,
  type_id                       INTEGER NOT NULL,
  location_natural_world_woe_id INTEGER,
  loan                          NUMERIC DEFAULT 0,
  closed_loan                   NUMERIC DEFAULT 0,
  open_loan                     NUMERIC DEFAULT 0
);

copy client_dimension from '/var/www/phalcon/app/migration/olap/test.csv'  WITH DELIMITER '|' null as 'null';

CREATE INDEX client_dimension_create_time_idx
  ON client_dimension (type_id, create_time);
CREATE INDEX client_dimension_type_id_value
  ON client_dimension(type_id, value);
CREATE INDEX report_client_dimension_lc_woe_id
  ON client_dimension (location_natural_world_woe_id)
  WHERE (location_natural_world_woe_id IS NOT NULL);

      
EOD;
$this->execute($query);
}
}
