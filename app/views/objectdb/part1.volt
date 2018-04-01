<h2 class="center-wrap">Конструкторы
    (<strong>Пагинаторы</strong>)
</h2>


<div class="row">
    <div class="col-md-4">
        <div class="text-center">.
            <img class="rounded-circle" src="/main/img/slide-2.jpg" width="300" height="300">
        </div>
    </div>
    <div class="entry-content"></div>
    <div class="post-series-content">
        {#<p>This post is first part of a series called #}{#<strong>Getting Started with Datatable 1.10</strong>.</p>#}
        <ol>
            <li><a class="wrapper-blog" href="/objectdb/index" title="Введение (зачем, почему, дерево проекта)" >Введение (зачем, почему, дерево проекта) </a></li>
            <li><a class="wrapper-blog" href="/objectdb/part1" title="Реляционное связывание (таблиц и полей)">Реляционное связывание таблиц и колонок</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part2" title="Особенности работы  (планировщика запросов) PosgreSQL">Особенности работы  (планировщика запросов) PosgreSQL</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part3" title="Работы с фильтрами-условиями (предикативная логика)">Работы с фильтрами-условиями (предикативная логика)</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part4" title="Материализация (Materialize View)" >Материализация (Materialize View)</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part5" title="Исходники">Исходники</a></li>
        </ol>
    </div>
</div>
<hr>

<div class="well">
    <ul>
        <li>
            <p>Все объекты будучи созданы в PostgreSQL cуществуют в общем пространстве имён и реляционно
                находятся здесь (порядок, тип, имя и принадлежность к сущности).
            </p>

            <pre><span style="color: rgb(106,135,89);">Вьюхи <br></span></pre>
            <div overflow:auto;width:auto;border:solid gray;border-width:.1em .1em .1em .8em;padding:.2em .6em;
            ">
            <pre style="margin: 0; line-height: 125%"><span
                        style="color: #008800; font-weight: bold">SELECT</span> pv<span
                        style="color: #6600EE; font-weight: bold">.</span>viewname,
       isc<span style="color: #6600EE; font-weight: bold">.</span>column_name,
       t<span style="color: #6600EE; font-weight: bold">.</span>typname,
       p<span style="color: #6600EE; font-weight: bold">.</span>attnum <span style="color: #008800; font-weight: bold">as</span> priority
  <span style="color: #008800; font-weight: bold">FROM</span> pg_views <span style="color: #008800; font-weight: bold">AS</span> pv
    <span style="color: #008800; font-weight: bold">JOIN</span> information_schema<span
                        style="color: #6600EE; font-weight: bold">.</span>columns <span
                        style="color: #008800; font-weight: bold">AS</span> isc <span
                        style="color: #008800; font-weight: bold">ON</span> pv<span
                        style="color: #6600EE; font-weight: bold">.</span>viewname <span style="color: #333333">=</span> isc<span
                        style="color: #6600EE; font-weight: bold">.</span>table_name
    <span style="color: #008800; font-weight: bold">JOIN</span> pg_attribute <span
                        style="color: #008800; font-weight: bold">AS</span> p <span
                        style="color: #008800; font-weight: bold">ON</span> p<span
                        style="color: #6600EE; font-weight: bold">.</span>attrelid <span style="color: #333333">=</span> isc<span
                        style="color: #6600EE; font-weight: bold">.</span>table_name <span
                        style="color: #333333">::</span> REGCLASS <span
                        style="color: #008800; font-weight: bold">AND</span> isc<span
                        style="color: #6600EE; font-weight: bold">.</span>column_name <span
                        style="color: #333333">=</span> p<span style="color: #6600EE; font-weight: bold">.</span>attname
    <span style="color: #008800; font-weight: bold">JOIN</span> pg_type <span style="color: #008800; font-weight: bold">AS</span> t <span
                        style="color: #008800; font-weight: bold">ON</span> p<span
                        style="color: #6600EE; font-weight: bold">.</span>atttypid <span style="color: #333333">=</span> t<span
                        style="color: #6600EE; font-weight: bold">.</span>oid
    <span style="color: #008800; font-weight: bold">WHERE</span> pv<span
                        style="color: #6600EE; font-weight: bold">.</span>schemaname <span
                        style="color: #333333">=</span> <span style="background-color: #fff0f0">&#39;public&#39;</span>;
</pre>

            <br>

            <pre><span style="color: rgb(106,135,89);">Таблицы<br></span></pre>
            <pre style="margin: 0; line-height: 125%"><span style="color: #008800; font-weight: bold">SELECT</span> tablename,column_name, t<span
                        style="color: #6600EE; font-weight: bold">.</span>typname, p<span
                        style="color: #6600EE; font-weight: bold">.</span>attnum <span
                        style="color: #008800; font-weight: bold">as</span> priority
  <span style="color: #008800; font-weight: bold">FROM</span> pg_tables <span style="color: #008800; font-weight: bold">AS</span> pv
    <span style="color: #008800; font-weight: bold">JOIN</span> information_schema<span
                        style="color: #6600EE; font-weight: bold">.</span>columns <span
                        style="color: #008800; font-weight: bold">AS</span> isc <span
                        style="color: #008800; font-weight: bold">ON</span> pv<span
                        style="color: #6600EE; font-weight: bold">.</span>tablename <span
                        style="color: #333333">=</span> isc<span style="color: #6600EE; font-weight: bold">.</span>table_name
    <span style="color: #008800; font-weight: bold">JOIN</span> pg_attribute <span
                        style="color: #008800; font-weight: bold">AS</span> p <span
                        style="color: #008800; font-weight: bold">ON</span> p<span
                        style="color: #6600EE; font-weight: bold">.</span>attrelid <span style="color: #333333">=</span> isc<span
                        style="color: #6600EE; font-weight: bold">.</span>table_name <span
                        style="color: #333333">::</span> REGCLASS <span
                        style="color: #008800; font-weight: bold">AND</span> isc<span
                        style="color: #6600EE; font-weight: bold">.</span>column_name <span
                        style="color: #333333">=</span> p<span style="color: #6600EE; font-weight: bold">.</span>attname
    <span style="color: #008800; font-weight: bold">JOIN</span> pg_type <span style="color: #008800; font-weight: bold">AS</span> t <span
                        style="color: #008800; font-weight: bold">ON</span> p<span
                        style="color: #6600EE; font-weight: bold">.</span>atttypid <span style="color: #333333">=</span> t<span
                        style="color: #6600EE; font-weight: bold">.</span>oid
    <span style="color: #008800; font-weight: bold">WHERE</span> pv<span
                        style="color: #6600EE; font-weight: bold">.</span>schemaname <span
                        style="color: #333333">=</span> <span style="background-color: #fff0f0">&#39;public&#39;</span>;
</pre>

            <br>

        <li>
            Простенькая табличка для примера
            <div class="row">
                <img src="/main/img/paging_table_1.png">
            </div>

            <div class="col-md-12 center-wrap">
                <div style="margin-bottom:16px">
            <span class="badge badge-secondary" id="datatable-data" data-toggle="modal"
                  data-target="#modalDynamicInfo"></span>
                    <span class="badge badge-secondary" id="datatable-f-ttl" data-toggle="modal"
                          data-target="#modalDynamicInfo"></span>
                    <span class="badge badge-secondary" id="datatable-ttl" data-toggle="modal"
                          data-target="#modalDynamicInfo"></span>
                    <span class="badge badge-secondary" id="select2-query" data-toggle="modal"
                          data-target="#modalDynamicInfo"></span>
                    <span class="badge badge-secondary" id="response-json" data-toggle="modal"
                          data-target="#modalDynamicInfo">Response:1</span>
                    <span class="badge badge-secondary" id="request-json" data-toggle="modal"
                          data-target="#modalDynamicInfo">Request:1</span>
                </div>
                <label class="radio-inline"><input type="radio" view-name="paging_table" checked
                                                   name="paging-table-first">paging_table</label>
                <label class="radio-inline"><input type="radio" view-name="paging_column_type"
                                                   name="paging-table-first">paging_column_type</label>
                <label class="radio-inline"><input type="radio" view-name="paging_column" name="paging-table-first">paging_column</label>

                <div class="data-tbl"></div>
            </div>
        </li>
        Получение полей для последующего рендеринга:
        <br>

        <pre><span style="color: #008800; font-weight: bold">select</span> json_build_object(<span
                    style="background-color: #fff0f0">&#39;columns&#39;</span>,json_agg(col))
    <span style="color: #008800; font-weight: bold">FROM</span> (
    <span style="color: #008800; font-weight: bold">SELECT</span>
      pc<span style="color: #6600EE; font-weight: bold">.</span><span
                    style="color: #008800; font-weight: bold">name</span>                     <span
                    style="color: #008800; font-weight: bold">AS</span> <span style="color: #008800; font-weight: bold">data</span>,
      <span style="color: #008800; font-weight: bold">coalesce</span>(pc<span style="color: #6600EE; font-weight: bold">.</span>title, pc<span
                    style="color: #6600EE; font-weight: bold">.</span><span style="color: #008800; font-weight: bold">name</span>) <span
                    style="color: #008800; font-weight: bold">AS</span> title,
      pct<span style="color: #6600EE; font-weight: bold">.</span><span
                    style="color: #008800; font-weight: bold">name</span>                    <span
                    style="color: #008800; font-weight: bold">AS</span> <span style="color: #008800; font-weight: bold">type</span>,
      pc<span style="color: #6600EE; font-weight: bold">.</span>is_orderable             <span
                    style="color: #008800; font-weight: bold">AS</span> orderable,
      pc<span style="color: #6600EE; font-weight: bold">.</span>is_visible               <span
                    style="color: #008800; font-weight: bold">AS</span> visible,
      pc<span style="color: #6600EE; font-weight: bold">.</span>is_primary               <span
                    style="color: #008800; font-weight: bold">AS</span> <span style="color: #008800; font-weight: bold">primary</span>
    <span style="color: #008800; font-weight: bold">FROM</span> paging_column <span
                    style="color: #008800; font-weight: bold">AS</span> pc
      <span style="color: #008800; font-weight: bold">JOIN</span> paging_table <span
                    style="color: #008800; font-weight: bold">AS</span> pt <span
                    style="color: #008800; font-weight: bold">ON</span> pt<span
                    style="color: #6600EE; font-weight: bold">.</span>id <span style="color: #333333">=</span> pc<span
                    style="color: #6600EE; font-weight: bold">.</span>paging_table_id
      <span style="color: #008800; font-weight: bold">JOIN</span> paging_column_type <span
                    style="color: #008800; font-weight: bold">AS</span> pct <span
                    style="color: #008800; font-weight: bold">ON</span> pct<span
                    style="color: #6600EE; font-weight: bold">.</span>id <span style="color: #333333">=</span> pc<span
                    style="color: #6600EE; font-weight: bold">.</span>paging_column_type_id
      <span style="color: #008800; font-weight: bold">where</span> pt<span
                    style="color: #6600EE; font-weight: bold">.</span><span style="color: #008800; font-weight: bold">name</span> <span
                    style="color: #333333">=</span> <span
                    style="background-color: #fff0f0">&#39;paging_table&#39;</span>) <span
                    style="color: #008800; font-weight: bold">as</span> col;
</pre>
        </li>

        <li>
            Собираем запрос для рендеринга строк:
        </li>


        <pre style="margin: 0; line-height: 125%"><span style="color: #008800; font-weight: bold">SELECT</span>
     <span style="background-color: #fff0f0">&#39;WITH CTE AS (&#39;</span> <span style="color: #333333">||</span> concat_ws(<span style="background-color: #fff0f0">&#39; &#39;</span>,<span style="background-color: #fff0f0">&#39;SELECT&#39;</span>,string_agg(pc<span style="color: #6600EE; font-weight: bold">.</span><span style="color: #008800; font-weight: bold">name</span>,<span style="background-color: #fff0f0">&#39;,&#39;</span> <span style="color: #008800; font-weight: bold">ORDER</span> <span style="color: #008800; font-weight: bold">BY</span> pc<span style="color: #6600EE; font-weight: bold">.</span>priority),<span style="background-color: #fff0f0">&#39;FROM&#39;</span>, pt<span style="color: #6600EE; font-weight: bold">.</span><span style="color: #008800; font-weight: bold">name</span>, <span style="background-color: #fff0f0">&#39;limit&#39;</span>,<span style="color: #6600EE; font-weight: bold">10</span>,<span style="background-color: #fff0f0">&#39;OFFSET&#39;</span>,<span style="color: #6600EE; font-weight: bold">0</span>) <span style="color: #333333">||</span> <span style="background-color: #fff0f0">&#39;) SELECT json_agg(cte) FROM cte;&#39;</span> <span style="color: #008800; font-weight: bold">as</span> l_query,
      concat_ws(<span style="background-color: #fff0f0">&#39; &#39;</span>,<span style="background-color: #fff0f0">&#39;SELECT&#39;</span>,<span style="background-color: #fff0f0">&#39;count(*)&#39;</span>,<span style="background-color: #fff0f0">&#39; FROM&#39;</span>, pt<span style="color: #6600EE; font-weight: bold">.</span><span style="color: #008800; font-weight: bold">name</span>) <span style="color: #008800; font-weight: bold">as</span> ttl_query
    <span style="color: #008800; font-weight: bold">FROM</span> paging_column <span style="color: #008800; font-weight: bold">AS</span> pc
      <span style="color: #008800; font-weight: bold">JOIN</span> paging_table <span style="color: #008800; font-weight: bold">AS</span> pt <span style="color: #008800; font-weight: bold">ON</span> pt<span style="color: #6600EE; font-weight: bold">.</span>id <span style="color: #333333">=</span> pc<span style="color: #6600EE; font-weight: bold">.</span>paging_table_id
      <span style="color: #008800; font-weight: bold">JOIN</span> paging_column_type <span style="color: #008800; font-weight: bold">AS</span> pct <span style="color: #008800; font-weight: bold">ON</span> pct<span style="color: #6600EE; font-weight: bold">.</span>id <span style="color: #333333">=</span> pc<span style="color: #6600EE; font-weight: bold">.</span>paging_column_type_id
      <span style="color: #008800; font-weight: bold">where</span> pt<span style="color: #6600EE; font-weight: bold">.</span><span style="color: #008800; font-weight: bold">name</span> <span style="color: #333333">=</span> <span style="background-color: #fff0f0">&#39;paging_table&#39;</span>
    <span style="color: #008800; font-weight: bold">GROUP</span> <span style="color: #008800; font-weight: bold">BY</span> pt<span style="color: #6600EE; font-weight: bold">.</span><span style="color: #008800; font-weight: bold">name</span>;
        </pre>


        <li>
            На выходе имеем два запроса:
        </li>
<pre>

        <pre style="margin: 0; line-height: 125%"><span style="color: #008800; font-weight: bold">WITH</span> CTE <span style="color: #008800; font-weight: bold">AS</span> (
            <span style="color: #008800; font-weight: bold">SELECT</span> id,name,descr
            <span style="color: #008800; font-weight: bold">FROM</span> paging_table
            <span style="color: #008800; font-weight: bold">limit</span><span style="color: #6600EE; font-weight: bold"> 10</span>
            <span style="color: #008800; font-weight: bold">OFFSET</span> <span style="color: #6600EE; font-weight: bold">0</span>)
            <span style="color: #008800; font-weight: bold">SELECT </span>json_agg(cte) <span style="color: #008800; font-weight: bold">FROM</span> cte;
        </pre>
<span style="color: #008800; font-weight: bold">select</span>count(<span style="color: #333333">*</span>)<span
                   style="color: #008800; font-weight: bold"> FROM</span> paging_table;
</pre>

        <li>
            Собственно этих двух запросов достаточно чтоб отрендерить данные, управлять порядком, видимостью, переводом-названий полей.
        </li>

     {#   Имея реляционно все типы, и сам конструктор, мы можем с удобством управлять как конструкцией запроса, так и
        поведением полей:
        <br>
        <li>
            Видимость полей
        </li>
        <li>
            Переводы полей
        </li>
        <li>
            Управление фильтрами и сортировками
        </li>
        <li>
            В зависимости от прав пользователя показывать скрывать поля
        </li>
        <li>
            Управление количеством (использование счётчиков при долгих операций seq-scan при подсчёте строк на большом
            моножестве)
        </li>
        <li>
            Любой запрос может быть переписан и SQL среде и полноценно протестирован
        </li>
        <li>
            Вьюха может быть материализована и проиндексирована
        </li>#}
    </ul>
</div>
<pre>

    </pre>
<script>

    $('[name=paging-table-first]').click(function () {
        var v = $(this).attr('view-name');

        RebuildReport(getPagingViewObject(v))
    });

    RebuildReport(getPagingViewObject('paging_table'))

    function RebuildReport(node) {
        console.log(node.col);
        $('#select2-query').text('');
        var gridParams = {
            urlDataTable: '/objectdb/showdata',
            checkedUrl: '/objectdb/idsdata',
            urlSelect2: '/objectdb/txtsrch',
            idName: 'id',
            columns: JSON.parse(node.col),
            is_mat: false,
            lengthMenu: [[5, 10], [5, 10]],
            displayLength: 5,
            select2Input: true,
            tableDefault: node.view_name,
            checkboxes: false,
            dtFilters: false,
            dtTheadButtons: false
        };

        wrapper = $('.data-tbl').DataTableWrapperExt(gridParams);
    }
</script>