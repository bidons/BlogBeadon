<?php

use Phinx\Migration\AbstractMigration;

class AddMaterializeTable extends AbstractMigration
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
  
DROP TABLE IF EXISTS paging_table_materialyze_info;

ALTER TABLE paging_table
  DROP COLUMN m_count;
ALTER TABLE paging_table
  DROP COLUMN m_time;
ALTER TABLE paging_table
  DROP COLUMN m_exec_time;
ALTER TABLE paging_table
  DROP COLUMN m_chart_json_data;

alter table paging_table add COLUMN is_paging_full boolean not null DEFAULT true;

CREATE TABLE paging_table_materialize_info
(
  id                SERIAL PRIMARY KEY,
  paging_table_id   INTEGER NOT NULL REFERENCES paging_table (id),
  m_time            timestamptz,
  m_count           NUMERIC,
  m_exec_time       NUMERIC,
  m_chart_json_data JSONB,
  params_execute    JSONB,
  init_obj_id       INTEGER,
  create_time       TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE paging_table
  ADD COLUMN last_paging_table_materialize_info_id INTEGER;

CREATE OR REPLACE FUNCTION paging_table_materialize_before_insert_info()
  RETURNS TRIGGER
AS
$$
BEGIN  
  UPDATE paging_table
  SET last_paging_table_materialize_info_id = new.id
  WHERE id = new.paging_table_id;

  RETURN NEW;
END;
$$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER paging_table_bch_trg
BEFORE INSERT ON paging_table_materialize_info
FOR EACH ROW EXECUTE PROCEDURE paging_table_materialize_before_insert_info();

DROP FUNCTION if exists materialize_worker( TEXT, TEXT );
ALTER TABLE paging_table rename COLUMN is_materialyze TO is_materialize;

create or replace  function message_ex(a_flag boolean, a_message text, type integer) returns boolean
IMMUTABLE
LANGUAGE plpgsql
AS $$
BEGIN
  IF (a_flag AND type = 1)
  THEN
    RAISE NOTICE '%', a_message;
  ELSEIF (a_flag AND type = -1)
    THEN
      RAISE EXCEPTION '%', a_message;
  END IF;

  RETURN TRUE;

END;
$$;

create or replace function get_paging_table_total_count() returns void
LANGUAGE plpgsql
AS $$
DECLARE
  row record ;
  val_count integer;
  val_id_mat_history integer;
BEGIN
    for row in (select * from paging_table)
    LOOP
          EXECUTE  concat_ws(' ','select count(*)','from', row.name)
          into val_count;

      INSERT INTO paging_table_materialize_info (paging_table_id,m_time,m_count)
        SELECT
          row.id,
          now(),
          val_count
      RETURNING id
      into val_id_mat_history;

      UPDATE paging_table
      SET last_paging_table_materialize_info_id = val_id_mat_history
      WHERE id = row.id;
    END LOOP;
END;
$$;

select get_paging_table_total_count();

CREATE or replace FUNCTION materialize_worker(a_mode TEXT, a_object TEXT, a_person_owner INTEGER)
  RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
  val_m_count       INTEGER;
  val_m_time        TIMESTAMP;
  val_exec_time     NUMERIC;
  val_count_object  INTEGER;
  val_time_exec     TIMESTAMP = clock_timestamp();
  val_chart_query text = '';
  val_result json;
  val_paging_table_id integer;
  val_is_mat boolean;
  val_id_mat_history integer;

BEGIN
    SELECT id,is_materialize,m_query
      FROM paging_table
      WHERE name = a_object
      INTO val_paging_table_id,val_is_mat,val_chart_query;

    PERFORM message_ex(val_is_mat is false,'Materialize view not found: "' || a_object  ||'"',-1);

  IF (a_mode = 'recreate')
  THEN
      EXECUTE 'create MATERIALIZED view if not exists ' || replace(a_object,'vw_','mv_') || ' as
                (
                  SELECT *
                  FROM ' || a_object || ') with NO DATA ;';

      EXECUTE 'REFRESH MATERIALIZED VIEW  ' || replace(a_object,'vw_','mv_');

      IF (val_chart_query IS NOT NULL)
      THEN
        EXECUTE val_chart_query
        INTO val_result;
      END IF;

      EXECUTE 'select count(*) from ' || replace(a_object,'vw_','mv_')
      INTO val_count_object;

      INSERT INTO paging_table_materialize_info (paging_table_id, m_exec_time, m_time, m_count, m_chart_json_data, init_obj_id)
        SELECT
          val_paging_table_id,
          /*date_part('epoch' :: TEXT, clock_timestamp() - val_time_exec) :: DOUBLE PRECISION,*/
          extract('epoch' from clock_timestamp()::time - val_time_exec::time):: DOUBLE PRECISION,
          now(),
          val_count_object,
          val_result,
          a_person_owner
      RETURNING m_time,m_exec_time,m_count,id
      into val_m_time,val_exec_time,val_m_count,val_id_mat_history;

      update paging_table
      set last_paging_table_materialize_info_id = val_id_mat_history
      where id = val_paging_table_id;
  ELSE
    select m_time,m_exec_time,m_count,m_chart_json_data
    from paging_table as p
    join paging_table_materialize_info as pt on p.last_paging_table_materialize_info_id = pt.id
    where p.id = val_paging_table_id
    into val_m_time,val_exec_time,val_m_count,val_result;

  END IF;

  RETURN  json_build_object('m_time',val_m_time,'m_exec_time',val_exec_time,'m_count',val_m_count,'m_view',a_object,'chart_data',val_result);
END;
$$;

create or replace function paging_table_cond(a_argg jsonb) returns text
IMMUTABLE
LANGUAGE plpgsql
AS $$
DECLARE
  val_result TEXT;
BEGIN

    WITH getcolumns AS
  (
      SELECT jsonb_array_elements(a_argg -> 'columns') AS r
  ), normalize AS
  (
      SELECT
        r ->> 'col' AS f_data,
        r ->> 'fc'  AS f_cd,
        r ->> 'fv'  AS f_value,
        r ->> 'ft'  AS f_type
      FROM getcolumns AS t
  )
  SELECT string_agg(case when  (f_type ~ 'timestamp|date')
  THEN concat_ws(' ',
                     f_data,
                     f_cd,
                     quote_literal(split_part(f_value, ' - ', 1)),
                     'and',
                     quote_literal(split_part(f_value, ' - ', 2)))
      when (f_cd = 'in' AND f_type ~ 'int')
        THEN concat_ws(' ',
                       f_data,
                       f_cd,
                       '(' || f_value) || ')'
      when (f_cd = 'in')
        THEN concat_ws(' ',
                       f_data,
                       f_cd,
                       '(' || (SELECT string_agg(quote_literal(r), ',')
                 FROM regexp_split_to_table(f_value,',') AS r)) || ')'
      else  concat_ws(' ',
                       f_data,
                       f_cd,
                       quote_literal(f_value)) end,' and ')
  FROM normalize AS n
  INTO val_result;

  RETURN Coalesce('where true and ' || val_result, 'where true');
END;
$$;

DROP FUNCTION paging_objectdb(jsonb,text,integer);

DROP FUNCTION IF EXISTS paging_objectdb( JSONB );

CREATE OR REPLACE FUNCTION paging_objectdb(a_js JSONB)
  RETURNS SETOF JSONB
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

  val_debug = val_debug || jsonb_build_array(jsonb_build_object('data', val_query, 'time', round(
      (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
  val_result = val_result || jsonb_build_object('data', val_query_result_jsonb);

  val_timestart = clock_timestamp();


  IF (val_mat_mode IS TRUE
      AND val_condition IS NULL
      AND val_m_count_total IS NOT NULL)
  THEN
    val_query = concat_ws(' ', 'select count(*)', 'from', val_table);

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', val_query, 'time', round(
        (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_result = val_result || jsonb_build_object('recordsFiltered', val_m_count_total);

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', val_query, 'time', round(
        (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_result = val_result || jsonb_build_object('recordsTotal', val_m_count_total);

  ELSEIF (val_condition IS NOT NULL
          AND val_mat_mode IS TRUE
          AND val_m_count_total IS NOT NULL)
    THEN
      val_query = concat_ws(' ', 'select count(*)', 'from', val_table, val_condition);

      EXECUTE val_query
      INTO val_query_result_integer;

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', val_query, 'time', round(
          (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
      val_result = val_result || jsonb_build_object('recordsFiltered', val_query_result_integer);

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', val_query, 'time', round(
          (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
      val_result = val_result || jsonb_build_object('recordsTotal', val_m_count_total);
  ELSEIF (val_condition != '' AND
          val_m_count_total IS NOT NULL)
    THEN
      val_query = concat_ws(' ', 'select count(*)', 'from', val_table, val_condition);

      EXECUTE val_query
      INTO val_query_result_integer;

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', val_query, 'time', round(
          (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
      val_result = val_result || jsonb_build_object('recordsFiltered', val_query_result_integer);

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', val_query, 'time', round(
          (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
      val_result = val_result || jsonb_build_object('recordsTotal', val_m_count_total);

  ELSE

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



EOD;
        $this->execute($query);
    }
}
