<?php

use Phinx\Migration\AbstractMigration;

class FixPagings extends AbstractMigration
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
INSERT INTO paging_table_type (id,name, descr)
SELECT 6,'ddl_materialize_search','Поиск по DDL';

CREATE VIEW vw_ddl_search AS
SELECT
  'function' :: TEXT        AS type,
  pg_get_functiondef(p.oid) AS definition
FROM pg_proc AS p
  JOIN pg_namespace n ON (n.oid = p.pronamespace) AND (n.nspname = 'public' :: NAME)
                         AND p.proisstrict IS FALSE AND prosrc != 'aggregate_dummy'
UNION ALL
SELECT
  'view' :: TEXT                                                           AS type,
  concat_ws(' ', 'CREATE OR REPLACE VIEW', viewname || ' as ', definition) AS definition
FROM pg_views
WHERE schemaname = 'public'
UNION ALL
SELECT *
FROM
  (WITH pkey AS
  (
      SELECT
        cc.conrelid,
        format(E',
    constraint %I primary key(%s)', cc.conname,
               string_agg(a.attname, ', '
               ORDER BY array_position(cc.conkey, a.attnum))) pkey
      FROM pg_catalog.pg_constraint cc
        JOIN pg_catalog.pg_class c ON c.oid = cc.conrelid
        JOIN pg_catalog.pg_attribute a ON a.attrelid = cc.conrelid
                                          AND a.attnum = ANY (cc.conkey)
      WHERE cc.contype = 'p'
      GROUP BY cc.conrelid, cc.conname
  )
  SELECT
    'table' :: TEXT                       AS type,
    format(E'create %stable %s%I\n(\n%s%s\n);\n',
           CASE c.relpersistence
           WHEN 't'
             THEN 'temporary '
           ELSE '' END,
           CASE c.relpersistence
           WHEN 't'
             THEN ''
           ELSE n.nspname || '.' END,
           c.relname,
           string_agg(
               format(E'\t%I %s%s',
                      a.attname,
                      pg_catalog.format_type(a.atttypid, a.atttypmod),
                      CASE WHEN a.attnotnull
                        THEN ' not null'
                      ELSE '' END
               ), E',\n'
           ORDER BY a.attnum
           ),
           (SELECT pkey
            FROM pkey
            WHERE pkey.conrelid = c.oid)) AS sql
  FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    JOIN pg_catalog.pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0
    JOIN pg_catalog.pg_type t ON a.atttypid = t.oid
  WHERE nspname = 'public'
  GROUP BY c.oid, c.relname, c.relpersistence, n.nspname) AS result;

SELECT rebuild_paging_prop('vw_ddl_search','Поиск по DDL конструкциям','ddl_materialize_search',true);

SELECT materialize_worker('recreate','vw_ddl_search',null);

EOD;
$this->execute($query);
}
}
