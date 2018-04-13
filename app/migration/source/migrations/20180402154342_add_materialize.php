<?php

use Phinx\Migration\AbstractMigration;

class AddMaterialize extends AbstractMigration
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
              CREATE OR REPLACE FUNCTION date_diff (units VARCHAR(30), start_t TIME, end_t TIME) 
     RETURNS INT AS $$
   DECLARE
   diff_interval INTERVAL; 
     diff INT = 0;
   BEGIN
   -- Minus operator for TIME returns interval 'HH:MI:SS'  
     diff_interval = end_t - start_t;
 
     diff = DATE_PART('hour', diff_interval);
 
     IF units IN ('hh', 'hour') THEN
       RETURN diff;
     END IF;
 
     diff = diff * 60 + DATE_PART('minute', diff_interval);
 
     IF units IN ('mi', 'n', 'minute') THEN
        RETURN diff;
     END IF;
 
     diff = diff * 60 + DATE_PART('second', diff_interval);
 
     RETURN diff;
   END;
   $$ LANGUAGE plpgsql;
   
   

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

  if (a_mode = 'recreate')
  THEN

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


    with update_data as
    (
      update paging_table
      set m_count = val_count_object,
        m_time = now(),
        m_exec_time =0,/*datediff(clock_timestamp()::time - val_time_exec::time) / 60,*/
        m_chart_json_data = val_result
      where name = a_object
      RETURNING m_count,m_time,m_exec_time,m_chart_json_data
    ), insert_data as
    (
      insert into paging_table(paging_table_type_id,m_count,m_time,name,m_exec_time,m_chart_json_data)
        select 1,u.m_count,now(),a_object,0,/*datediff(clock_timestamp()::time - val_time_exec::time) / 60,*/
          val_result
        from update_data as u
        where not exists(select * from update_data)
      RETURNING m_count,m_time,m_exec_time,m_chart_json_data
    )
    select * from update_data
    UNION ALL
    select * from insert_data
    into val_m_count,val_m_time,val_exec_time,val_result;
  end if ;

    select m_count,m_time,m_exec_time,m_chart_json_data
    from paging_table
    where name = a_object
    into val_m_count,val_m_time,val_exec_time,val_result;

  RETURN json_build_object('m_time',val_m_time,'m_exec_time',val_exec_time,'m_count',val_m_count,'m_view',a_object,'chart_data',val_result);
END
$$;
   
drop view if exists vw_gen_materialize cascade;

create or replace view vw_gen_materialize as
with cte as
(
    SELECT
      generate_series(1, 200000) as id ,
      md5(random() :: TEXT) as md5,
      ('{Дятел,Братство,Духовность,Мебель,Любовник,Аристократ,Ковер,Портос,Трещина,Зубки,Бес,Лень,Благоговенье}' :: TEXT []) [random() * 12] AS series,
      date((current_date - '2 years' :: INTERVAL) + trunc(random() * 365) * '1 day' :: INTERVAL + trunc(random() * 1) * '1 year' :: INTERVAL) AS action_date
)
  select id,md5,series,action_date::timestamptz as action_date
  from cte
  order by action_date;

select rebuild_paging_prop('vw_gen_materialize','Материализация (сущ.)','view_materialize',true);
select materialize_worker('recreate','vw_gen_materialize');


update paging_table
    set m_query  = 'with cte as
(
    SELECT generate_series(min(action_date::timestamp), max(action_date::timestamp),''1 day'')::Date as date
    FROM mv_gen_materialize as m
),get_aggreagate as
(
    SELECT
      date_part(''epoch''::text, date_trunc(''day''::text, c.date::date))::bigint * 1000 as date,
      series,
      count(mgm.action_date) as cn
    FROM cte AS c
      LEFT JOIN mv_gen_materialize AS mgm ON mgm.action_date = c.date
    GROUP BY series, c.date
), get_data as
(
    SELECT
      g.series,
      jsonb_agg(json_build_array(date, cn)
      ORDER BY date)as rs,
      array_agg(date) as d
    FROM get_aggreagate AS g
      where series is not null
    GROUP BY g.series
),get_pie_data as
(
  select series as name,count(*) as y
  from mv_gen_materialize
  where series is not null
  GROUP BY series
)
select json_build_array(
(select json_build_object(''title'',''Генерация (сток)'',''type'',''stock'',''chart'',json_agg(json_build_object(''type'',''area'',''name'',series,''data'',rs)))
from get_data),
  json_build_object(''title'',''Генерация (пирог)'',''type'',''pie'',''chart'',(select json_agg(get_pie_data) from get_pie_data))
);'
where name = 'vw_gen_materialize';
EOD;
        $this->execute($query);
    }
}
