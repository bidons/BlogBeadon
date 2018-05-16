<?php

use Phinx\Migration\AbstractMigration;

class FixOlapFn extends AbstractMigration
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
CREATE OR REPLACE FUNCTION public.get_pie_chart_olap(a_agg JSON)
  RETURNS TEXT
AS
$BODY$
DECLARE
  val_timestart TIMESTAMP = clock_timestamp();
  val_value_arr TEXT      = (SELECT '(' || string_agg(quote_literal(replace(r :: TEXT, '"', '')), ',') || ')'
                             FROM jsonb_array_elements(a_agg :: JSONB -> 'value') AS r);

  val_class     TEXT = a_agg ->> 'type_id';
  val_fin       TEXT = (a_agg ->> 'agg');
  val_cond      TEXT = CASE WHEN val_fin = 'total'
    THEN ''
                       ELSE ' and ' || val_fin || '>0' END;
  val_since     DATE;
  val_till      DATE;
  val_result    JSON;

  val_query     TEXT;
BEGIN
  SELECT
    r [1] :: date,
    r [2] :: date
  FROM regexp_split_to_array(a_agg ->> 'interval', ' - ', '') AS r
  INTO val_since, val_till;

  val_fin = CASE WHEN val_fin = 'total'
    THEN 'count(*)'
            ELSE 'SUM(S.' || val_fin || ')' END;

  val_query = concat('
WITH cte AS
 (
  SELECT json_build_object(
     ''name'',coalesce(s.value,''Не определено''),
        ''y'',', val_fin,') AS jb
  FROM client_dimension AS s
  WHERE
        s.create_time >=', quote_literal(val_since :: TEXT), '
    AND s.create_time < ', quote_literal((val_till + 1) :: TEXT), '
    AND type_id = ', quote_literal(val_class),'
    AND value_id in ', val_value_arr, val_cond,'
  GROUP BY s.value
  ORDER BY s.value
 )
  SELECT json_agg(jb)
  FROM cte;');
  EXECUTE val_query
  INTO val_result;

  RETURN json_build_object('data', val_result, 'query', val_query,'time',round(
      (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4));
END
$BODY$
LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION get_geo_chart_olap(a_agg json) returns text
IMMUTABLE
LANGUAGE plpgsql
AS $$
DECLARE
  val_timestart TIMESTAMP = clock_timestamp();
  val_value_arr TEXT  = (SELECT '(' || string_agg(quote_literal(replace(r::text,'"','')),',') ||')'
                         FROM jsonb_array_elements(a_agg::jsonb -> 'value') AS r);

  val_class     TEXT = a_agg ->> 'type_id';
  val_fin       TEXT = a_agg ->> 'agg';
  val_cond      text = CASE WHEN val_fin = 'total' THEN '' ELSE ' AND ' || val_fin || '> 0' END;
  val_since     date;
  val_till      date;
  val_result    JSONB;
  val_query text;
BEGIN

   SELECT
    r [1] :: date,
    r [2] :: date
  FROM regexp_split_to_array(a_agg ->> 'interval', ' - ', '') AS r
  INTO val_since, val_till;

  val_fin = CASE WHEN val_fin  = 'total'
                 THEN 'count(*)' ELSE 'SUM(' ||  val_fin ||  ')' END;

  val_query = concat_ws(' ',
'WITH cte AS
  (
    SELECT location_id,
         Coalesce(value,''Не определено'') as value,
         value_id,
         ',val_fin,'as c
    FROM client_dimension
    WHERE value_id in ',val_value_arr,'
         AND type_id =',val_class,'
         AND location_id IS NOT NULL',val_cond,'
         AND create_time >=',quote_literal(val_since),'
         AND create_time < ',quote_literal(val_till),'
    GROUP BY location_id, value,value_id
  ), get_max_values as
  (
    SELECT array_agg(DISTINCT value) AS value
    FROM cte
  ), prepare_dim AS
  (
    SELECT g.location_id,
         unnest((SELECT value
                 FROM get_max_values)) AS v
    FROM cte AS g
    GROUP BY g.location_id
  ), get_data AS
  (
    SELECT jsonb_build_array(g.location_id::text)
            || jsonb_agg(coalesce(c.c,0) ORDER BY g.v)
            || jsonb_build_array(sum(c.c)) as r
    FROM prepare_dim AS g
    LEFT JOIN cte AS c ON g.v = c.value
                      AND c.location_id = g.location_id
    GROUP BY g.location_id
  )
    SELECT json_build_object(
                    ''data'',jsonb_agg(r),
                    ''values'',(SELECT array[''id'']
                     ||  value
                     || array[''total'',''values'']
    FROM get_max_values ORDER BY value))
    from get_data');

  EXECUTE  val_query
  INTO val_result;

  RETURN val_result || jsonb_build_object('query',val_query,'time',round(
      (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4));
END
$$;

CREATE OR REPLACE FUNCTION get_line_chart_olap(a_agg JSON)
  RETURNS TEXT
IMMUTABLE
LANGUAGE plpgsql
AS $$
DECLARE
  val_timestart TIMESTAMP = clock_timestamp();
  val_value_arr TEXT = (SELECT '(' || string_agg(quote_literal(replace(r :: TEXT, '"', '')), ',') || ')'
                        FROM jsonb_array_elements(a_agg :: JSONB -> 'value') AS r);

  val_class     TEXT = a_agg ->> 'type_id';
  val_fin       TEXT = a_agg ->> 'agg';
  val_cond      TEXT = CASE WHEN val_fin = 'total'
                            THEN ''
                       ELSE ' and ' || val_fin || '>0' END;
  val_since     DATE;
  val_till      DATE;

  val_result    JSONB;

  val_query     TEXT;
BEGIN
  SELECT
    r [1] :: DATE,
    r [2] :: DATE
  FROM regexp_split_to_array(a_agg ->> 'interval', ' - ', '') AS r
  INTO val_since, val_till;

  val_fin = CASE WHEN val_fin = 'total'
    THEN 'COUNT(*)'
            ELSE 'SUM(' || val_fin || ')' END;

  val_query = concat_ws(' ',
'WITH cte AS
 (
    SELECT
    create_time,
    coalesce(value,''Не определено'') AS value,
             ', val_fin, 'AS s
    FROM client_dimension
    WHERE value_id IN ', val_value_arr,'
        AND type_id =', val_class, val_cond,'
        AND create_time >=', quote_literal(val_since),'
        AND create_time < ', quote_literal(val_till), '
    GROUP BY create_time, value
    ORDER BY create_time, value
  ),prepare_data as
  (
    SELECT json_build_object
      (''name'',value,
       ''data'',json_agg(s ORDER BY create_time)) as rs
    FROM cte
    GROUP BY value
  )
    SELECT json_build_object(
            ''data'',json_agg(rs),
            ''values'',(SELECT array_agg(distinct create_time)
                        FROM cte))
    FROM prepare_data;');

  EXECUTE val_query
  INTO val_result;

  RETURN val_result || jsonb_build_object('query',val_query,'time',round(
      (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4));
END
$$;

update client_dimension
    set value = 'Два или более (высших)'
where value ='Две или больше высших';

update client_dimension_guide
set value ='Два или более (высших)'
where value = 'Две или больше высших';

/*drop table if exists cte;
create table cte as
  (
    SELECT
      create_time,
      value_id,
      COUNT(*)                         AS s
    FROM client_dimension
    WHERE value_id IN ('6', '4', '-1', '5', '3', '7', '2', '1')
          AND type_id = 8
          AND create_time >= '2016-05-01'
          AND create_time < '2017-04-01'
    GROUP BY create_time::date, value_id
    ORDER BY create_time::date, value_id
  );

    SELECT
      create_time,
      value_id,
      COUNT(*)                         AS s
    FROM client_dimension
    WHERE value_id IN ('6', '4', '-1', '5', '3', '7', '2', '1')
          AND type_id = 8
          AND create_time >= '2016-05-01'
          AND create_time < '2017-04-01'
    GROUP BY create_time::date, value_id
    ORDER BY create_time::date, value_id


SELECT *
FROM crosstab('select create_time,value_id,s from cte  order by 1',
              'select unnest(array[6, 4, -1, 5, 3, 7, 2, 1]) as m from cte')
  AS final_result(create_time date,
                  "a" INTEGER,
                  "b" INTEGER,
                  "3" INTEGER,
                  "4" INTEGER,
                  "5" INTEGER,
                  "6" INTEGER,
                  "7" INTEGER,
                  "8" INTEGER);*/

EOD;
$this->execute($query);
}
}
