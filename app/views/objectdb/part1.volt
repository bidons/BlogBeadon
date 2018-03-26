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
            <li><a class="wrapper-blog" href="/objectdb/part1" title="О пагинации">О пагинации</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part2" title="Особенности при работе с лимитированным множеством " >Особенности при работе с лимитированным множеством </a></li>
            <li><a class="wrapper-blog" href="/objectdb/part3" title="Материализация (Materialize View)">Материализация (Materialize View)</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part4" title="Исходники (стурктура таблиц, механизмы качалки)" >Исходники (стурктура таблиц, механизмы качалки)</a></li>
        </ol>
    </div>
</div>
<hr>

<div class="well">
        <ul>
            <li>
                <p>Для построения пагинации и работе со множетсвом нужно учитывать три момента:
                    <br> 1) Получаение общего количества
                    <br> 2) Получения количества по условию
                    <br> 3) И собственно лимитированое количество
                </p>
            </li>

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
                Так выглядит общая струкутура:
                <div class="row">
                <img src = "/main/img/paging_table_1.png">
                </div>

                <div class="col-md-12 center-wrap">

                    <label class="radio-inline"><input type="radio" name="paging-table-first">paging_table</label>
                    <label class="radio-inline"><input type="radio" name="paging-table-first">paging_column_type</label>
                    <label class="radio-inline"><input type="radio" name="paging-table-first">paging_column</label>

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


        RebuildReport(null);
        console.log(nodeObjects);
    function RebuildReport(node){
        $('#select2-query').text('');
        var gridParams = {
            urlDataTable:  '/objectdb/showdata',
            checkedUrl:    '/objectdb/idsdata',
            urlSelect2:    '/objectdb/txtsrch',
            idName: 'id',
            columns: '{"columns":[{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]}',
            is_mat: false,
            lengthMenu: [[5,10],[5,10]],
            displayLength: 5,
            select2Input: true,
            tableDefault: 'vw_infinitive',
            checkboxes: false,
            dtFilters: false,
            dtTheadButtons: false};

        wrapper = $('.data-tbl').DataTableWrapperExt(gridParams);

    }
</script>