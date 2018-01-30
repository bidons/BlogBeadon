
CREATE OR REPLACE FUNCTION public.paging_objectdb_part_2(a_js JSONB)
  RETURNS SETOF JSONB AS
$BODY$
DECLARE
  val_draw    TEXT = $1 ->> 'draw'; -- Draw counter
  val_table   TEXT = $1 ->> 'objdb'; -- DB obj name
  val_offlim  TEXT = concat_ws(' ',
                               'limit ', $1 ->> 'length',
                               'offset', $1 ->> 'start'); -- Limit Offset ;

  val_order   JSONB = jsonb_array_elements($1 -> 'order'); -- Get order params from json

  val_orderby TEXT = concat_ws(' ',
                               'order by', ((val_order ->> 'column') :: INTEGER + 1) :: TEXT,
                               val_order ->> 'dir'); -- Order by condition

  val_data text;
  val_filtered text;
  val_total text;
BEGIN

  -- Create query: pagination by condition
  SELECT concat_ws(' ', 'WITH objdb AS
                    (', 'SELECT * ', '
                        FROM', val_table,val_orderby, val_offlim
  , ')', 'SELECT ', 'json_agg(row_to_json(objdb))
        FROM objdb')
  INTO val_data;

  -- Query: count by condition
  SELECT concat_ws(' ', 'SELECT count(*)',
                   'FROM', val_table)
  INTO val_filtered;

  -- Query: total count
  SELECT concat_ws(' ', 'select count(*)', 'from', val_table)
  INTO val_total;


  -- Execute query
  EXECUTE val_data
  INTO val_data;

  -- Execute query
  EXECUTE val_total
  INTO val_total;

  -- Execute query
  EXECUTE val_filtered
  INTO val_filtered;

  -- Json result for datatable
  RETURN QUERY
  SELECT jsonb_build_object('draw', val_draw,
                            'recordsTotal', val_total,
                            'recordsFiltered', val_filtered,'data',coalesce(val_data, '[]') :: JSONB);
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;


drop table if exists test_p1;
CREATE TABLE test_p1 AS
  (
    SELECT
      generate_series(1, 1000000) AS id,
      md5(random() :: TEXT)      AS v1,
      md5(random() :: TEXT)      AS v2
  );


CREATE OR REPLACE FUNCTION paging_dbnamespace_column_prop(a_dbobject text)
  RETURNS jsonb
AS
$BODY$
SELECT jsonb_build_object('columns', jsonb_agg(jsonb_build_object('data', c.column_name,'title', c.column_name,'type', udt_name)))
FROM information_schema.columns c
WHERE table_name = $1
GROUP BY table_name;
$BODY$
LANGUAGE sql IMMUTABLE;


CREATE VIEW vw_pg_stat_database AS
  (
    SELECT
      datname,
      CASE
      WHEN blks_read = 0
        THEN 0
      ELSE blks_hit / blks_read
      END AS ratio
    FROM
      pg_stat_database
  );

CREATE VIEW vw_pg_stat_user_tables AS
  (
    SELECT
      relname,
      n_tup_ins,
      n_tup_upd,
      n_tup_del
    FROM
      pg_stat_user_tables
    ORDER BY
      n_tup_upd DESC
  );

CREATE VIEW vw_pg_stat_user_indexes AS
  (
    SELECT
      relname,
      seq_scan,
      idx_scan,
      CASE
      WHEN idx_scan = 0
        THEN 100
      ELSE seq_scan / idx_scan
      END AS ratio
    FROM
      vw_pg_stat_user_indexes
    ORDER BY ratio DESC
  );

CREATE VIEW vw_pg_stat_activity AS
  (
    SELECT
      datname,
      NOW() - query_start AS duration,
      procpid,
      current_query
    FROM
      pg_stat_activity
    ORDER BY duration DESC
);

CREATE VIEW vw_pg_locks AS
  (
    SELECT
      l.mode,
      d.datname,
      c.relname,
      l.granted,
      l.transactionid
    FROM
      pg_locks AS l
      LEFT JOIN pg_database AS d ON l.database = d.oid
      LEFT JOIN pg_class AS c ON l.relation = c.oid
  );

