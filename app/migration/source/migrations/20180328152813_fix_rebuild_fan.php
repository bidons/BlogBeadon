<?php

use Phinx\Migration\AbstractMigration;

class FixRebuildFan extends AbstractMigration
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
alter table paging_column RENAME COLUMN pg_type_item_id to paging_column_type_id;
/*alter table paging_column ALTER COLUMN paging_column_type_id set not null;*/
insert into paging_table_type(id,name, descr)
select 5,'table','Таблицы';

CREATE OR REPLACE FUNCTION public.paging_columns_prop_before_update_paging_table_mat_trg()
  RETURNS trigger
AS
$BODY$
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
            from paging_column as p
            left join paging_column_type as pt on p.paging_column_type_id = pt.id
            where p.paging_table_id =new.paging_table_id
                    /*or (p.is_visible and p.is_primary is not false) or (p.is_visible is false and p.is_primary)*/
            GROUP BY  p.paging_table_id ) as rs
              where id = new.paging_table_id;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION public.rebuild_paging_prop(a_vw_view text, a_descr text, a_type_name text, a_is_mat bool)
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
            left join paging_column_type as pgi on pgi.name = t.typname
        WHERE schemaname = 'public' and pv.viewname = a_vw_view
       union all
       SELECT pv.tablename as tablename, isc.column_name as col, t.typname AS col_type,pgi.id as col_type_id,p.attnum as pr
          FROM pg_tables AS pv
        JOIN information_schema.columns AS isc ON pv.tablename = isc.table_name
       JOIN pg_attribute AS p ON p.attrelid = isc.table_name :: REGCLASS AND isc.column_name = p.attname
       JOIN pg_type AS t ON p.atttypid = t.oid
       left join paging_column_type as pgi on pgi.name = t.typname
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
            update  paging_column
                set paging_column_type_id = r.col_type_id,priority = coalesce(priority,r.pr)
            from (select pcp.id,t.col_type_id,t.pr
                    from temp_paging_col_prop  as t
                    join paging_column   as pcp on pcp.name = t.col
                    where pcp.paging_table_id = val_object_table_id
                 ) as r
            where r.id = paging_column.id;

           insert into paging_column(paging_table_id,paging_column_type_id,name,priority)
             select val_object_table_id,col_type_id,col,pr
             from temp_paging_col_prop
             ON CONFLICT (paging_table_id,name) DO NOTHING;


          delete  from paging_column
            where paging_column_type_id = val_object_table_id
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
            from paging_column as p
            left join paging_column_type as pt on p.paging_column_type_id = pt.id
              where p.paging_table_id = (select id from paging_table where name =a_vw_view)
            GROUP BY  p.paging_table_id ) as rs
              where rs.paging_table_id = paging_table.id;
    RETURN '';
END;
$BODY$
LANGUAGE plpgsql VOLATILE;



CREATE OR REPLACE FUNCTION paging_table_id(text)
  RETURNS integer
AS
$BODY$
  select id
  from paging_table
  where name = $1
$BODY$
LANGUAGE sql STABLE;

select rebuild_paging_prop('paging_column_type','paging_table_type','table',false);
select rebuild_paging_prop('paging_column','paging_column','table',false);
select rebuild_paging_prop('paging_table','paging_table','table',false);

update paging_column
set is_visible = false, is_filter = false
where paging_table_id in
      (select paging_table_id
from paging_column
where paging_table_id in (paging_table_id('paging_table'),paging_table_id('paging_column_type'),paging_table_id('paging_column')));

update paging_column
set is_visible = true
where paging_table_id in
      (select paging_table_id
from paging_column
where paging_table_id in (paging_table_id('paging_table'),paging_table_id('paging_column_type'),paging_table_id('paging_column')))
and paging_column.name in ('id','name','descr','paging_table_id','paging_column_type_id','title','is_visible','is_orderable','is_primary');

EOD;
        $this->execute($query);
    }
}
