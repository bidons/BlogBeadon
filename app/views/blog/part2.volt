<div class="container">
    <div class="modal fade" id="modalDynamicInfo" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel"> </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4">
            <div class="text-center">.
                <img class="rounded-circle" src="/main/img/slide-1.png"  width="300" height="300">
            </div>
        </div>
        <div class="col-md-8">
        <span>
             <ul>
                 <li>
                     Вообщем откуда всё взялось, множество ORM используют большое количество абстракций для работы с БД (мета данные, клонирование схемы бд итд.),
                     и собственно призваны облегчить разработчику жизнь. Что собственно делает нас немного далёкими от того что происходит в БД, я попытаюсь показать альтернативный подход
                     к построению архитектуры для работы с больший количеством строк
                     с пагинацией использую при этом средства посгреса, где ОRM играет второстепенную роль, хотя без не обойтись да и не нужно.
                 </li>
            <br>
                 <li>
                     Начнём с того что собстевенно любое взаимодействие с объектами состоит в реляционном виде, в виде связей,
                     и благо что реляционные БД представляют нам эту возможность.
                 </li>
             </ul>
        </span>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="center-wrap">
                <div style="margin-bottom:16px">
                    <span class="badge badge-secondary" id="datatable-data" data-toggle="modal"  data-target="#modalDynamicInfo"></span>
                    <span class="badge badge-secondary" id="datatable-f-ttl"data-toggle="modal"  data-target="#modalDynamicInfo"></span>
                    <span class="badge badge-secondary" id="datatable-ttl"data-toggle="modal"  data-target="#modalDynamicInfo"></span>
                    <span class="badge badge-secondary" id="select2-query"data-toggle="modal"  data-target="#modalDynamicInfo"></span>
                    <span class="badge badge-secondary" id="response-json"data-toggle="modal"  data-target="#modalDynamicInfo">Response:1</span>
                    <span class="badge badge-secondary" id="request-json"data-toggle="modal"  data-target="#modalDynamicInfo">Request:1</span>
                </div>
                <th><div class="btn-group">
                        <div class="input-group-btn">
                            <button type="button" class="btn btn-default" onclick="wrapper.getDataTable().ajax.reload()"> <span class="glyphicon glyphicon-filter">Поиск</span> </button>
                            <button type="button" class="btn btn-default" onclick="wrapper.clearFilter()"> <span class="glyphicon glyphicon-remove-circle">Очистка</span> </button>
                            <button type="button" class="btn btn-default" id="sql-view"data-toggle="modal"  data-target="#modalDynamicInfo"><span class="glyphicon glyphicon-remove-circle">View-Sql</span></button>
                        </div></div>
                </th>
            </div>
            <div class="data-tbl"> </div>
        </div>
    </div>

    <div class="col-md-12">
        {#<img src = "/main/part1/paging_table.png" >#}
    </div>


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

            Можно обвернуть во вьюху запрос и обращатся к нему как к обычной таблице. Вьюха может содержать всё что угодно.
            К примеру можно использовать вкусняхи расширения и по полной юзать возможности postgresql
            "ltree,dblink,postgres_fdw,file_fdw,Windows function, join lateral, piviot extension".

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
    <img src = "/main/part1/paging_table.png" >
</div>



<script>
    var wrapper;
    var definitionSql ='';
    $(document).ready(function () {
            RebuildReport(node)

        function RebuildReport(node){
            $('#select2-query').text('');
            var gridParams = {
                urlDataTable:  '/blog/showdata',
                checkedUrl:    '/blog/idsdata',
                urlSelect2:    '/blog/txtsrch',
                idName: 'id',
                columns: [],
                is_mat: false,
                lengthMenu: [[5,10],[5,10]],
                displayLength: 5,
                select2Input: true,
                tableDefault: 'vw_impersonal_verb',
                checkboxes: false,
                dtFilters: true,
                dtTheadButtons: false};

            wrapper = $('.data-tbl').DataTableWrapperExt(gridParams);

        }

    });

    $('#modalDynamicInfo').on("show.bs.modal", function(e) {
        var value = ($(e.relatedTarget).attr('id'));
        var info = wrapper.getJsonInfo();


        if(value) {
            switch (value) {
                case 'datatable-data':
                    object = info['dtObj'].o.debug.query[0];
                    break;
                case 'datatable-f-ttl':
                    object = info['dtObj'].o.debug.query[1];
                    break;
                case 'datatable-ttl':
                    object = info['dtObj'].o.debug.query[2];
                    break;
                case 'select2-query':
                    object = info['s2obj'];
                    break;
                case 'response-json':
                    object = info['dtObj'].o;
                    break;
                case 'request-json':
                    object = info['dtObj'].i;
                    break;
                case 'sql-view':
                    object = definitionSql;
                    break;

                default:
            }

            $(this).find(".modal-body").html('<pre><code class="json">' + syntaxHighlight(object) + '</code> </pre>');
        }
    });

    function syntaxHighlight(json) {
        if (typeof json != 'string') {
            json = JSON.stringify(json, undefined, 2);
        }
        json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
            var cls = 'number';
            if (/^"/.test(match)) {
                if (/:$/.test(match)) {
                    cls = 'key';
                } else {
                    cls = 'string';
                }
            } else if (/true|false/.test(match)) {
                cls = 'boolean';
            } else if (/null/.test(match)) {
                cls = 'null';
            }
            return '<span class="' + cls + '">' + match + '</span>';
        });
    }

</script>
