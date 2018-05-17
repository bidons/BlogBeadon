<?php

use Phinx\Migration\AbstractMigration;

class FixOlap extends AbstractMigration
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
create or replace function get_table_chart_olap(a_agg json) returns text
IMMUTABLE
LANGUAGE plpgsql
AS $$
DECLARE
  val_timestart TIMESTAMP = clock_timestamp();
  val_value_arr TEXT[] = ARRAY(SELECT json_array_elements_text(a_agg -> 'value'));

  val_type_id   TEXT = a_agg ->> 'type_id';
  val_agg       TEXT = a_agg ->> 'agg';
  val_cond      TEXT = CASE WHEN val_agg = 'total'
                            THEN ''
                       ELSE 'and ' || val_agg || '>0' END;
  val_since     DATE;
  val_till      DATE;

  val_result    JSONB;

  val_query     TEXT;

  val_dimension text;
  val_record_set text;

BEGIN
  SELECT
    r [1] :: DATE,
    r [2] :: DATE
  FROM regexp_split_to_array(a_agg ->> 'interval', ' - ', '') AS r
  INTO val_since, val_till;

  select string_agg(value_id::text,',' order by value_id) as dimension,
        '"create_time" date,' ||   string_agg('"' || value || '" integer',',' order by value_id)
  from client_dimension_guide
  where value_id =any (val_value_arr::integer[]) and type_id = val_type_id::integer
    into val_dimension,val_record_set;

  val_agg = CASE WHEN val_agg = 'total'
                 THEN 'COUNT(*)'
                 ELSE 'SUM(' || val_agg || ')' END;
  val_query =
        quote_literal(concat('SELECT
        create_time as "Дата создания",
        value_id AS value_id,
        ',val_agg, 'AS s
        FROM client_dimension
        WHERE value_id IN (', val_dimension,')
            AND type_id =', val_type_id,'
            AND create_time >=', quote_literal(val_since),'
            AND create_time < ', quote_literal(val_till),
            val_cond,
        'GROUP BY create_time, value_id
        ORDER BY create_time desc'));

  val_query = concat('SELECT json_agg(final_result)
                      FROM crosstab(',val_query,','
                     '''SELECT unnest(array[',val_dimension,']) as r''',
                     ') AS final_result(',val_record_set,');');

  EXECUTE val_query
  INTO val_result;

  RETURN jsonb_build_object('data',val_result,'query',val_query,'time',round((EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4));
END
$$;

EOD;
$this->execute($query);
}
}
