<?php

use Phinx\Migration\AbstractMigration;

class AddViewsSys extends AbstractMigration
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

create extension pg_buffercache;

CREATE OR REPLACE VIEW public.vw_rep_sys_size_db_cluster AS  SELECT (d.datname)::text AS name,
    pg_get_userbyid(d.datdba) AS owner,
        CASE
            WHEN has_database_privilege((d.datname)::text, 'CONNECT'::text) THEN pg_size_pretty(pg_database_size(d.datname))
            ELSE 'No Access'::text
        END AS size
   FROM pg_database d
  ORDER BY
        CASE
            WHEN has_database_privilege((d.datname)::text, 'CONNECT'::text) THEN pg_database_size(d.datname)
            ELSE NULL::bigint
        END DESC;

drop view if exists vw_rep_sys_size_ddl;
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

CREATE OR REPLACE VIEW public.vw_rep_sys_size_table AS  SELECT (((n.nspname)::text || '.'::text) || (c.relname)::text) AS relation,
    pg_size_pretty(pg_relation_size((c.oid)::regclass)) AS size
   FROM (pg_class c
     LEFT JOIN pg_namespace n ON ((n.oid = c.relnamespace)))
  WHERE (n.nspname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name]))
  ORDER BY (pg_relation_size((c.oid)::regclass)) DESC;

select rebuild_paging_prop('vw_rep_sys_size_table','Размеры таблиц в бд.','view',false);




drop view if EXISTS vw_rep_sys_sizedb;
CREATE OR REPLACE VIEW public.vw_rep_sys_sizedb AS  SELECT row_number() OVER () AS id,
    (c.relname)::text AS relname,
    ((pg_size_pretty(pg_relation_size((c.oid)::regclass)) || ' / '::text) || (COALESCE(bf.percent_of_relation, (0)::numeric))::text) AS size_buffersize,
    (bf.buffers_percent)::text AS buffers_percent,
    concat_ws('|'::text, ('S:'::text || (p.idx_scan)::text), ('R:'::text || (p.idx_tup_read)::text), ('F:'::text || (p.idx_tup_fetch)::text)) AS scan_read_fetch,
    (d.n_tup_ins)::text AS n_tup_ins,
    (d.n_tup_upd)::text AS n_tup_upd,
    (d.n_tup_del)::text AS n_tup_del
   FROM ((((pg_class c
     LEFT JOIN pg_namespace n ON ((n.oid = c.relnamespace)))
     LEFT JOIN pg_stat_all_tables d ON ((d.relname = c.relname)))
     LEFT JOIN pg_stat_all_indexes p ON ((btrim((p.indexrelname)::text) = btrim((c.relname)::text))))
     LEFT JOIN ( SELECT c_1.relname,
            pg_size_pretty((count(*) * 8192)) AS buffered,
            round(((100.0 * (count(*))::numeric) / ((( SELECT pg_settings.setting
                   FROM pg_settings
                  WHERE (pg_settings.name = 'shared_buffers'::text)))::integer)::numeric), 1) AS buffers_percent,
            round((((100.0 * (count(*))::numeric) * (8192)::numeric) / (pg_table_size((c_1.oid)::regclass))::numeric), 1) AS percent_of_relation
           FROM ((pg_class c_1
             LEFT JOIN pg_buffercache b ON ((b.relfilenode = c_1.relfilenode)))
             JOIN pg_database d_1 ON (((b.reldatabase = d_1.oid) AND (d_1.datname = current_database()))))
          GROUP BY c_1.oid, c_1.relname
          ORDER BY (round(((100.0 * (count(*))::numeric) / ((( SELECT pg_settings.setting
                   FROM pg_settings
                  WHERE (pg_settings.name = 'shared_buffers'::text)))::integer)::numeric), 1)) DESC) bf ON ((bf.relname = c.relname)))
  WHERE ((n.nspname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name])) AND (c.relname !~~ 'pg_toast%'::text))
  ORDER BY (pg_relation_size((c.oid)::regclass)) DESC;

select rebuild_paging_prop('vw_rep_sys_sizedb','Буфер/Индексы.','view',false);



CREATE OR REPLACE VIEW public.vw_pg_stat_activity AS  
    SELECT 
     pid,
    (justify_interval((now() - pg_stat_activity.query_start)))::text AS live_status,
    state,
    query,
    usename AS usename,
    query_start 
   FROM pg_stat_activity
  ORDER BY pg_stat_activity.query_start,(pg_stat_activity.state = 'active'::text) DESC;

select rebuild_paging_prop('vw_pg_stat_activity','Активность запросов','view',false);


CREATE OR REPLACE FUNCTION public.paging_object_db_srch(jsonb)
  RETURNS jsonb
AS
$BODY$
  declare
  srch text = $1 ->>'term';
  objdb text = $1 ->> 'objdb';
  col text = $1 ->> 'col';
  colselect text = Coalesce($1->> 'colselect',col);
  ident text = $1 ->> 'ident';
  rs jsonb;
  searchingField text = ' lower(' ||  col || ')';
begin
      if (searchingField in ('client_full_name','inn','m_telephone','m_email','email','get_app_client_full_name','composit_search'))
        then
            searchingField = ' '|| col ||' ';
       end if;

    if(ident is not null)
      then
          execute  concat('select jsonb_agg(jsonb_build_object(',quote_literal('id'),',',ident,',',quote_literal('text'),',',colselect,'))'
              ,' from (select ',ident,',',colselect,' from ',objdb,' where ',searchingField,
                         'like ',quote_literal('%' || lower(srch) || '%'),' order by ',ident,' desc', ' limit 10) as r;')
          into rs;
      else
      execute concat_ws(' ' ,'select jsonb_agg('|| col || ') from (select',col,'from',objdb,'where ',searchingField,
                        'like',quote_literal('%' || lower(srch) || '%'),'limit 10) as r;')
        into rs;
    end if;
      return rs;
end;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

drop FUNCTION if exists paging_object_db_srch(jsonb);

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


      return json_build_object('rs',rs,'query',val_query);
end;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

update paging_columns_prop 
set condition = json_build_array('select2dynamic');

EOD;
        $this->execute($query);
    }
}
