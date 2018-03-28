<h2 class="center-wrap">Конструкторы
    (<strong>Пагинаторы</strong>)
</h2>


<div class="row">
    <div class="col-md-4">
        <div class="text-center">.
            <img class="rounded-circle" src="/main/img/slide-2.jpg"  width="300" height="300">
        </div>
    </div>
    <div class="entry-content"></div>
    <div class="post-series-content">
       {# <p>This post is first part of a series called <strong>Getting Started with Datatable 1.10 </strong>.</p>#}
        <ol>
            <li><a class="wrapper-blog" href="/objectdb/index" title="Введение (зачем, почему, дерево проекта)" >Введение (зачем, почему, дерево проекта) </a></li>
            <li><a class="wrapper-blog" href="/objectdb/part1" title="Реляционное связывание (обвёртки-таблицы)">Общие механизмы</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part2" title="Работа с фильтрами">Фильтра, чекалки, експорт</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part3" title="Материализация (Materialize View + преагрегация конструкторов в JSON)">Материализация (Materialize View)</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part4" title="Особенности работы  (планировщика запросов) PosgreSQL" >Особенности работы (планировщика запросов) PosgreSQL</a></li>
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
                <pre><span style="color: rgb(204,120,50);">SELECT </span>pv.viewname<span
                            style="color: rgb(204,120,50);">,<br></span><span style="color: rgb(204,120,50);">       </span>isc.column_name<span
                            style="color: rgb(204,120,50);">,<br></span><span style="color: rgb(204,120,50);">       </span>t.typname<span
                            style="color: rgb(204,120,50);">,<br></span><span style="color: rgb(204,120,50);">       </span>p.attnum <span
                            style="color: rgb(204,120,50);">as </span>priority<br>  <span style="color: rgb(204,120,50);">FROM </span>pg_views <span
                            style="color: rgb(204,120,50);">AS </span>pv<br>    <span
                            style="color: rgb(204,120,50);">JOIN </span>information_schema.columns <span
                            style="color: rgb(204,120,50);">AS </span>isc <span style="color: rgb(204,120,50);">ON </span>pv.viewname = isc.table_name<br>    <span
                            style="color: rgb(204,120,50);">JOIN </span>pg_attribute <span style="color: rgb(204,120,50);">AS </span>p <span
                            style="color: rgb(204,120,50);">ON </span>p.attrelid = isc.table_name :: <span
                            style="color: rgb(255,198,109);">REGCLASS </span><span
                            style="color: rgb(204,120,50);">AND </span>isc.column_name = p.attname<br>    <span
                            style="color: rgb(204,120,50);">JOIN </span>pg_type <span
                            style="color: rgb(204,120,50);">AS </span>t <span style="color: rgb(204,120,50);">ON </span>p.atttypid = t.<span
                            style="color: rgb(255,198,109);">oid<br></span><span
                            style="color: rgb(255,198,109);">    </span><span style="color: rgb(204,120,50);">where </span>pv.schemaname = <span
                            style="color: rgb(106,135,89);">'public'</span><span
                            style="color: rgb(204,120,50);">;<br></span></pre>


                <pre><span style="color: rgb(106,135,89);">Таблицы<br></span></pre>
                <pre><span style="color: rgb(204,120,50);">SELECT </span>tablename<span
                            style="color: rgb(204,120,50);">,</span><span style="color: rgb(204,120,50);">column_name</span><span
                            style="color: rgb(204,120,50);">, </span>t.typname<span
                            style="color: rgb(204,120,50);">, </span>p.attnum <span
                            style="color: rgb(204,120,50);">as </span>priority<br>  <span style="color: rgb(204,120,50);">FROM </span>pg_tables <span
                            style="color: rgb(204,120,50);">AS </span>pv<br>    <span
                            style="color: rgb(204,120,50);">JOIN </span>information_schema.columns <span
                            style="color: rgb(204,120,50);">AS </span>isc <span style="color: rgb(204,120,50);">ON </span>pv.tablename = isc.table_name<br>    <span
                            style="color: rgb(204,120,50);">JOIN </span>pg_attribute <span style="color: rgb(204,120,50);">AS </span>p <span
                            style="color: rgb(204,120,50);">ON </span>p.attrelid = isc.table_name :: <span
                            style="color: rgb(255,198,109);">REGCLASS </span><span
                            style="color: rgb(204,120,50);">AND </span>isc.column_name = p.attname<br>    <span
                            style="color: rgb(204,120,50);">JOIN </span>pg_type <span
                            style="color: rgb(204,120,50);">AS </span>t <span style="color: rgb(204,120,50);">ON </span>p.atttypid = t.<span
                            style="color: rgb(255,198,109);">oid<br></span><span
                            style="color: rgb(255,198,109);">    </span><span style="color: rgb(204,120,50);">where </span>pv.schemaname = <span
                            style="color: rgb(106,135,89);">'public'</span><span
                            style="color: rgb(204,120,50);">;</span>
            </pre>
            </li>
            <br>

            <li>
                Имея данные мы можем реляционно создать наш объект (будт-то таблиц или обвёртка "вьюха")
                <div class="row">
                <img src = "/main/img/paging_table_1.png">
                </div>

                <div class="col-md-12 center-wrap">
                    <div style="margin-bottom:16px">
                        <span class="badge badge-secondary" id="datatable-data" data-toggle="modal"  data-target="#modalDynamicInfo"></span>
                        <span class="badge badge-secondary" id="datatable-f-ttl"data-toggle="modal"  data-target="#modalDynamicInfo"></span>
                        <span class="badge badge-secondary" id="datatable-ttl"data-toggle="modal"  data-target="#modalDynamicInfo"></span>
                        <span class="badge badge-secondary" id="select2-query"data-toggle="modal"  data-target="#modalDynamicInfo"></span>
                        <span class="badge badge-secondary" id="response-json"data-toggle="modal"  data-target="#modalDynamicInfo">Response:1</span>
                        <span class="badge badge-secondary" id="request-json"data-toggle="modal"  data-target="#modalDynamicInfo">Request:1</span>
                    </div>
                    <label class="radio-inline"><input type="radio" view-name ="paging_table" checked name="paging-table-first">paging_table</label>
                    <label class="radio-inline"><input type="radio" view-name ="paging_column_type" name="paging-table-first">paging_column_type</label>
                    <label class="radio-inline"><input type="radio" view-name ="paging_column" name="paging-table-first">paging_column</label>

                    <div class="data-tbl"> </div>
                </div>
            </li>



            <p>
                При создании вьюхи синтаксический анализатор поможет с семантикой и верностью запроса. На сервер
                не нужно пересылать здоровенный запрос, мы не привязаны к фреймворку и их особенностям
                (не нужно получать схему таблиц, нет дополнительных итераций).
                Вьюха это просто обвёртка (корявый запрос долго работает, хороший быстро).
            </p>

            Имея реляционно все типы, и сам конструктор, мы можем с удобством управлять как конструкцией запроса, так и поведением полей:
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
                Управление количеством (использование счётчиков при долгих операций seq-scan при подсчёте строк на большом моножестве)
            </li>
            <li>
                Любой запрос может быть переписан и SQL среде и полноценно протестирован
            </li>
            <li>
                Вьюха может быть материализована и проиндексирована
            </li>
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

    function RebuildReport(node){
        $('#select2-query').text('');
        var gridParams = {
            urlDataTable:  '/objectdb/showdata',
            checkedUrl:    '/objectdb/idsdata',
            urlSelect2:    '/objectdb/txtsrch',
            idName: 'id',
            columns: node.col,
            is_mat: false,
            lengthMenu: [[5,10],[5,10]],
            displayLength: 5,
            select2Input: true,
            tableDefault: node.view_name,
            checkboxes: false,
            dtFilters: false,
            dtTheadButtons: false};

        wrapper = $('.data-tbl').DataTableWrapperExt(gridParams);
    }
</script>