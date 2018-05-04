<?php

use Phinx\Migration\AbstractMigration;

class DellGarbage extends AbstractMigration
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
        $query = <<<'EOD'
        
drop FUNCTION paging_dbnamespace_column_prop_ext(text);
drop FUNCTION paging_dbnamespace_column_prop_ext(text,boolean);
drop FUNCTION paging_dbnamespace_column_prop_save(jsonb,text);
drop FUNCTION paging_table_cond(jsonb);

create or replace function paging_objectdb(a_js jsonb) returns SETOF jsonb
LANGUAGE plpgsql
AS $$
DECLARE
  val_timestart            TIMESTAMP = clock_timestamp();

  val_draw                 INTEGER = coalesce(($1 ->> 'draw') :: INTEGER, 0 :: INTEGER);
  val_table                TEXT;

  val_order                TEXT = (SELECT 'order by ' || string_agg((r ->> 'column') || ' ' || (r ->> 'dir'), ',')
                                   FROM (
                                          SELECT jsonb_array_elements(a_js -> 'order') AS r
                                        ) AS r);
  val_offlim               TEXT = ' limit ' || COALESCE($1 ->> 'length', '0') || ' offset ' ||
                                  COALESCE($1 ->> 'start', '0');
  val_condition            TEXT ;

  val_query                TEXT;
  val_result               JSONB = '{}';
  val_query_result_jsonb   JSONB = '{}';
  val_query_result_integer INTEGER;
  val_debug                JSONB = '[]';
  val_mat_mode             BOOLEAN;
  val_m_count_total        INTEGER;
  val_m_columns            TEXT;
  val_condition_arg        JSONB = a_js -> 'columns';
  val_paging                boolean;
BEGIN

  SELECT
    p.m_column,
    ptm.m_count,
    is_materialize,
    p.name,
    is_paging_full
  FROM paging_table AS p
   left JOIN paging_table_materialize_info AS ptm ON ptm.id = p.last_paging_table_materialize_info_id
  WHERE p.name = $1 ->> 'objdb'
  INTO val_m_columns, val_m_count_total, val_mat_mode, val_table,val_paging;

  IF (val_condition_arg IS NOT NULL)
  THEN
    WITH getcolumns AS
    (
        SELECT jsonb_array_elements(val_condition_arg) AS r
    ), normalize AS
    (
        SELECT
          r ->> 'col' AS f_data,
          r ->> 'fc'  AS f_cd,
          r ->> 'fv'  AS f_value,
          r ->> 'ft'  AS f_type
        FROM getcolumns AS t
    )
    SELECT ' where ' || string_agg(CASE WHEN (f_type ~ 'timestamp|date')
      THEN concat_ws(' ',
                     f_data,
                     f_cd,
                     quote_literal(split_part(f_value, ' - ', 1)),
                     'and',
                     quote_literal(split_part(f_value, ' - ', 2)))
                      WHEN (f_cd = 'in' AND f_type ~ 'int')
                        THEN concat_ws(' ',
                                       f_data,
                                       f_cd,
                                       '(' || f_value) || ')'
                      WHEN (f_cd = 'in')
                        THEN concat_ws(' ',
                                       f_data,
                                       f_cd,
                                       '(' || (SELECT string_agg(quote_literal(r), ',')
                                               FROM regexp_split_to_table(f_value, ',') AS r)) || ')'
                      ELSE concat_ws(' ',
                                     f_data,
                                     f_cd,
                                     quote_literal(f_value)) END, ' and ')
    FROM normalize AS n
    INTO val_condition;
  END IF;

  -- if materialize
  val_table = CASE WHEN val_mat_mode
    THEN replace(val_table, 'vw', 'mv')
              ELSE val_table END;

  SELECT concat_ws(' ', 'WITH objdb as (',
                   'select', val_m_columns,
                   'FROM', val_table,
                   val_condition, val_order, val_offlim
  , ')', 'SELECT ', 'json_agg(row_to_json(objdb)) from objdb')
  INTO val_query;

  EXECUTE val_query
  INTO val_query_result_jsonb;

  val_debug = val_debug || jsonb_build_array(jsonb_build_object('data',val_query, 'time', round(
      (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
  val_result = val_result || jsonb_build_object('data', coalesce(val_query_result_jsonb,'[]'));

  val_timestart = clock_timestamp();


  IF (val_mat_mode IS TRUE
      AND val_condition IS NULL
      AND val_m_count_total IS NOT NULL)
  THEN
    val_query = concat_ws(' ', 'select count(*)', 'from', val_table);

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', null, 'time',null));
    val_result = val_result || jsonb_build_object('recordsFiltered', val_m_count_total);

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', null, 'time',null));
    val_result = val_result || jsonb_build_object('recordsTotal', val_m_count_total);

  ELSEIF (val_condition IS NOT NULL
          AND val_m_count_total IS NOT NULL)
    THEN
      val_query = concat_ws(' ', 'select count(*)', 'from', val_table, val_condition);

      EXECUTE val_query
      INTO val_query_result_integer;

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', val_query, 'time', round(
          (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
      val_result = val_result || jsonb_build_object('recordsFiltered', val_query_result_integer);

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', null, 'time',null));
      val_result = val_result || jsonb_build_object('recordsTotal', val_m_count_total);
  ELSEIF (val_condition is not null AND
          val_m_count_total IS NOT NULL)
    THEN
      RAISE EXCEPTION 'asd';
      val_query = concat_ws(' ', 'select count(*)', 'from', val_table, val_condition);

      EXECUTE val_query
      INTO val_query_result_integer;

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', val_query, 'time', round(
          (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
      val_result = val_result || jsonb_build_object('recordsFiltered', val_query_result_integer);



      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal',val_query_result_integer, 'time',null));
      val_result = val_result || jsonb_build_object('recordsTotal', val_m_count_total);

  ELSEif (val_condition is null)
    then

    val_query = concat_ws(' ', 'select count(*)', 'from', val_table);

    val_timestart = clock_timestamp();

    EXECUTE val_query
    INTO val_query_result_integer;

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', null, 'time',null));
    val_result = val_result || jsonb_build_object('recordsFiltered', val_query_result_integer);

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', val_query, 'time', round(
        (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_result = val_result || jsonb_build_object('recordsTotal', val_query_result_integer);
  else
    val_query = concat_ws(' ', 'select count(*)', 'from', val_table, val_condition);

    EXECUTE val_query
    INTO val_query_result_integer;

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', val_query, 'time', round(
        (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_result = val_result || jsonb_build_object('recordsFiltered', val_query_result_integer);

    val_query = concat_ws(' ', 'select count(*)', 'from', val_table);

    val_timestart = clock_timestamp();

    EXECUTE val_query
    INTO val_query_result_integer;

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', val_query, 'time', round(
        (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_result = val_result || jsonb_build_object('recordsTotal', val_query_result_integer);
  END IF;

  RETURN QUERY
  SELECT val_result || jsonb_build_object('debug', val_debug);

END;
$$;

update paging_table
set last_paging_table_materialize_info_id = null
where id in
      (select p.id
from paging_table as p
LEFT JOIN paging_table_materialize_info as pp on p.last_paging_table_materialize_info_id = pp.id
where is_materialize is false);

EOD;
        $this->execute($query);
    }
}
