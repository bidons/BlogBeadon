<?php

use Phinx\Migration\AbstractMigration;

class NewMigration extends AbstractMigration
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
            from paging_columns_prop as p
            join pg_type_item as pt on p.pg_type_item_id = pt.id
            where p.paging_table_id =new.paging_table_id
                    or (p.is_visible and p.is_primary is not false)
                    or (p.is_visible is false and p.is_primary)
            GROUP BY  p.paging_table_id ) as rs
              where id = new.paging_table_id;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
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
        ), get_all as
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
                    where p.paging_table_id =(select id from paging_table where name =a_vw_view)
                            or (p.is_visible and p.is_primary is not false)
                            or (p.is_visible is false and p.is_primary)
                    GROUP BY  p.paging_table_id ) as rs
                      where id = a_vw_view;

    RETURN '';
END;
$BODY$
LANGUAGE plpgsql VOLATILE;*/

create index sg_entry_id_class_idx on sg_entry(id_class);
create index sg_class_id on sg_class(id);


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
        if(col_type ~ 'text|varchar')
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

update paging_table_type
    set descr = 'Части речи',name = 'part_of_speech'
where name = 'public';


CREATE OR REPLACE FUNCTION public.get_paging_table_total_count()
  RETURNS VOID
AS
$BODY$
DECLARE
  row record ;
  val_count integer;
BEGIN
    for row in (select * from paging_table)
    LOOP
          EXECUTE  concat_ws(' ','select count(*)','from', row.name)
          into val_count;

      update paging_table
        set m_count = val_count
      where id = row.id;
    END LOOP;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
select get_paging_table_total_count();

update paging_table_type
    set descr = 'Части речи',name = 'part_of_speech'
where name = 'public';


drop table if exists  sg_generate_grek;
create table sg_generate_grek
  (
      id integer,
      gen_text text
  );
  
  
CREATE OR REPLACE FUNCTION public.random_int_btw(integer,integer)
  RETURNS text
AS
$$
        select s.name
        from sg_entry as s
        where s.id_class = $2
         OFFSET (random()* ($1)) limit 1
$$
LANGUAGE sql STABLE ;
  

/*
1. МЕСТОИМЕНИЕ ГЛАГОЛ СОЮЗ ВОСКЛ_ГЛАГОЛ ЧИСЛИТЕЛЬНОЕ СУЩЕСТВИТЕЛЬНОЕ (9,13,20,17,11,7)
2. МЕСТОИМ_СУЩ ПРИЛАГАТЕЛЬНОЕ СУЩЕСТВИТЕЛЬНОЕ СОЮЗ ГЛАГОЛ ГЛАГОЛ (8,10,7,20,13,13)
3. ДЕЕПРИЧАСТИЕ ПРЕДЛОГ ГЛАГОЛ ЧИСЛИТЕЛЬНОЕ ПРИЛАГАТЕЛЬНОЕ СУЩЕСТВИТЕЛЬНОЕ (14,15,13,11,10,7)
4. ИНФИНИТИВ ПРИЛАГАТЕЛЬНОЕ СУЩЕСТВИТЕЛЬНОЕ ГЛАГОЛ МЕСТОИМЕНИЕ СУЩЕСТВИТЕЛЬНОЕ (12,10,7,13,9,7)
5. ВОСКЛ_ГЛАГОЛ! МЕСТОИМЕНИЕ СОЮЗ ДЕЕПРИЧАСТИЕ ПРИЛАГАТЕЛЬНОЕ СУЩЕСТВИТЕЛЬНОЕ глагол (16,9,20,14,10,7)-- глагол убрал

1. глагол прилагательное существительное союз инфинитив существительное (13,10,7,20,12,7)
2. прилагательное существительное деепричатие глагол предлог существительное (10,7,14,13,15,7)
3. предлог существительное союз предлог существительное глагол (15,7,20,15,7,13)     
4. воскл.глагол числительное местоимение глагол прилагательное существительное (17,11,9,13,10,7)
5. модальное модальное местоимение глагол глагол (23,23,9,13,13) --- ещё один
6. предлог прилагательное безлич.глагол предлог существительное (15,10, 16,15,7) -- еще один*/

EOD;
        $this->execute($query);
    }
}
