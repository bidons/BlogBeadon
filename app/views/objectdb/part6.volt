{{ assets.outputCss('blog-css') }}
{{ assets.outputJs('blog-js') }}

<h2 class="center-wrap">Конструкторы
</h2>

<div class="container">
<div class="row">
    <div class="col-md-4">
        <div class="text-center">.
            <img class="rounded-circle" src="/main/img/operation_beadon.jpg"  width="300" height="250">
        </div>
    </div>
    <div class="entry-content"></div>
    {{ partial('layouts/objdb') }}
</div>
<hr>
    <div class="well">
        <ul>
                <p class="center-wrap">
                   Cоздадим "View" для поиска по функциям, вьюхам, и таблицам
                <p>
                <ol>
                    <li>
                        <pre class="prettyprint lang-sql">
-- Создание обвёртки
CREATE VIEW vw_ddl_search AS
SELECT
  'function' :: TEXT        AS type,
  pg_get_functiondef(p.oid) AS definition
FROM pg_proc AS p
  JOIN pg_namespace n ON (n.oid = p.pronamespace) AND (n.nspname = 'public' :: NAME)
                         AND p.proisstrict IS FALSE AND prosrc != 'aggregate_dummy'
UNION ALL
SELECT
  'view' :: TEXT                                                           AS type,
  concat_ws(' ', 'CREATE OR REPLACE VIEW', viewname || ' as ', definition) AS definition
FROM pg_views
WHERE schemaname = 'public'
UNION ALL
SELECT *
FROM
  (WITH pkey AS
  (
      SELECT
        cc.conrelid,
        format(E',
    constraint %I primary key(%s)', cc.conname,
               string_agg(a.attname, ', '
               ORDER BY array_position(cc.conkey, a.attnum))) pkey
      FROM pg_catalog.pg_constraint cc
        JOIN pg_catalog.pg_class c ON c.oid = cc.conrelid
        JOIN pg_catalog.pg_attribute a ON a.attrelid = cc.conrelid
                                          AND a.attnum = ANY (cc.conkey)
      WHERE cc.contype = 'p'
      GROUP BY cc.conrelid, cc.conname
  )
  SELECT
    'table' :: TEXT                       AS type,
    format(E'create %stable %s%I\n(\n%s%s\n);\n',
           CASE c.relpersistence
           WHEN 't'
             THEN 'temporary '
           ELSE '' END,
           CASE c.relpersistence
           WHEN 't'
             THEN ''
           ELSE n.nspname || '.' END,
           c.relname,
           string_agg(
               format(E'\t%I %s%s',
                      a.attname,
                      pg_catalog.format_type(a.atttypid, a.atttypmod),
                      CASE WHEN a.attnotnull
                        THEN ' not null'
                      ELSE '' END
               ), E',\n'
           ORDER BY a.attnum
           ),
           (SELECT pkey
            FROM pkey
            WHERE pkey.conrelid = c.oid)) AS sql
  FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    JOIN pg_catalog.pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0
    JOIN pg_catalog.pg_type t ON a.atttypid = t.oid
  WHERE nspname = 'public'
  GROUP BY c.oid, c.relname, c.relpersistence, n.nspname) AS result;

-- Создание реляционных связей
SELECT rebuild_paging_prop('vw_ddl_search','Поиск по DDL конструкциям','ddl_materialize_search',true);

-- Материализация
SELECT materialize_worker('recreate','vw_ddl_search',null);

-- Отключаем сортировку она тут бесмысленная, присваиваем полю логическое имя
update paging_column
set is_orderable = false,title = 'DDL'
where paging_table_id in
      (select id from paging_table
where name = 'vw_ddl_search')
and name = 'definition';

-- Присваиваем полю логическое имя
update paging_column
set title = 'Конструкция'
where paging_table_id in
      (select id from paging_table
where name = 'vw_ddl_search')
and name = 'definition';
        </pre>
            </li>
                </ol>
        </ul>
    </div>

    <div class="center-wrap">
        <div class="input-group-btn">
            <button class="btn btn-default" onclick="wrapper.getDataTable().ajax.reload()"> <span class="glyphicon glyphicon-filter">Поиск</span> </button>
            <button type="button" class="btn btn-default" onclick="wrapper.clearFilter()"> <span class="glyphicon glyphicon-remove-circle">Очистка</span> </button>
        </div>
    </div>

    <div class="data-tbl"></div>

</div>
<script>

    RebuildReport();
    function RebuildReport(){

        var parmsTableWrapper = {
            externalOpt: {
                urlDataTable: '/objectdb/showdata',
                urlColumnData:'/objectdb/showcol',
                checkedUrl: '/objectdb/idsdata',
                urlSelect2: '/objectdb/txtsrch',
                select2Input: true,
                tableDefault: 'vw_ddl_search',
                checkboxes: false,
                dtFilters: true,
                dtTheadButtons: true,
                idName: 'id',
                columns: {"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "type", "type": "text", "title": "Конструкция", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["~"], "cdi": null, "data": "definition", "type": "text", "title": "DDL", "primary": false, "visible": true, "is_filter": true, "orderable": false}]}
            },
            dataTableOpt: {
                pagingType: 'simple_numbers',
                lengthMenu: [[5, 10], [5, 10]],
                displayLength: 5,
                serverSide: true,
                processing: true,
                searching: false,
                bFilter: false,
                bLengthChange: false,
                pageLength: 5,
                dom: '<"top"flp>rt<"bottom"i><"clear"><"bottom"p>',
                "columnDefs": [{
                    "targets": 1,
                    "render": function (data, type, row) {
                        return '<pre class="prettyprint lang-sql">'+data+'</pre>'
                    }
                }],
            }
        }
        wrapper = $('.data-tbl').DataTableWrapperExt(parmsTableWrapper);
    }
</script>
