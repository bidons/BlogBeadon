

<h2 class="center-wrap">Конструкторы
    (<strong>Пагинаторы</strong>)
</h2>


<div class="row">
    <div class="col-md-4">
        <div class="text-center">.
            <img class="rounded-circle" src="/main/img/slide-1.png"  width="300" height="300">
        </div>
    </div>
    <div class="entry-content"></div>
    <div class="post-series-content">
        {#<p>This post is first part of a series called #}{#<strong>Getting Started with Datatable 1.10</strong>.</p>#}
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

<div class="container">
    <br>
    <div class="row">
        <div class="col-md-12">
        <span>
             <ul>
                 <li>
                     Вообщем откуда всё взялось, множество ORM используют большое количество абстракций для работы с БД (мета данные, клонирование схемы бд итд.),
                     и собственно призваны облегчить разработчику жизнь но с другой стороны это довольно сильно запутывает, и мягко говоря завставляет проводить просто
                     титанические усилия по оптимизации SQL запросов попробую показать альтернативный подход к построению архитектуры для работы с большим количеством строк с пагинацией используя при этом средства посгреса,
                     где ОRM играет второстепенную роль, хотя без не обойтись да и не нужно.
                 </li>
            <br>
                 <li>
                     <p> Cмысл заключает вот в чём: </p>
                      Если обвернуть во вьюху запрос и обращатся к нему как к обычной таблице, то мы можем получить очень неплохие вкусняхи,
                      к примеру можно использовать вкусняхи-расширения, и по полной юзать возможности PostgreSql
                        "ltree,dblink,postgres_fdw,file_fdw,Windows function, join lateral, pivot extension etc".
                 </li>
            <br>
            <br>
            <p>В качестве примера я накидал лабораторию слегка переопределив DataTable для работы с констуктором, и заранее
                         создал дерево проекта в виде дерева. В качестве реляционных примеров будем юзать: -"
                <a class="wrapper-blog" href="http://www.solarix.ru/sql-dictionary-sdk.shtml" title="Лексику и морфологию Русского языка">Лексику и морфологию Русского языка</a>"
                , и по мелочам что успею собрать (различных полезностей)
                     </p>
             </ul>
        </span>
        </div>
    </div>
    <hr>
    <div class="row">
        <div class="col-md-4">
            <input class="search-input form-control" placeholder="Поиск">
            <div id = "db_object_tree"></div>
        </div>
        <div class="col-md-8">
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

</div>


<hr>
<script>
    var wrapper;
    var definitionSql ='';

    $(document).ready(function () {
        nodeObjects = {{ js_tree_data }}

        var ReportTree = $('#db_object_tree').jstree({
            'core': {
                'data':nodeObjects
            }, plugins: ["search","types"],
            "types" : {
                "default" : {
                    "icon" : "glyphicon glyphicon-asterisk"
                },
                "file" : {
                    "icon" : "glyphicon glyphicon-asterisk",
                    "valid_children" : []
                }
            },
        });

        $(".search-input").keyup(function () {
            var searchString = $(this).val();
            ReportTree.jstree('search', searchString);
        });

        $('#db_object_tree').bind("click.jstree", function (event,data) {
            var tree = $(this).jstree();

            var node = tree.get_node(event.target);
            if(node.original.parent != '#') {
                definitionSql  = node.original.view;
                RebuildReport(node.original);
            };
        });

        ReportTree.bind('ready.jstree', function(e, data) {
            $(this).jstree('open_all');
            $(this).jstree(true).select_node(100004);
            node = ($(this).jstree(true).get_node('100004')).original;
            definitionSql  = node.view;
            RebuildReport(node)
        });

        function RebuildReport(node){
            $('#select2-query').text('');
            var gridParams = {
                urlDataTable:  '/objectdb/showdata',
                checkedUrl:    '/objectdb/idsdata',
                urlSelect2:    '/objectdb/txtsrch',
                idName: 'id',
                columns: JSON.parse(node.col),
                is_mat: false,
                lengthMenu: [[5,10],[5,10]],
                displayLength: 5,
                select2Input: true,
                tableDefault: node.view_name,
                checkboxes: false,
                dtFilters: true,
                dtTheadButtons: false};

            wrapper = $('.data-tbl').DataTableWrapperExt(gridParams);

        }
    });

</script>

