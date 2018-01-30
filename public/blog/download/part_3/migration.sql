CREATE OR REPLACE FUNCTION paging_dbnamespace_column_prop(a_dbobject TEXT)
  RETURNS JSONB
AS
$BODY$
SELECT jsonb_build_object('columns',
                          jsonb_agg(
                              jsonb_build_object('data', c.column_name, 'title', c.column_name, 'type', udt_name, 'cd',
                                                 to_jsonb(p.cond_def), 'cdi', to_jsonb(p.cond_item_def))  order by ordinal_position))
FROM information_schema.columns c
  LEFT JOIN pg_type_item AS p ON p.type = c.udt_name
WHERE table_name = $1
GROUP BY table_name;
$BODY$
LANGUAGE SQL IMMUTABLE;

drop table if EXISTS pg_type_item;
create table pg_type_item(id serial PRIMARY KEY, type text,cond_def text[],cond_item_def text[]);

INSERT INTO pg_type_item (type, cond_def, cond_item_def)
VALUES ('bool',ARRAY['='], NULL),
  ('char', ARRAY ['=', '~', '!='], NULL),
  ('varchar', ARRAY ['=', '~', '!='], NULL),
  ('text', ARRAY ['=', '~', '!='], NULL),
  ('int2', ARRAY ['=', '!=', '<', '>', '<=', '>='], NULL),
  ('int4', ARRAY ['=', '!=', '<', '>', '<=', '>='], NULL),
  ('int8', ARRAY ['=', '!=', '<', '>', '<=', '>='], NULL),
  ('date', NULL, NULL),
  ('time', NULL, NULL),
  ('timestamp', ARRAY ['between', 'not between'], NULL);




CREATE OR REPLACE FUNCTION public.paging_dbnamespace_cond(a_argg JSONB)
  RETURNS TEXT
AS
$BODY$
DECLARE
  val_result TEXT;
  val_dbobj  TEXT = a_argg-> 'objdb';
BEGIN

  WITH cte AS
  (
      SELECT a_argg
  ), getcolumns AS
  (
      SELECT jsonb_array_elements((SELECT *
                                   FROM cte) -> 'columns') AS r
      FROM cte

  ), normalize AS
  (
      SELECT
        r ->> 'data'              AS DATA,
        r -> 'search' ->> 'cd'    AS cd,
        r -> 'search' ->> 'value' AS VALUE,
        r -> 'search' ->> 'type'  AS TYPE
      FROM getcolumns AS t
      WHERE r -> 'search' ->> 'value' != '' and r -> 'search' ->> 'cd' != 'X'
  )
  SELECT string_agg(paging_cond_constructor(n.data,n.cd,n.value,n.type,val_dbobj),' and ')
  FROM normalize AS n
    JOIN pg_type_item AS pg ON pg.type = n.type
  INTO val_result;

  RETURN Coalesce('where true and ' || val_result,'where true');
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;


drop table if EXISTS test_p3;

create table  test_p3
(   id serial  PRIMARY KEY ,
    vl1 text ,
    create_time TIMESTAMP
);

insert into test_p3 (id,vl1, create_time)
    select generate_series(1,100000),
           md5(random()::Text), now() - interval '1 day' * (degrees(random() * 5.231)::integer);
create index test_p4_create_time_idx on test_p3(create_time);


CREATE OR REPLACE FUNCTION public.paging_cond_constructor(a_data  TEXT,
                                                          a_cond  TEXT,
                                                          a_value TEXT,
                                                          a_type TEXT,
                                                          a_objdb TEXT)
  RETURNS TEXT
AS
$BODY$
BEGIN
  IF (a_type = 'timestamp')
  THEN
    RETURN concat_ws(' ',
                     a_data,
                     a_cond,
                     quote_literal(split_part(a_value, ' - ', 1)),
                     'and',
                     quote_literal(split_part(a_value, ' - ', 2)));
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



CREATE OR REPLACE FUNCTION public.paging_objectdb_part_3(a_js jsonb)
  RETURNS SETOF jsonb
AS
$BODY$
  DECLARE
  val_draw    TEXT = $1 ->> 'draw'; -- Draw counter
  val_table   TEXT = $1 ->> 'objdb'; -- DB obj name
  val_offlim  TEXT = concat_ws(' ',
                               'limit ', $1 ->> 'length',
                               'offset', $1 ->> 'start'); -- Limit Offset ;

  val_order   JSONB = jsonb_array_elements($1 -> 'order'); -- Get order params from json

  val_condition text = paging_dbnamespace_cond($1);

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
                        FROM', val_table,val_condition,val_order,val_offlim,
  , ')', 'SELECT ', 'json_agg(row_to_json(objdb))
        FROM objdb')
  INTO val_data;

  -- Query: count by condition
  SELECT concat_ws(' ', 'SELECT count(*)',
                   'FROM', val_table,val_condition)
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






/*



CREATE OR REPLACE FUNCTION public.paging_objectdb(a_js jsonb, a_ext text, a_debug int4)
  RETURNS SETOF jsonb
AS
$BODY$
  DECLARE
   -- a_debug = 1;  then  debug query,
  --  a_debug = 0;  then  execute query and debug query,

  val_argg jsonb = $1;

  -- Draw counter
  val_draw text =  $1 ->> 'draw';

  -- Database objects name (table, view, materialize view, file_fdw, postgres_fdw, dblink)
  val_table text = $1 ->> 'objdb';

  -- Order by columns count
  val_order jsonb = jsonb_array_elements($1 -> 'order') ;

  -- Limit offset if exists
  val_offlim  text = concat_ws(' ','limit ',$1 ->> 'length','offset',$1 ->> 'start');

  -- Condition order by
  val_orderby text = concat_ws(' ','order by',((val_order  ->> 'column')::integer + 1 )::Text, val_order  ->> 'dir');

  -- Create condition json arguments (datatble objects)
  val_condition text = paging_dbnamespace_cond($1);

  val_data text;
  val_total text;
  val_filtered text;

  val_result jsonb = jsonb_build_object('debug',null);
BEGIN

  -- Create query: pagination by condition
  select concat_ws(' ','with objdb as (','select * ','from',val_table,val_condition,a_ext,val_orderby,val_offlim
  ,')','SELECT ','json_agg(row_to_json(objdb)) from objdb')
  into val_data;


  -- Create query: count by condition
  select concat_ws(' ','select count(*)','from',val_table,val_condition)
  into val_filtered;

  -- Create query: total count
  select concat_ws(' ','select count(*)','from',val_table)
  into val_total;

  -- Debug query if enable
  if (a_debug is not null)
  THEN
      val_result = jsonb_build_object('recordsTotal',val_total,'recordsFiltered',val_filtered,'data',val_data);

    if (a_debug =1)
      then
          return query select jsonb_build_object('debug',val_result);
      return;
      END IF;
  END IF;

  -- Execute query
  EXECUTE val_data
  INTO val_data;

  -- Execute query
  EXECUTE val_filtered
  INTO val_filtered;

  -- If condition not exists then total else total with condition
  IF (val_condition = '')
  THEN
    val_total = val_filtered;
  ELSE
    EXECUTE val_total
    INTO val_total;
  END IF;

  -- Json result for datatable
  RETURN QUERY
  SELECT jsonb_build_object('draw', val_draw, 'recordsTotal', val_total, 'recordsFiltered', val_filtered, 'data',
                            coalesce(val_data,'[]') :: JSONB,'debug',val_result);

END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;*/
