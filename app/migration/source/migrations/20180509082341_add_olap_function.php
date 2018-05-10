<?php

use Phinx\Migration\AbstractMigration;

class AddOlapFunction extends AbstractMigration
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
        
alter table client_dimension RENAME COLUMN loan to event_1;
alter table client_dimension RENAME COLUMN closed_loan to event_2;
alter table client_dimension RENAME COLUMN open_loan to event_3;
     
CREATE OR REPLACE FUNCTION public.pie_chart_marketing_build(a_agg JSON)
  RETURNS TEXT
AS
$BODY$
DECLARE
  val_value_arr TEXT = (SELECT '(' || string_agg(quote_literal(replace(r :: TEXT, '"', '')), ',') || ')'
                        FROM jsonb_array_elements(a_agg :: JSONB -> 'value') AS r);

  val_class     TEXT = a_agg ->> 'type_id';
  val_fin       TEXT = (a_agg ->> 'agg');
  val_cond      TEXT = CASE WHEN val_fin = 'total'
    THEN ''
                       ELSE ' and ' || val_fin || '>0' END;
  val_since     TIMESTAMP;
  val_till      TIMESTAMP;
  val_result    JSON;

  val_query     TEXT;
BEGIN
  SELECT
    r [1] :: TIMESTAMP,
    r [2] :: TIMESTAMP
  FROM regexp_split_to_array(a_agg ->> 'interval', ' - ', '') AS r
  INTO val_since, val_till;

  val_fin = CASE WHEN val_fin = 'total'
    THEN 'count(*)'
            ELSE 'SUM(S.' || val_fin || ')' END;

  val_query = concat('
      WITH cte AS
    (
        SELECT json_build_object(''name'',coalesce(s.value,''Не определено''), ''y'', ', val_fin, ') AS jb
        FROM client_dimension AS s
        WHERE s.create_time >= ', quote_literal(val_since :: TEXT), '
              AND s.create_time < ', quote_literal((val_till :: DATE + 1) :: TEXT), '
              AND type_id = ', quote_literal(val_class),
                     ' AND value_id in ', val_value_arr, val_cond,
                     ' GROUP BY s.value
                       ORDER BY s.value
                   )
                       SELECT json_agg(jb)
                       FROM cte;');
  EXECUTE val_query
  INTO val_result;

  RETURN json_build_object('data', val_result, 'query', val_query);
END
$BODY$
LANGUAGE plpgsql IMMUTABLE;

select pie_chart_marketing_build('{"_url":"\/olap\/piechart","value":["-1","1","3","4","5","7","6","2"],"interval":"2017.05.09 - 2018.05.10","type_id":"8","agg":"total"}');


EOD;
        $this->execute($query);
    }
}
