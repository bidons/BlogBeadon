<?php

use Phinx\Migration\AbstractMigration;

class FirstMigration extends AbstractMigration
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

CREATE OR REPLACE FUNCTION public.is_trigger_fn(a_relname text)
  RETURNS bool
AS
$BODY$
  select true
  from pg_trigger
  where tgname = $1 and
  format_type(tgtype,NULL::integer) = 'tid'
$BODY$
LANGUAGE sql STABLE;

CREATE TABLE public.pg_type_item (
  id serial PRIMARY KEY ,
  type TEXT,
  cond_def JSONB,
  cond_item_def JSONB,
  init_obj_id INTEGER,
  create_time TIMESTAMP WITH TIME ZONE DEFAULT now(),
  update_time TIMESTAMP WITH TIME ZONE
);

INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ('bool', '["="]', '["true", "false"]', null, null, null);
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ('time', null, null, null, null, null);
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ( 'jsonb', '["->"]', null, null, null, null);
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ( 'json', '["->"]', null, null, null, null);
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ('char', '["=", "~", "!=", "in"]', null, null, null, '2016-11-29 13:59:13.717747');
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ('varchar', '["=", "~", "!=", "in"]', null, null, null, '2016-11-29 13:59:13.717747');
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ('text', '["=", "~", "!=", "in"]', null, null, null, '2016-11-29 13:59:13.717747');
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ('int2', '["=", "!=", "<", ">", "<=", ">=", "in"]', null, null, null, '2016-11-29 13:59:13.717747');
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ('int4', '["=", "!=", "<", ">", "<=", ">=", "in"]', null, null, null, '2016-11-29 13:59:13.717747');
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ('int8', '["=", "!=", "<", ">", "<=", ">=", "in"]', null, null, null, '2016-11-29 13:59:13.717747');
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ( 'timestamp', '["between", "not between", "in"]', null, null, null, '2016-11-29 13:59:13.717747');
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ( 'numeric', '["=", "!=", "<", ">", "<=", ">=", "in"]', null, null, null, '2016-11-29 13:59:13.717747');
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ( 'float8', '["=", "!=", "<", ">", "<=", ">=", "in"]', null, null, '2016-12-20 16:54:56.026026', null);
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ( 'timestamptz', '["between", "not between", "in"]', null, null, null, '2016-11-29 15:59:13.717747');
INSERT INTO public.pg_type_item (type, cond_def, cond_item_def, init_obj_id, create_time, update_time) VALUES ('date', '["between", "not between", "in"]', null, null, null, '2017-03-02 17:08:24.234802');

CREATE TABLE public.paging_columns_prop (
  id serial PRIMARY KEY,
  paging_obj TEXT NOT NULL,
  data TEXT NOT NULL,
  title TEXT,
  items JSONB,
  dynamic JSONB,
  is_visible BOOLEAN DEFAULT true,
  is_primary BOOLEAN DEFAULT false,
  person_id INTEGER,
  init_obj_id INTEGER,
  update_time TIMESTAMP WITH TIME ZONE,
  create_time TIMESTAMP WITH TIME ZONE DEFAULT now(),
  priority INTEGER
);
CREATE UNIQUE INDEX paging_columns_prop_paging_obj_data ON paging_columns_prop USING BTREE (paging_obj, data);

CREATE OR REPLACE FUNCTION public.create_fn_trigger_history(a_table_name text)
  RETURNS text
AS
$BODY$
  DECLARE
   val_primary_key_name text = (SELECT  c.column_name
                                FROM information_schema.columns c
LEFT JOIN (SELECT
                                              kcu.column_name,
                                              kcu.table_name,
                                              kcu.table_schema
                                            FROM information_schema.table_constraints tc INNER JOIN
                                              information_schema.key_column_usage kcu ON (
                                                kcu.constraint_name = tc.constraint_name AND
                                                kcu.table_name = tc.table_name AND kcu.table_schema = tc.table_schema)
                                            WHERE tc.constraint_type = 'PRIMARY KEY') pkc
   ON (c.column_name = pkc.column_name AND c.table_schema = pkc.table_schema AND c.table_name = pkc.table_name)
WHERE c.table_schema = 'public' AND c.table_name = a_table_name
 and pkc is not null limit 1);

 val_function_trigger text;

BEGIN
   val_function_trigger = concat_ws(' ','CREATE OR REPLACE FUNCTION',a_table_name || '_bch_trg()
     RETURNS trigger
AS
$$
 BEGIN

      IF (TG_OP= ''DELETE'')
         then
           insert into obj_changelog(table_name, record_key, action_time, action, row_object)
           values (TG_RELNAME',',OLD.' || val_primary_key_name,',now(),TG_OP,row_to_json(old));
           RETURN OLD;
      elseif(TG_OP = ''UPDATE'')
         then
           insert into obj_changelog(table_name, record_key, action_time, action, init_obj_id, table_field, old_table_field, new_table_field)
           SELECT TG_RELNAME',',NEW.' || val_primary_key_name,',now(),TG_OP,NEW.init_obj_id,n.key,o.value,n.value
           FROM json_each_text(row_to_json(new)) as n
           join json_each_text(row_to_json(old)) as o
                 on (o.key = n.key and o.value != n.value) and n.key NOT IN (''update_time'');

           NEW.update_time :=  ''now'';

         RETURN NEW;
      elseif(TG_OP = ''INSERT'')
          then
           insert into obj_changelog(table_name, record_key, action_time, action, row_object)
           values (TG_RELNAME',',NEW.' || val_primary_key_name,',now(),TG_OP,row_to_json(new));

         RETURN NEW;
       end if;
   RETURN NEW;
 END;
$$
LANGUAGE plpgsql VOLATILE');

 return val_function_trigger;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION public.ddl_change_log_hist(a_table_name text)
  RETURNS SETOF text
AS
$BODY$
  DECLARE

 val_function text =  create_fn_trigger_history(a_table_name);
 val_trigger  text = null;
BEGIN
   val_trigger = concat('CREATE TRIGGER ', a_table_name, '_bch_trg ',
            'BEFORE INSERT OR UPDATE OR DELETE ON ', a_table_name,
            ' FOR EACH ROW EXECUTE PROCEDURE ', a_table_name, '_bch_trg();');

   EXECUTE  val_function;
   EXECUTE  val_trigger;
   if exists (
             SELECT  c.column_name
                                FROM information_schema.columns c
where table_name = a_table_name and c.column_name = 'create_time')

   THEN

   EXECUTE  concat('alter table ',a_table_name,' alter column create_time set default current_timestamp');
END IF;

 return QUERY
   select val_function
   UNION ALL
   select val_trigger;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


CREATE OR REPLACE VIEW public.ddl_history_h AS  WITH get_data AS (
         SELECT current_database() AS current_database,
            c.table_name,
            array_agg(concat(c.column_name, ' ', c.udt_name) ORDER BY c.ordinal_position) AS rows,
            count(c.column_name) AS count
           FROM information_schema.columns c
          WHERE (((c.table_schema)::text = 'public'::text) AND ((c.table_name)::text <> 'vw_public_relation'::text))
          GROUP BY c.table_name
        ), rs AS (
         SELECT array_cat(ARRAY['atime timestamp'::text, 'action text'::text], pr.rows) AS pr,
            old_1.rows AS old,
            pr.table_name,
            is_trigger_fn(((pr.table_name)::text || '_before_change_history_trigger'::text)) AS is_trigger_fn
           FROM (get_data pr
             LEFT JOIN get_data old_1 ON (((old_1.table_name)::text = ('old_'::text || (pr.table_name)::text))))
          WHERE (((pr.table_name)::text !~~ 'map_%'::text) AND ((pr.table_name)::text !~~ 'old_%'::text) AND ((pr.table_name)::text !~~ 'mss_%'::text))
        )
 SELECT rs.pr,
    rs.old,
    (rs.pr = rs.old),
    rs.table_name,
    rs.is_trigger_fn
   FROM rs;
   
   CREATE OR REPLACE FUNCTION public.ddl_prepare_history_fields(in a_table_name text, out array_field_main text, out array_field_old text, out create_fields text, out only_fields text, out update_fields text, out delete_fields text)
  RETURNS SETOF record
AS
$BODY$
  BEGIN
  RETURN QUERY
  SELECT
    pr :: TEXT,
    old :: TEXT,
    (SELECT string_agg(r, ',')
     FROM (SELECT split_part(unnest(pr :: TEXT []), ',', 1) AS r) AS qr) create_f,
    (SELECT string_agg(split_part(r, ' ', 1), ',')
     FROM (SELECT split_part(unnest(pr :: TEXT []), ',', 1) AS r) AS qr) only_f,
    (SELECT string_agg('new.' || split_part(r, ' ', 1), ',')
     FROM (SELECT split_part(unnest(array_remove(array_remove(pr :: TEXT [], 'atime timestamp'), 'action text')), ',',
                             1) AS r) AS qr) AS                          update_f,
    (SELECT string_agg('old.' || split_part(r, ' ', 1), ',')
     FROM (SELECT split_part(unnest(array_remove(array_remove(pr :: TEXT [], 'atime timestamp'), 'action text')), ',',
                             1) AS r) AS qr)                             delete_f
  FROM ddl_history_h AS d
  WHERE d.table_name = a_table_name;
END;
$BODY$
LANGUAGE plpgsql STABLE;


CREATE OR REPLACE FUNCTION public.paging_object_db_srch(jsonb)
  RETURNS jsonb
AS
$BODY$
  declare
  srch text = $1 ->>'term';
  objdb text = $1 ->> 'objdb';
  col text = $1 ->> 'col';
  ident text = $1 ->> 'ident';
  rs jsonb;
begin
    if(ident is not null)
      then
          execute  concat('select jsonb_agg(jsonb_build_object(',quote_literal('id'),',',ident,',',quote_literal('text'),',',col,'))'
              ,' from (select ',ident,',',col,' from ',objdb,' where ',' lower(' ||  col || ')',
                         '~',quote_literal(lower(srch)), ' limit 10) as r;')
          into rs;
      else
      execute concat_ws(' ' ,'select jsonb_agg('|| col || ') from (select',col,'from',objdb,'where ','lower(' ||  col || ')',
                        '~',quote_literal(lower(srch)) || ' limit 10) as r;')
        into rs;
    end if;
      return rs;
end;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION public.paging_dbnamespace_cond(a_argg jsonb)
  RETURNS text
AS
$BODY$
  DECLARE
  val_result TEXT;
  val_dbobj  TEXT = a_argg -> 'objdb';
BEGIN

    WITH getcolumns AS
  (
      SELECT jsonb_array_elements(a_argg -> 'columns') AS r

  ), normalize AS
  (
      SELECT
        r ->> 'dataCol'              AS data,
        r ->> 'filterCond' AS cd,
        r ->> 'filterValue' AS value,
        r ->> 'filterType' AS TYPE
      FROM getcolumns AS t
  )
  SELECT string_agg(paging_cond_constructor(n.data, n.cd, n.value, n.type, 'acl_role'), ' and ')
  FROM normalize AS n
    JOIN pg_type_item AS pg ON pg.type = n.type
  INTO val_result;

  RETURN Coalesce('where true and ' || val_result, 'where true');
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION public.paging_create_field(a_object text)
  RETURNS text
AS
$BODY$
  SELECT string_agg(p.attname,',' order by coalesce(pc.priority,p.attnum))
      FROM   pg_attribute as p
                        join pg_type  as t on p.atttypid = t.oid
      left JOIN paging_columns_prop as pc on pc.data = p.attname and pc.paging_obj = $1
      JOIN pg_type_item AS pti ON pti.type = t.typname
                        WHERE  attrelid = $1::regclass
                        AND    attnum > 0
                          AND    NOT attisdropped
$BODY$
LANGUAGE sql IMMUTABLE;

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
  ELSEIF (a_cond = 'in' AND a_type ~ 'text')
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

CREATE OR REPLACE FUNCTION public.paging_objectdb(a_js jsonb, a_ext text, a_debug int4)
  RETURNS SETOF text
AS
$BODY$
  DECLARE
  --  a_debug = 1;  then  debug query,
  --  a_debug = 0;  then  execute query or debug query,

  val_timestart TIMESTAMP = clock_timestamp();

  val_fieldID   TEXT = (a_js ->> 'fieldIds');

  val_ids       TEXT = 'and ' || val_fieldID || ' in (' || (a_js ->> 'ids') || ')';

  -- Draw counter
  val_draw      TEXT = coalesce($1 ->> 'draw', 0 :: TEXT);

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
  val_debug     JSONB = jsonb_build_object('debug', jsonb_build_object('query', NULL));

  val_query     JSONB = '[]';

  val_columns   text;
BEGIN

  IF ((a_js ->> 'columns') IS NOT NULL)
  THEN
    val_condition = paging_dbnamespace_cond(jsonb_build_object('objdb', val_table, 'columns', a_js -> 'columns'));
  END IF;

  SELECT concat_ws(' ', 'with objdb as (', 'select',paging_create_field(val_table),'from', val_table, val_condition, a_ext, val_order, val_offlim
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


  val_query = val_query || jsonb_build_object('recordsTotal', jsonb_build_object
  ('query', val_qfiltered, 'time',
   round((EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
  val_timestart = clock_timestamp();

  -- If condition not exists then total else total with condition
  IF (val_condition = 'where true' or val_offlim is null )
  THEN
    val_total = val_filtered;
  ELSE
    EXECUTE val_qtotal
    INTO val_total;

    val_query = val_query || jsonb_build_object('recordsTotal', jsonb_build_object
    ('query', val_qtotal, 'time',
     round((EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_timestart = clock_timestamp();
  END IF;

  -- Json result for datatable
  RETURN QUERY
  SELECT (jsonb_build_object('draw', val_draw, 'recordsTotal', val_total, 'recordsFiltered', val_filtered,
                             'data', coalesce(val_data, '[]') :: JSONB, 'debug',
                             jsonb_build_object('query', val_query))) :: TEXT;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

EOD;
        $this->execute($query);
    }
}
