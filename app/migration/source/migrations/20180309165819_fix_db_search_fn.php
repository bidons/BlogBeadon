<?php

use Phinx\Migration\AbstractMigration;

class FixDbSearchFn extends AbstractMigration
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

CREATE OR REPLACE FUNCTION public.paging_object_db_srch(json)
  RETURNS json
AS
$BODY$
  declare
  srch text = $1 ->>'term';
  objdb text = $1 ->> 'objdb';
  col text = $1 ->> 'col';

  col_type text = $1 ->> 'type';
  rs json;
  searchingField text = ' lower(' ||  col || ')';

  val_query text;
  val_time_exec TIMESTAMP = clock_timestamp();
begin
        if(col_type = 'text')
          then
          val_query = concat('select json_agg(',col,')'
              ,' from (select ',col,' from ',objdb,' where ',searchingField,
                         'like ',quote_literal('%' || lower(srch) || '%'), ' limit 10) as r;');

          EXECUTE val_query
          into rs;

          ELSEIF  (col_type ~ 'int' and str2integer(srch) is not null)
          THEN

          val_query = concat('select json_agg(',col,')'
              ,' from (select ',col,' from ',objdb,' where ',col,'=',srch,' limit 10) as r;');

          EXECUTE val_query
          into rs;
          END IF;

      return json_build_object('rs',rs,'query',val_query,'time',round((EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_time_exec)) :: NUMERIC, 4));
end;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

update paging_columns_prop
set condition = null
where id in (
select pcp.id
from paging_columns_prop as pcp
join pg_type_item as pti on pti.id =pcp.pg_type_item_id
where pti.name  in ('timestamptz','jsonb','json','bool','numeric'));


CREATE OR REPLACE FUNCTION public.paging_objectdb(a_js jsonb, a_ext text, a_debug int4)
  RETURNS SETOF text
AS
$BODY$
  DECLARE
  --  a_debug = 1;  then  debug query,
  --  a_debug = 0;  then  execute query or debug query,

  val_mat_mode boolean =  (a_js ->> 'is_mat');

  val_timestart TIMESTAMP = clock_timestamp();

  val_fieldID   TEXT = (a_js ->> 'fieldIds');

  val_ids       TEXT = 'and ' || val_fieldID || ' in (' || (a_js ->> 'ids') || ')';

  -- Draw counter
  val_draw      integer  = coalesce(($1 ->> 'draw')::integer, 0 :: integer);

  -- Database objects name (table, view, materialize view, file_fdw, postgres_fdw, dblink)
  val_table     TEXT = $1 ->> 'objdb';

  -- Create order condition {"order":[{"column":"id","dir":"desc"},{"column":"id2","dir":"asc"}} ,
  val_order     text = (select Coalesce('order by ' || string_agg((value ->> 'column') || ' ' || (value ->> 'dir'),','),'')
                              from (select * from jsonb_array_elements(a_js -> 'order')) as r
                      where value ->> 'column' !='' and value ->> 'dir' !='');

  val_limit  text =  $1 ->> 'length';
  val_offset text =  $1 ->> 'start';

  val_offlim text = case when val_limit = '-1' or val_offset = '-1' then null
    else ' limit ' || val_limit || ' offset ' || val_offset end;

  val_condition TEXT = ' where true ';

  val_qdata     TEXT;
  val_qtotal    TEXT;
  val_qfiltered TEXT;
  val_qids      TEXT;
  val_qbids     TEXT;

  val_data      TEXT;
  val_total     TEXT;
  val_filtered  TEXT;
  val_rbids     JSON;
  val_rids      JSON;

  val_result    JSONB = jsonb_build_object('debug', jsonb_build_object('query', NULL));

  val_query     JSONB = '[]';

  val_m_count_total integer;
  val_m_columns text;
  val_m_prop_column jsonb;
BEGIN

    SELECT m_column,m_count,'{}'/*case when val_draw = 1 then m_prop_column_full  else '{}'end*/
    from paging_table where name = val_table
    into val_m_columns, val_m_count_total,val_m_prop_column;

  IF ((a_js ->> 'columns') IS NOT NULL)
  THEN
    val_condition = paging_dbnamespace_cond(jsonb_build_object('objdb', val_table, 'columns', a_js -> 'columns'));
  END IF;

  val_table = case when val_mat_mode then  replace(val_table,'vw','mv') else val_table end;

  SELECT concat_ws(' ', 'with objdb as (', 'select',val_m_columns,'from', val_table, val_condition, a_ext, val_order, val_offlim
  , ')', 'SELECT ', 'json_agg(row_to_json(objdb)) from objdb')
  INTO val_qdata;

  IF (val_ids IS NOT NULL)
  THEN
        val_qbids = concat_ws(' ', 'select json_agg(', val_table || ')::text',
                          'from', val_table, val_condition, val_ids, a_ext);

    EXECUTE val_qbids
    INTO val_rbids;

    val_query = val_query || jsonb_build_object('bids', jsonb_build_object
    ('query', val_qbids, 'time',
     round((EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_timestart = clock_timestamp();

    RETURN QUERY
    SELECT jsonb_build_object('data', val_rbids, 'debug', jsonb_build_object('query', val_query)) :: TEXT;

    RETURN;
  END IF;

  IF (val_fieldID IS NOT NULL)
  THEN
    val_qids = concat_ws(' ', 'select json_agg(', val_fieldID || ')::text', 'from', val_table, val_condition, val_ids,
                         a_ext);

    EXECUTE val_qids
    INTO val_rids;

    val_query = val_query || jsonb_build_object('ids', jsonb_build_object
    ('query', val_rids, 'time',
     round((EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_timestart = clock_timestamp();

    RETURN QUERY
    SELECT jsonb_build_object('data', val_rids, 'debug', jsonb_build_object('query', val_query)) :: TEXT;

    RETURN;
  END IF;

  -- Query: count by condition
  SELECT concat_ws(' ', 'select count(*)', 'from', val_table, val_condition)
  INTO val_qfiltered;

  -- Query: total count
  SELECT concat_ws(' ', 'select count(*)', 'from', val_table)
  INTO val_qtotal;

  -- Debug query if enable
  IF (a_debug = 1)
  THEN
    RETURN QUERY SELECT jsonb_build_object('debug', 'query', val_result);
    RETURN;
  END IF;

  -- Execute query
  EXECUTE val_qdata
  INTO val_data;

  val_query = val_query || jsonb_build_object('data', jsonb_build_object
  ('query', val_qdata, 'time',
   round((EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
  val_timestart = clock_timestamp();

  -- Execute query count with filter
    if (val_offlim is not null)
      then
  EXECUTE val_qfiltered
        INTO val_filtered;
      end if;

  val_query = val_query || jsonb_build_object('recordsFiltered', jsonb_build_object
  ('query', val_qfiltered, 'time',
   round((EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
  val_timestart = clock_timestamp();

  -- If condition not exists then total else total with condition
  IF (val_condition = 'where true' or val_offlim is null )
  THEN
    val_total = val_filtered;
  ELSE
        if(coalesce(val_m_count_total,0) >0)
          then
          val_total = val_m_count_total;
        else
          EXECUTE val_qtotal
          INTO val_total;
          end if;

    val_query = val_query || jsonb_build_object('recordsTotal', jsonb_build_object
    ('query', val_qtotal, 'time',
     round((EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_timestart = clock_timestamp();
  END IF;

  -- Json result for datatable
  RETURN QUERY
  SELECT ((jsonb_build_object('draw', val_draw, 'recordsTotal', val_total, 'recordsFiltered', val_filtered,
                             'data', coalesce(val_data, '[]') :: JSONB, 'debug',
                             jsonb_build_object('query', val_query))) || val_m_prop_column)::text ;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION public.paging_object_db_srch(json)
  RETURNS json
AS
$BODY$
  declare
  srch text = $1 ->>'term';
  objdb text = $1 ->> 'objdb';
  col text = $1 ->> 'col';

  col_type text = $1 ->> 'type';
  rs json;
  searchingField text = ' lower(' ||  col || ')';

  val_query text;
  val_time_exec TIMESTAMP = clock_timestamp();
begin
        if(col_type ~ 'text')
          then
          val_query = concat('select json_agg(',col,')'
              ,' from (select ',col,' from ',objdb,' where ',searchingField,
                         'like ',quote_literal('%' || lower(srch) || '%'), ' limit 10) as r;');

          EXECUTE val_query
          into rs;

          ELSEIF  (col_type ~ 'int' and str2integer(srch) is not null)
          THEN

          val_query = concat('select json_agg(',col,')'
              ,' from (select ',col,' from ',objdb,' where ',col,'=',srch,' limit 10) as r;');

          EXECUTE val_query
          into rs;
          END IF;

      return json_build_object('rs',rs,'query',val_query,'time',round((EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_time_exec)) :: NUMERIC, 4));
end;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION public.paging_cond_constructor(a_data text, a_cond text, a_value text, a_type text, a_objdb text)
  RETURNS text
AS
$BODY$
  BEGIN

  IF (a_type ~ 'timestamp|date')
  THEN
    RETURN concat_ws(' ',
                     a_data,
                     a_cond,
                     quote_literal(split_part(a_value, ' - ', 1)),
                     'and',
                     quote_literal(split_part(a_value, ' - ', 2)));
  ELSEIF (a_cond = 'in' AND a_type ~ 'int')
    THEN
      RETURN concat_ws(' ',
                       a_data,
                       a_cond,
                       '(' || a_value) || ')';
  ELSEIF (a_cond = 'in' AND a_type ~ 'text|varchar')
    THEN

      a_value = (SELECT string_agg(quote_literal(r), ',')
                 FROM regexp_split_to_table(a_value,',') AS r);

      RETURN concat_ws(' ',
                       a_data,
                       a_cond,
                       '(' || a_value) || ')';

  ELSEIF (a_type ~ 'char|var|text')
    THEN
      RETURN concat_ws(' ',
                       a_data,
                       a_cond,
                       quote_literal(a_value));
  ELSE
    RETURN concat_ws(' ',
                     a_data,
                     a_cond,
                     a_value);
  END IF;

  RETURN '';
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION public.str2integer(a text)
  RETURNS int4
AS
$BODY$
  BEGIN
  RETURN a :: INTEGER;
  EXCEPTION WHEN OTHERS THEN
  RETURN null;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

EOD;
        $this->execute($query);
    }
}
