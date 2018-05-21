{{ assets.outputCss('blog-dt-css') }}
{{ assets.outputJs('blog-dt-js') }}
<script type="text/javascript" src="https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js?lang=sql"></script>
{{ partial('layouts/objdb') }}

<div class="container">
<div class="well">
    <ul>
        <li>
            <p>
                Все объекты, будучи созданы в PostgreSQL существуют в общем пространстве имён, ниже два примера где обитают эти объекты (таблицы, и вьюхи),
                єти связи и будем исползовать для создания обвьёрток
                (тип, имя и принадлежность сущности, и порядок отображения).
            </p>
                  <pre class="prettyprint lang-sql">
    <span>Вьюхи</span>
    SELECT pv.viewname,     -- имя вьюхи
           isc.column_name, -- имя поля
           t.typname,       -- тип поля
           p.attnum,        -- порядок
    FROM pg_views AS pv
    JOIN information_schema.columns AS isc ON pv.viewname = isc.table_name
    JOIN pg_attribute AS p ON p.attrelid = isc.table_name :: REGCLASS AND isc.column_name = p.attname
    JOIN pg_type AS t ON p.atttypid = t.oid
    WHERE pv.schemaname = 'public';
                  </pre>

            <br>
                <pre class="prettyprint lang-sql">
    <span>Таблицы</span>
    SELECT pv.tablename,   -- имя таблицы
           isc.column_name, -- имя поля
           t.typname,   -- тип поля
           p.attnum     -- порядок
    FROM pg_tables AS pv
    JOIN information_schema.columns AS isc ON pv.tablename = isc.table_name
    JOIN pg_attribute AS p ON p.attrelid = isc.table_name :: REGCLASS AND isc.column_name = p.attname
    JOIN pg_type AS t ON p.atttypid = t.oid
    WHERE pv.schemaname = 'public';</pre>
            <br>
        <li>
            Простенькая табличка для примера
            <div class="row">
                <img src="/main/img/paging_table_1.png">
            </div>

            <div class="col-md-12 center-wrap">
                <label class="radio-inline"><input type="radio" view-name="paging_table" checked
                                                   name="paging-table-first">paging_table</label>
                <label class="radio-inline"><input type="radio" view-name="paging_column_type"
                                                   name="paging-table-first">paging_column_type</label>
                <label class="radio-inline"><input type="radio" view-name="paging_column" name="paging-table-first">paging_column</label>

                <div class="data-tbl"></div>
            </div>
        </li>
        <li>
        Получение полей для последующего рендеринга:
        <br>
         <pre class="prettyprint lang-sql">
    SELECT json_build_object('columns',json_agg(col))
    FROM (SELECT pc.name                     AS data,
                 coalesce(pc.title, pc.name) AS title,
                 pct.name                    AS type,
                 pc.is_orderable             AS orderable,
                 pc.is_visible               AS visible,
                 pc.is_primary               AS primary
          FROM paging_column AS pc
          JOIN paging_table AS pt ON pt.id = pc.paging_table_id
          JOIN paging_column_type AS pct ON pct.id = pc.paging_column_type_id
          WHERE pt.name = 'paging_table') as col;
         </pre>
        </li>

        <li>
            Собираем запрос для рендеринга строк:
        <pre class="prettyprint lang-sql">
    SELECT
          'WITH CTE AS (' || concat_ws(' ', 'SELECT', string_agg(pc.name, ',' ORDER BY pc.priority), 'FROM', pt.name, 'limit', 10, 'OFFSET', 0) || ') SELECT json_agg(cte) FROM cte;' as l_query,
                  concat_ws(' ','SELECT','count(*)',' FROM', pt.name) as ttl_query
    FROM paging_column AS pc
    JOIN paging_table AS pt ON pt.id = pc.paging_table_id
    JOIN paging_column_type AS pct ON pct.id = pc.paging_column_type_id
    WHERE pt.name = 'paging_table'
    GROUP BY pt.name;
        </pre>
        </li>
        <li>
            На выходе имеем два запроса, этого достаточно чтоб отрендерить данные, управлять порядком, видимостью, переводом-названиями полей.
        </li>

        <pre class="prettyprint lang-sql">
    WITH CTE AS (
            SELECT id, name, descr
            FROM paging_table
            LIMIT 10 OFFSET 0
            )
            SELECT json_agg(cte)
            FROM cte;

    SELCT count(*)
    FROM paging_table;
        </pre>
    </ul>
</div>
</div>
<script>

    $('[name=paging-table-first]').click(function () {
        RebuildReport(getPagingViewObject($(this).attr('view-name')))
    });

    RebuildReport(getPagingViewObject('paging_table'))

    function RebuildReport(node){
        var parmsTableWrapper = {
            externalOpt: {
                urlDataTable: '/objectdb/showdata',
                urlColumnData:'/objectdb/showcol',
                checkedUrl: '/objectdb/idsdata',
                urlSelect2: '/objectdb/txtsrch',
                select2Input: true,
                tableDefault: node.view_name,
                checkboxes: false,
                dtFilters: true,
                dtTheadButtons: false,
                idName: 'id',
                columns: node.col
            },
            dataTableOpt:
                {
                    pagingType: 'simple_numbers',
                    lengthMenu: [[5,10],[5,10]],
                    displayLength: 5,
                    serverSide:true,
                    processing: true,
                    searching: false,
                    bFilter : false,
                    bLengthChange: false,
                    pageLength: 5,
                    dom: '<"top"flp>rt<"bottom"i><"clear"><"bottom"p>',
                },
        };
        wrapper = $('.data-tbl').DataTableWrapperExt(parmsTableWrapper);
    };
</script>