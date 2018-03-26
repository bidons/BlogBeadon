<?php

use Phinx\Migration\AbstractMigration;

class NewMig extends AbstractMigration
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

/*create table temp_table_paging_table as (select * from paging_table);
create table temp_table_paging_columns_prop as (select * from paging_columns_prop);*/

drop view  if exists vw_paging_columns_prop;
drop table if exists paging_columns_prop;
drop table if exists paging_table;
drop table if exists paging_table_type;
drop table if exists pg_type_item;

CREATE TABLE public.paging_table_type (
 id          SERIAL PRIMARY KEY,
 name        TEXT NOT NULL UNIQUE,
 descr       TEXT,
 init_obj_id INTEGER,
 create_time TIMESTAMP WITH TIME ZONE DEFAULT now(),
 update_time TIMESTAMP WITH TIME ZONE
);

CREATE TABLE paging_table
(
  id SERIAL PRIMARY KEY,
  paging_table_type_id INTEGER not null REFERENCES paging_table_type(id),
  name                 TEXT    NOT NULL UNIQUE,
  descr                TEXT,
  m_prop_column_full  JSONB,
  m_prop_column_small JSONB,
  m_column             text,
  init_obj_id          INTEGER,
  is_materialyze       BOOLEAN                  DEFAULT FALSE,
  m_count              INTEGER,
  m_time               TIMESTAMP WITH TIME ZONE,
  m_exec_time          NUMERIC,
  m_chart_json_data    JSON,
  m_query              TEXT,
  create_time          TIMESTAMP WITH TIME ZONE DEFAULT now(),
  update_time          TIMESTAMP WITH TIME ZONE
);

CREATE UNIQUE INDEX paging_table_name_paging_table_type_id ON paging_table (name);

INSERT INTO public.paging_table_type (id, name, descr, init_obj_id, create_time, update_time) VALUES (1, 'public', 'Таблички (public)', null, '2017-03-14 17:54:15.109763', null);
INSERT INTO public.paging_table_type (id, name, descr, init_obj_id, create_time, update_time) VALUES (2, 'view', 'Вьюхи', null, '2017-03-14 17:54:15.109763', null);
INSERT INTO public.paging_table_type (id, name, descr, init_obj_id, create_time, update_time) VALUES (3, 'view_materialize', 'Материализованные вьюшки', null, '2017-03-14 17:54:15.109763', null);
INSERT INTO public.paging_table_type (id, name, descr, init_obj_id, create_time, update_time) VALUES (4, 'view_useful', 'Обвёртки (полезные запросы)', null, '2017-03-14 17:54:15.712535', null);
/*INSERT INTO public.paging_table_type (id, name, descr, init_obj_id, create_time, update_time) VALUES (5, 'Admin', 'Отчёты для разработчиков', null, '2017-03-14 17:54:15.109763', '2017-09-22 10:21:06.085153 +03:00');*/

CREATE TABLE pg_type_item
(
  id SERIAL PRIMARY KEY ,
  name          TEXT,
  cond_default  JSONB,
  init_obj_id   INTEGER,
  create_time   TIMESTAMP WITH TIME ZONE DEFAULT now(),
  update_time   TIMESTAMP WITH TIME ZONE
);

CREATE TABLE paging_columns_prop
(
  id SERIAL PRIMARY KEY,
  paging_table_id integer not null REFERENCES paging_table(id) on DELETE CASCADE ,
  pg_type_item_id integer REFERENCES pg_type_item(id),
  name            TEXT NOT NULL,
  title           TEXT,
  condition       JSONB,
  item_condition  JSONB,
  is_filter       BOOLEAN DEFAULT true,
  is_visible      BOOLEAN DEFAULT TRUE,
  is_orderable    BOOLEAN DEFAULT true,
  is_primary      BOOLEAN DEFAULT FALSE,
  init_obj_id     INTEGER,
  update_time     TIMESTAMP WITH TIME ZONE,
  create_time     TIMESTAMP WITH TIME ZONE DEFAULT now(),
  priority        INTEGER
);
CREATE UNIQUE INDEX paging_paging_table_id_name_uniq ON paging_columns_prop (paging_table_id, name);

INSERT INTO public.pg_type_item (name, cond_default) VALUES ('bool', '["="]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('time', null);
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('jsonb', '["->>"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('json', '["->>"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('char', '["=", "~", "!=", "in"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('varchar', '["=", "~", "!=", "in"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('text', '["=", "~", "!=", "in"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('int2', '["=", "!=", "<", ">", "<=", ">=", "in"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('int4', '["=", "!=", "<", ">", "<=", ">=", "in"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('int8', '["=", "!=", "<", ">", "<=", ">=", "in"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('timestamp', '["between", "not between", "in"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('numeric', '["=", "!=", "<", ">", "<=", ">=", "in"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('float8', '["=", "!=", "<", ">", "<=", ">=", "in"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('timestamptz', '["between", "not between", "in"]');
INSERT INTO public.pg_type_item (name, cond_default) VALUES ('date', '["between", "not between", "in"]');

create or REPLACE function get_set_paging_table_object(a_name text, a_descr text,a_type text,a_is_mat boolean) returns integer
VOLATILE
LANGUAGE plpgsql
AS $$
declare
  val_id integer = (select id from paging_table where name = $1);
  val_type_id integer = (select id from paging_table_type where name = $3);
BEGIN
      if (val_id is null)
        then
              insert into paging_table(name,descr,paging_table_type_id,is_materialyze)
                select $1,$2,Coalesce(val_type_id,1),coalesce(a_is_mat,false)
              RETURNING id
              into val_id;
        END IF;
      RETURN val_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rebuild_paging_prop(a_vw_view text,a_descr text, a_type_name text,a_is_mat bool)
 RETURNS text
AS
$BODY$
 DECLARE
    val_object_deleted integer[];
    val_object_table_id integer = (select id from paging_table where name =a_vw_view);
BEGIN
      with cte as
        (
      SELECT pv.tablename, isc.column_name as col, t.typname AS col_type,pgi.id as col_type_id,val_object_table_id as paging_table_id,p.attnum as pr
        FROM pg_tables AS pv
        JOIN information_schema.columns AS isc ON pv.tablename = isc.table_name
        JOIN pg_attribute AS p ON p.attrelid = isc.table_name :: REGCLASS AND isc.column_name = p.attname
        JOIN pg_type AS t ON p.atttypid = t.oid
        left join pg_type_item as pgi on pgi.name = t.typname
        where pv.tablename = a_vw_view and schemaname = 'public'
    UNION ALL
        SELECT pv.viewname, isc.column_name as col, t.typname AS col_type,pgi.id as col_type_id,val_object_table_id,p.attnum as pr
        FROM pg_views AS pv
        JOIN information_schema.columns AS isc ON pv.viewname = isc.table_name
        JOIN pg_attribute AS p ON p.attrelid = isc.table_name :: REGCLASS AND isc.column_name = p.attname
        JOIN pg_type AS t ON p.atttypid = t.oid
        left join pg_type_item as pgi on pgi.name = t.typname
        WHERE schemaname = 'public' and pv.viewname = a_vw_view
        ), del_if_not_exists_in_public_schema as
        (
              delete from paging_table
              where id = val_object_table_id and not exists (select 1 from cte limit 1)
              RETURNING id
        ),get_set_table_id_by_name as
        (
            select get_set_paging_table_object as id
            from get_set_paging_table_object((select tablename from cte limit 1),a_descr,a_type_name,a_is_mat)
            where exists(select 1 from cte)
        ), update_diff_type as
        (
                update  paging_columns_prop
                set pg_type_item_id = r.col_type_id
              from (select pcp.id,cte.col_type_id
                    from cte
                    join paging_columns_prop   as pcp on pcp.name = cte.col and pcp.pg_type_item_id = cte.col_type_id
                    where pcp.paging_table_id = (select id from get_set_table_id_by_name)) as r
                where r.id = paging_columns_prop.id
                RETURNING paging_columns_prop.id

        ), ins_if_not_exists as
        (
           insert into paging_columns_prop(paging_table_id,pg_type_item_id, name,priority)
             select tbl.id,col_type_id,col,pr
             from cte
             join get_set_table_id_by_name as tbl on true
             left join paging_columns_prop as ppc on ppc.id not in (select r.id from update_diff_type as r) and ppc.name =cte.col
             returning paging_columns_prop.id
        ), del_garbage as
        (
            delete  from paging_columns_prop
            where paging_table_id = (select id from get_set_table_id_by_name)
              and id not in (select r.id from ins_if_not_exists as r
                             UNION ALL
                             select r.id from update_diff_type as r)
              RETURNING paging_columns_prop.id
        /*), materialize_paging as
        (
            update paging_table
              set m_prop_column_full = full_data,
                  m_prop_column_small = small_data
            from (SELECT jsonb_build_object('columns',
                          jsonb_agg(jsonb_build_object(
                                                 'data',p.name,
                                                 'visible',coalesce(p.is_visible,false),
                                                 'primary', coalesce(is_primary,true),
                                                 'title',   coalesce(p.title,p.name),
                                                 'type', pt.name,
                                                 'cd',coalesce(p.condition,pt.cond_default),
                                                 'cdi', p.item_condition) ORDER by p.priority)) as full_data,
              jsonb_build_object('columns',
                          jsonb_agg(jsonb_build_object(
                                                 'data',p.name ,
                                                 'visible',coalesce(p.is_visible,false),
                                                 'primary',coalesce(is_primary,true),
                                                 'title',  coalesce(p.title,p.name),
                                                 'type', pt.name) ORDER by priority)) as small_data,
                p.paging_table_id
            from paging_columns_prop as p
            join pg_type_item as pt on p.pg_type_item_id = pt.id
              where p.paging_table_id = (select id from get_set_table_id_by_name)
            GROUP BY  p.paging_table_id ) as rs
              where rs.paging_table_id = paging_table.id
            RETURNING paging_table.id
        )*/), get_all as
        (
              select *
                from del_if_not_exists_in_public_schema
              UNION ALL
                select *
                from get_set_table_id_by_name
              UNION ALL
                select *
                from update_diff_type
              UNION ALL
                select *
                from ins_if_not_exists
              UNION ALL
                select *
                from del_garbage
          )
        select array_agg(id)
        from get_all
        into val_object_deleted;


            update paging_table
              set m_prop_column_full = full_data,
                  m_prop_column_small = small_data
            from (SELECT jsonb_build_object('columns',
                          jsonb_agg(jsonb_build_object(
                                                 'data',p.name,
                                                 'visible',coalesce(p.is_visible,false),
                                                 'primary', coalesce(is_primary,true),
                                                 'title',   coalesce(p.title,p.name),
                                                 'type', pt.name,
                                                 'cd',coalesce(p.condition,pt.cond_default),
                                                 'cdi', p.item_condition) ORDER by p.priority)) as full_data,
              jsonb_build_object('columns',
                          jsonb_agg(jsonb_build_object(
                                                 'data',p.name ,
                                                 'visible',coalesce(p.is_visible,false),
                                                 'primary',coalesce(is_primary,true),
                                                 'title',  coalesce(p.title,p.name),
                                                 'type', pt.name) ORDER by priority)) as small_data,
                p.paging_table_id
            from paging_columns_prop as p
            join pg_type_item as pt on p.pg_type_item_id = pt.id
              where p.paging_table_id = (select id from paging_table where name =a_vw_view)
            GROUP BY  p.paging_table_id ) as rs
              where rs.paging_table_id = paging_table.id;

    RETURN '';
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

  create or replace  function paging_dbnamespace_cond(a_argg jsonb) returns text
IMMUTABLE
LANGUAGE plpgsql
AS $$
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
    JOIN pg_type_item AS pg ON pg.name = n.type
  INTO val_result;

  RETURN Coalesce('where true and ' || val_result, 'where true');
END;
$$;

ALTER SEQUENCE paging_table_id_seq RESTART WITH 100000;

create or replace function get_set_paging_table_object(a_name text, a_descr text, a_type text, a_is_mat boolean) returns integer
LANGUAGE plpgsql
AS $$
declare
  val_id integer = (select id from paging_table where name = $1);
  val_type_id integer = (select id from paging_table_type where name = $3);
BEGIN

      if(a_name is null or val_id is null)
        then
            return val_id;
      END IF;

      if (val_id is null)
        then
              insert into paging_table(name, descr,paging_table_type_id,is_materialyze)
                select $1,$2,Coalesce(val_type_id,1),coalesce(a_is_mat,false)
              RETURNING id
              into val_id;
        END IF;
      RETURN val_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.rebuild_paging_prop(a_vw_view text,a_descr text, a_type_name text,a_is_mat bool)
 RETURNS text
AS
$BODY$
 DECLARE
    val_object_table_id integer = (select id from paging_table where name =a_vw_view);
BEGIN
      drop table if EXISTS temp_paging_col_prop;

      create temp table temp_paging_col_prop as
      (
        SELECT pv.viewname as tablename, isc.column_name as col, t.typname AS col_type,pgi.id as col_type_id,p.attnum as pr
          FROM pg_views AS pv
            JOIN information_schema.columns AS isc ON pv.viewname = isc.table_name
            JOIN pg_attribute AS p ON p.attrelid = isc.table_name :: REGCLASS AND isc.column_name = p.attname
            JOIN pg_type AS t ON p.atttypid = t.oid
            left join pg_type_item as pgi on pgi.name = t.typname
        WHERE schemaname = 'public' and pv.viewname = a_vw_view
       union all  
       SELECT pv.tablename as tablename, isc.column_name as col, t.typname AS col_type,pgi.id as col_type_id,p.attnum as pr
          FROM pg_tables AS pv
        JOIN information_schema.columns AS isc ON pv.tablename = isc.table_name
       JOIN pg_attribute AS p ON p.attrelid = isc.table_name :: REGCLASS AND isc.column_name = p.attname
       JOIN pg_type AS t ON p.atttypid = t.oid
       left join pg_type_item as pgi on pgi.name = t.typname
       where pv.schemaname = 'public' and pv.tablename = a_vw_view
      );

            --- delete if table not exists
            delete from paging_table
                  where id = val_object_table_id
                            and not exists (select 1
                                            from temp_paging_col_prop limit 1)
             RETURNING id
               into val_object_table_id;

            --- create object if not exists (return paging_table_id)
            select get_set_paging_table_object as id
            from get_set_paging_table_object((select tablename from temp_paging_col_prop limit 1),a_descr,a_type_name,a_is_mat)
               into val_object_table_id;

            --- update paging_columns_prop
            update  paging_columns_prop
                set pg_type_item_id = r.col_type_id,priority = coalesce(priority,r.pr)
            from (select pcp.id,t.col_type_id,t.pr
                    from temp_paging_col_prop  as t
                    join paging_columns_prop   as pcp on pcp.name = t.col
                    where pcp.paging_table_id = val_object_table_id
                 ) as r
            where r.id = paging_columns_prop.id;

           insert into paging_columns_prop(paging_table_id,pg_type_item_id,name,priority)
             select val_object_table_id,col_type_id,col,pr
             from temp_paging_col_prop
             ON CONFLICT (paging_table_id,name) DO NOTHING;


          delete  from paging_columns_prop
            where paging_table_id = val_object_table_id
              and name not in (select col from temp_paging_col_prop);

            update paging_table
              set m_prop_column_full = full_data,
                  m_prop_column_small = small_data,
                  m_column = cols
            from (SELECT jsonb_build_object('columns',
                          jsonb_agg(jsonb_build_object(
                                                 'data',p.name,
                                                 'visible',  coalesce(p.is_visible,false),
                                                 'primary',  coalesce(is_primary,false),
                                                 'title',    coalesce(p.title,p.name),
                                                 'orderable',Coalesce(p.is_orderable,true),
                                                 'is_filter',p.is_filter,
                                                 'type', pt.name,
                                                 'cd',coalesce(p.condition,pt.cond_default),
                                                 'cdi', p.item_condition) ORDER by p.priority)) as full_data,
              jsonb_build_object('columns',
                          jsonb_agg(jsonb_build_object(
                                                 'data',p.name ,
                                                 'visible',coalesce(p.is_visible,false),
                                                 'primary',coalesce(is_primary,false),
                                                 'orderable',Coalesce(p.is_orderable,true),
                                                 'title',  coalesce(p.title,p.name),
                                                 'type', pt.name) ORDER by priority)) as small_data,
              string_agg(p.name,',' ORDER BY priority) FILTER (WHERE p.is_visible is true or p.is_primary is true) as cols,
                p.paging_table_id
            from paging_columns_prop as p
            join pg_type_item as pt on p.pg_type_item_id = pt.id
              where p.paging_table_id = (select id from paging_table where name =a_vw_view)
            GROUP BY  p.paging_table_id ) as rs
              where rs.paging_table_id = paging_table.id;
    RETURN '';
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE or replace VIEW vw_paging_columns_prop AS
SELECT  pcp.id,
        pt.name as view_name,
        pcp.name as name,
        pcp.title,
        pcp.condition,
        pcp.item_condition,
        pcp.is_visible,
        pcp.is_primary,
        pcp.is_filter,
        pcp.is_orderable,
        pcp.init_obj_id,
        pcp.update_time,
        pcp.create_time,
        pcp.priority,
        pcp.paging_table_id
   FROM paging_columns_prop as pcp
   join paging_table as pt on pcp.paging_table_id = pt.id
   left join paging_table_type as ptt on ptt.id = pt.paging_table_type_id;

create or replace function paging_create_field(a_object text) returns text
IMMUTABLE
LANGUAGE SQL
AS $$
SELECT m_column
from paging_table where name = $1
$$;

/*select rebuild_paging_prop(p.name,p.descr,pt.name,p.is_materialyze)
from paging_table as p
join paging_table_type as pt on pt.id = p.paging_table_type_id;
*/

/*
select rebuild_paging_prop('vw_application_monitor',null,'main',false);
select rebuild_paging_prop('vw_collection',null,'main',false);
select rebuild_paging_prop('vw_bki_contact',null,'main',false);
select rebuild_paging_prop('vw_application_state_change',null,'main',false);*/

create or replace  function paging_dbnamespace_column_prop(a_dbobject text) returns jsonb
IMMUTABLE
LANGUAGE SQL
AS $$
      select m_prop_column_full
      from paging_table
      where name = $1
$$;

create or replace function paging_dbnamespace_column_prop_save(jsonb, text) returns void
LANGUAGE plpgsql
AS $$
DECLARE
    val_result integer;
    val_table_id integer = (select id from paging_table where name = $2);
BEGIN
        with cte AS
          (
              select *
              from jsonb_each_text($1)
          ), update_if_exists as
          (
            update paging_columns_prop
          set is_visible = cte.value::boolean
            from cte
          where paging_columns_prop.name = cte.key
          and paging_columns_prop.paging_table_id = val_table_id
          RETURNING id

          ),insert_if_not_exists as
          (
          insert into paging_columns_prop(paging_obj, name,is_visible)
              select $2,cte.key,cte.value::boolean
              from cte
              where not exists (select 1 from update_if_exists limit 1)
            RETURNING  id
          )
            select * from update_if_exists
          UNION ALL
            select * from insert_if_not_exists
            into val_result;
END;
$$;

CREATE OR REPLACE FUNCTION public.paging_columns_prop_before_update_paging_table_mat_trg()
  RETURNS trigger LANGUAGE plpgsql AS
$$
BEGIN
     update paging_table
              set m_prop_column_full = full_data,
                  m_prop_column_small = small_data,
                  m_columns = cols
            from (SELECT jsonb_build_object('columns',
                          jsonb_agg(jsonb_build_object(
                                                 'data',p.name,
                                                 'visible',  coalesce(p.is_visible,false),
                                                 'primary',  coalesce(is_primary,false),
                                                 'title',    coalesce(p.title,p.name),
                                                 'orderable',Coalesce(p.is_orderable,true),
                                                 'is_filter',Coalesce(p.is_filter,true),
                                                 'type', pt.name,
                                                 'cd',coalesce(p.condition,cond_default),
                                                 'cdi', p.item_condition) ORDER by p.priority)) as full_data,
              jsonb_build_object('columns',
                          jsonb_agg(jsonb_build_object(
                                                 'data',p.name ,
                                                 'visible',coalesce(p.is_visible,false),
                                                 'primary',coalesce(is_primary,false),
                                                 'orderable',Coalesce(p.is_orderable,true),
                                                 'title',  coalesce(p.title,p.name),
                                                 'type', pt.name) ORDER by priority)) as small_data,
              string_agg(p.name,',' ORDER BY priority) FILTER (WHERE p.is_visible is true or p.is_primary is true) as cols,
                p.paging_table_id
            from paging_columns_prop as p
            join pg_type_item as pt on p.pg_type_item_id = pt.id
              where p.paging_table_id =new.paging_table_id
            GROUP BY  p.paging_table_id ) as rs
              where id = new.paging_table_id;
RETURN NEW;
END;
$$;

CREATE TRIGGER paging_columns_prop_before_update_paging_table_mat_trg
  after UPDATE
  ON public.paging_columns_prop
  FOR EACH ROW
  EXECUTE PROCEDURE public.paging_columns_prop_before_update_paging_table_mat_trg();

create or replace function paging_counter_up (text) returns void
VOLATILE
LANGUAGE SQL
AS
$$
        update paging_table
        set m_count = coalesce(m_count,0) + 1
        where name  = $1
$$;

create or replace function paging_objectdb(a_js jsonb, a_ext text, a_debug integer) returns SETOF text
LANGUAGE plpgsql
AS $$
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

    SELECT m_column,m_count,case when val_draw = 1 then m_prop_column_full  else '{}'end
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

  val_query = val_query || jsonb_build_object('recordsTotal', jsonb_build_object
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
$$;

create or REPLACE function get_set_paging_table_object(a_name text, a_descr text,a_type text,a_is_mat boolean) returns integer
VOLATILE
LANGUAGE plpgsql
AS $$
declare
  val_id integer = (select id from paging_table where name = $1);
  val_type_id integer = (select id from paging_table_type where name = $3);
BEGIN
      if (val_id is null)
        then
              insert into paging_table(name, descr,paging_table_type_id,is_materialyze)
                select $1,$2,Coalesce(val_type_id,1),coalesce(a_is_mat,false)
              RETURNING id
              into val_id;
        END IF;
      RETURN val_id;
END;
$$;

create or replace function paging_dbnamespace_column_prop_ext(a_dbobject text) returns jsonb
IMMUTABLE
LANGUAGE SQL
AS $$
      select m_prop_column_full
      from paging_table
      where name = a_dbobject
$$;

create or replace function paging_dbnamespace_column_prop_ext(a_dbobject text, a_full boolean) returns jsonb
IMMUTABLE
LANGUAGE SQL
AS $$
select m_prop_column_full
      from paging_table
      where a_full is true and name = a_dbobject
      UNION ALL
      select m_prop_column_small
      from paging_table
      where a_full is not true and name = a_dbobject
$$;

create or replace function materialize_worker(a_mode text, a_object text) returns jsonb
LANGUAGE plpgsql
AS $$
DECLARE
  val_m_count integer;
  val_m_time TIMESTAMP;
  val_exec_time NUMERIC;
  val_count_object integer;
  val_time_exec TIMESTAMP = clock_timestamp();
  val_mat_view text = replace(a_object,'vw_','mv_');
  val_chart_query text = '';
  val_result json;
BEGIN

  if exists (select * from paging_table
  where is_materialyze is not true and name = a_object
        and a_object != 'report_client_dimension')
  THEN
    return null::jsonb;
  END IF;
  if (a_mode = 'recreate')
  THEN
    if (a_object = 'report_client_dimension')
    then
      perform marketing_materialyze_data();

      select count(*) from report_client_dimension
      into val_count_object;

    elseif(a_object = 'vw_rep_analytic_portfolio')
      then
        perform portfolio_materialyze_data(null,now()::Date,now()::Date + 1);

        execute 'drop MATERIALIZED view if exists '|| val_mat_view ;

        execute 'create MATERIALIZED view if not exists '|| val_mat_view  ||' as
                (
                  SELECT *
                  FROM '|| a_object  ||') with NO DATA ;';

        execute 'REFRESH MATERIALIZED VIEW  ' || val_mat_view;

        select m_query from paging_table where name = a_object
        into val_chart_query;

        if (val_chart_query is not null)
        then
          EXECUTE val_chart_query
          into val_result;
        END IF ;

        execute 'select count(*) from ' || val_mat_view
        into val_count_object;

    else

      execute 'create MATERIALIZED view if not exists '|| val_mat_view  ||' as
                (
                  SELECT *
                  FROM '|| a_object  ||') with NO DATA ;';

      execute 'REFRESH MATERIALIZED VIEW  ' || val_mat_view;

      select m_query from paging_table where name = a_object
      into val_chart_query;

      if (val_chart_query is not null)
      then
        EXECUTE val_chart_query
        into val_result;
      END IF ;

      execute 'select count(*) from ' || val_mat_view
      into val_count_object;
    END if;
    with update_data as
    (
      update paging_table
      set m_count = val_count_object,
        m_time = now(),
        m_exec_time =date_part('epoch'::text, clock_timestamp() - val_time_exec) / 60::double precision,
        m_chart_json_data = val_result
      where name = a_object
      RETURNING m_count,m_time,m_exec_time,m_chart_json_data
    ), insert_data as
    (
      insert into paging_table(paging_table_type_id,m_count,m_time,name,m_exec_time,m_chart_json_data)
        select 1,u.m_count,now(),a_object,date_part('epoch'::text, clock_timestamp() - val_time_exec) / 60::double precision,val_result
        from update_data as u
        where not exists(select * from update_data)
      RETURNING m_count,m_time,m_exec_time,m_chart_json_data
    )
    select * from update_data
    UNION ALL
    select * from insert_data
    into val_m_count,val_m_time,val_exec_time,val_result;

  else
    select m_count,m_time,m_exec_time,m_chart_json_data
    from paging_table
    where name = a_object
    into val_m_count,val_m_time,val_exec_time,val_result;
  END IF;

  RETURN  json_build_object('m_time',val_m_time,'m_exec_time',val_exec_time,'m_count',val_m_count,'m_view',a_object,'chart_data',val_result);
END
$$;

CREATE OR REPLACE FUNCTION public.paging_columns_prop_before_update_paging_table_mat_trg()
  RETURNS trigger LANGUAGE plpgsql AS
$$
BEGIN
     update paging_table
              set m_prop_column_full = full_data,
                  m_prop_column_small = small_data,
                  m_column = cols
            from (SELECT jsonb_build_object('columns',
                          jsonb_agg(jsonb_build_object(
                                                 'data',p.name,
                                                 'visible',  coalesce(p.is_visible,false),
                                                 'primary',  coalesce(is_primary,false),
                                                 'title',    coalesce(p.title,p.name),
                                                 'orderable',Coalesce(p.is_orderable,false),
                                                 'is_filter',Coalesce(p.is_filter,false),
                                                 'type', pt.name,
                                                 'cd',coalesce(p.condition,cond_default),
                                                 'cdi', p.item_condition) ORDER by p.priority)) as full_data,
              jsonb_build_object('columns',
                          jsonb_agg(jsonb_build_object(
                                                 'data',p.name ,
                                                 'visible',coalesce(p.is_visible,false),
                                                 'primary',coalesce(is_primary,false),
                                                 'orderable',Coalesce(p.is_orderable,false),
                                                 'title',  coalesce(p.title,p.name),
                                                 'type', pt.name) ORDER by priority)) as small_data,
              string_agg(p.name,',' ORDER BY priority) FILTER (WHERE p.is_visible is true or p.is_primary is true) as cols,
                p.paging_table_id
            from paging_columns_prop as p
            join pg_type_item as pt on p.pg_type_item_id = pt.id
              where p.paging_table_id =new.paging_table_id
            GROUP BY  p.paging_table_id ) as rs
              where id = new.paging_table_id;
RETURN NEW;
END;
$$;


create view vw_rep_omonym as 
select id,entry_name
from omonym;


create view vw_rep_multilexem as
select *
from multilexem;

select rebuild_paging_prop('vw_rep_omonym','Омонимы','public',false);
select rebuild_paging_prop('vw_rep_multilexem','Лексемы','public',false);




drop view if EXISTS vw_noun ;
create view vw_noun as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 7 ;
select rebuild_paging_prop('vw_noun','Cуществительные','public',false);

drop view if EXISTS vw_pronoun;
create view vw_pronoun as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 8;
select rebuild_paging_prop('vw_pronoun','Местоимение','public',false);

drop view if EXISTS vw_infinitive;
create view vw_infinitive as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 12;
select rebuild_paging_prop('vw_infinitive','Прилагательные','public',false);

drop view if EXISTS vw_verb;
create view vw_verb as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 13;
select rebuild_paging_prop('vw_verb','Глаголы','public',false);

drop view if EXISTS vw_participle;
create view vw_participle as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 14;
select rebuild_paging_prop('vw_participle','Деепричастие','public',false);

drop view if EXISTS vw_pretext;
create view vw_pretext as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 15;
select rebuild_paging_prop('vw_pretext','Предлог','public',false);

create view vw_impersonal_verb as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 16;
select rebuild_paging_prop('vw_impersonal_verb','Безлич. глагол','public',false);

create view vw_particle as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 19;
select rebuild_paging_prop('vw_impersonal_verb','Частица','public',false);

create view vw_conjunction as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 20;
select rebuild_paging_prop('vw_conjunction','Союз','public',false);

create view vw_adverb as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 21;
select rebuild_paging_prop('vw_adverb','Наречие','public',false);

create view vw_introductory as
select id,name,uname,freq
from sg_entry as sg
where sg.id_class = 24;
select rebuild_paging_prop('vw_introductory','Вводное','public',false);


CREATE OR REPLACE VIEW public.vw_rep_sys_size_ddl AS
  SELECT
    (a.table_name)::text AS table_name,
    (a.row_estimate)::text AS row_estimate,
    pg_size_pretty(a.total_bytes) AS total_size,
    pg_size_pretty(a.index_bytes) AS index_size,
    pg_size_pretty(a.toast_bytes) AS toast_size,
    pg_size_pretty(a.table_bytes) AS table_size
   FROM ( SELECT a_1.oid,
            a_1.table_schema,
            a_1.table_name,
            a_1.row_estimate,
            a_1.total_bytes,
            a_1.index_bytes,
            a_1.toast_bytes,
            ((a_1.total_bytes - a_1.index_bytes) - COALESCE(a_1.toast_bytes, (0)::bigint)) AS table_bytes
           FROM ( SELECT c.oid,
                    n.nspname                                           AS table_schema,
                    c.relname                                           AS table_name,
                    c.reltuples                                         AS row_estimate,
                    pg_total_relation_size((c.oid)::regclass)           AS total_bytes,
                    pg_indexes_size((c.oid)::regclass)                  AS index_bytes,
                    pg_total_relation_size((c.reltoastrelid)::regclass) AS toast_bytes
                   FROM (pg_class c
                     LEFT JOIN pg_namespace n ON ((n.oid = c.relnamespace)))
                  WHERE (c.relkind = 'r'::"char")) a_1) as a
              where table_schema = 'public' order by total_bytes desc;

select rebuild_paging_prop('vw_rep_sys_size_ddl','Размеры объектов в бд.','view',false);

EOD;
        $this->execute($query);
    }
}
