{{ assets.outputCss('blog-dt-css') }}
<link rel="stylesheet" type="text/css" href="/plugins/vakata/dist/themes/default/style.min.css">
{{ assets.outputJs('blog-dt-js') }}

<script type="text/javascript" src="/plugins/vakata/dist/jstree.min.js"></script>

{{ partial('layouts/objdb') }}
    <div class="container">
    <div class="row">
        <div class="col-md-12">
        <span>
             <ul>
                 <li>
                     Множество ORM используют большое количество абстракций для работы с БД (мета данные, клонирование схемы бд тд.),
                     и собственно призваны облегчить разработчику жизнь, но с другой стороны это довольно сильно запутывает, и мягко говоря заставляет проводить просто титанические усилия по оптимизации SQL запросов попробую показать альтернативный подход к построению архитектуры для работы
                     с большим количеством строк с пагинацией используя при этом средства БД где ОRM играет второстепенную роль.
                 </li>
            <br>
                 <li>
                      Cмысл заключает вот в чём: - "Если обвернуть запрос во "View" и обращаться к запросу как к обычной таблице, то мы можем получить очень неплохие вкусняхи,
                            к примеру можно использовать расширения, и по полной юзать возможности PostgreSql ltree,dblink,postgres_fdw,file_fdw,Windows function, join lateral, pivot extension etc";.
                 </li>
            <br>
            <p>
                    В качестве примера я накидал лабораторию, слегка переопределив <a class="wrapper-blog" href="https://datatables.net/" title="https://datatables.net/">DataTable</a> для работы с конструктором, и заранее создал дерево проекта.
                    В качестве реляционных примеров будем использовать:
                        -" <a class="wrapper-blog" href="http://www.solarix.ru/sql-dictionary-sdk.shtml" title="Лексику и морфологию Русского языка">Лексику и морфологию Русского языка</a>"
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
                    <div class="table-info" style="margin-bottom:16px"> </div>
                    <span class="badge badge-secondary" id="response-json"  data-toggle="modal"  data-target="#modalDynamicInfo">Ответ:1</span>
                    <span class="badge badge-secondary" id="request-json"   data-toggle="modal"  data-target="#modalDynamicInfo">Запрос:1</span>
                    <div class="table-info-select" style="margin-bottom:16px">
                    </div>
                </div>
                <div class="btn-group">
                        <div class="input-group-btn">
                            <button class="btn btn-default" onclick="wrapper.getDataTable().ajax.reload()"> <span class="glyphicon glyphicon-filter">Поиск</span> </button>
                            <button type="button" class="btn btn-default" onclick="wrapper.clearFilter()"> <span class="glyphicon glyphicon-remove-circle">Очистка</span> </button>
                            <button type="button" class="btn btn-default" id="sql-view"data-toggle="modal"  data-target="#modalDynamicInfo"><span class="glyphicon glyphicon-remove-circle">SQL</span></button>
                        </div>
                </div>
            <div class="data-tbl"> </div>
        </div>
    </div>
</div>
<hr>
</div>
    <script>
    var wrapper;
    var definitionSql ='';

    $(document).ready(function () {
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
            $(this).jstree(true).select_node(100009);
            node = ($(this).jstree(true).get_node('100009')).original;
            definitionSql  = node.view;
            RebuildReport(node);
        });

        function RebuildReport(node){
            $('#select2-query').text('');
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
        }
    });



    $('#modalDynamicInfo').on("show.bs.modal", function(e) {
        var value = ($(e.relatedTarget).attr('id'));
        var info = wrapper.getJsonInfo();
        if(value) {
            switch (value) {
                case 'datatable-data':
                    object = info['dtObj'].o.debug[0].data;
                    break;
                case 'datatable-f-ttl':
                    object = info['dtObj'].o.debug[1].recordsFiltered;
                    break;
                case 'datatable-ttl':
                    object = info['dtObj'].o.debug[2].recordsTotal;
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
