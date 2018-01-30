
<div class="container">
    <div class="resume">
        <div class="row">
            <!--<div class="col-xs-12 col-sm-12 col-md-offset-1 col-md-10 col-lg-offset-2 col-lg-8">-->
            <div class="col-sm-12 col-sm-12 ">
                <div class="panel panel-default">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="col-xs-12 col-sm-4">
                                <figure>
                                    <img class="img-circle img-responsive" alt="" src="/main/img/kuas.jpg">
                                </figure>
                            </div>
                            <div class="col-xs-12 col-sm-8">
                                <div class="bs-callout bs-callout">
                                    <a class="list-group-item inactive-link">
                                        <h4 class="list-group-item-heading"></h4>
                                        <p class="list-group-item-text">
                                            Инструменты:
                                        </p>
                                        <br>
                                        <p class="list-group-item-text">
                                            Описание:
                                        </p>
                                        <ul>
                                            <li>
                                                С меня не очень хороший писака, вообщем откуда всё взялось,
                                                множество ORM используют большое количество абстрацкий для работы с БД, мета данные, клонирование схемы бд для удобной работы с класами полями и собственно призваны облегчить работу  разработчику работаю в той или иной среде (Phalcon,Yii,Laravel,Django) и тд.. , что собственно делает нас немного далёкими от того что происходит в БД, я попытаюсь показать альтернативный подход к построению архитектуры для работы с больший количеством в строк с пагинацией использую при этом средства посгреса, где ОRM играет второстепенную роль, хотя без не обойтись да и не нужно.
                                                Поехали начнём с того что собстевенно любое взаимодействие с объектами состоит в реляционном в виде связей, и благо что реляционные БД представляют нам эту возможность.
                                            </li>
                                        </ul>

                                        <p></p>
                                    </a>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-lg-12">
                            <div class="col-xs-12 col-sm-4">
                                <figure>
                                    <img class="img-bordered img-responsive" alt="" src="/main/img/column_fields.png">
                                </figure>
                            </div>
                            <div class="col-xs-12 col-sm-8">
                                <div class="bs-callout bs-callout">
                                    <a class="list-group-item inactive-link">
                                        <h4 class="list-group-item-heading"></h4>
                                        <p class="list-group-item-text">
                                            В пространство имён PostgreSQL в схеме schema.information_schema,
                                            есть очень удобные таблички в которых можно черпать инфу о полях объектов и их типов
                                        </p>
                                        <br>
                                        <ul>
                                            <li> Типы нам дают возможность рендерить стороне отправленые данные,
                                                и исключать sql-иньекции при получении данных </li>
                                            <li> Можно взаимодействовать с объектами ПГ (таблицы, вьюхи, материализованые вьюхи, примапленые таблицы (fdw))</li>
                                        </ul>
                                        <p class="list-group-item-text">
                                            Где  'abc_alphabet' наш обьект:
                                        </p>
                                        <ul>
                                            <li>
                                                select pga.attname,pgt.typname
                                                from pg_attribute as pga
                                                join pg_type as pgt on pga.atttypid = pgt.oid
                                                where pga.attrelid = 'abc_alphabet'::regclass
                                                AND   NOT pga.attisdropped and pga.attnum > 0;
                                            </li>
                                        </ul>

                                        <p></p>
                                    </a>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>



                    <div class="row">
                        <div class="col-lg-12">

                            <div class="col-xs-12">
                                <div class="bs-callout bs-callout">
                                    <a class="list-group-item inactive-link">
                                        <h4 class="list-group-item-heading"></h4>
                                        <p class="list-group-item-text">
                                            О пагинации:
                                        </p>
                                        <br>
                                        <ul>
                                            <li> При использование пагинации и отправки данных "лимитированого количества"
                                                должны реализованы три важных условия "механизма":
                                            <li>
                                                 Общее количество
                                            </li>
                                            <li>
                                                 Количество по условию
                                            </li>
                                            <li>
                                                 Лимитированое количество
                                            </li>
                                            </li>

                                        </ul>
                                        <p class="list-group-item-text">
                                            Для реализации нам понадобится две ф-н:

                                        </p>

                                        <ul>
                                            <li>
                                                Одна чтоб достать из пространства имён все поля да посторения таблицы динамический:
                                                fn.paging_dbnamespace_column_prop
                                            </li>
                                            <li>
                                                Вторая чтоб вовращать данные для построения пагинации остальное:
                                                fn.paging_object_db

                                                <div class="col-lg-12">
                                                    <div class="col-lg-6">
                                                        Request
                                                    </div>
                                                    <div class="col-lg-6">
                                                        Response
                                                    </div>

                                                </div>
                                            </li>
                                        </ul>

                                        <p></p>
                                    </a>
                                </div>

                        </div>
                    </div>


                    <div class="bs-callout bs-callout">
                        <h4>Лаборатория</h4>
                        <div class="row">
                            <ul class="nav nav-pills" role="tablist">
                                <li role="presentation"><a href="/main/download/part_1/migration.html" data-remote="false" data-toggle="modal" data-target="#modalStaticInfo" class=".bs-example-modal-lg">Migration<span class="badge" id="staf_migration">2</span></a></li>
                                <li role="presentation"><a href="/main/download/part_1/html.html" data-remote="false" data-toggle="modal" data-target="#modalStaticInfo" class=".bs-example-modal-lg">Html<span class="badge">1</span></a></li>
                                <li role="presentation"><a href="/main/download/part_1/js.html" data-remote="false" data-toggle="modal" data-target="#modalStaticInfo" class=".bs-example-modal-lg">JS<span class="badge">1</span></a></li>
                                <li role="presentation"><a data-remote="false" data-toggle="modal" data-target="#modalDynamicInfo" value ="query" class=".bs-example-modal-lg">Query<span class="badge" id="query_counter_selector">0</span></a></li>
                                <li role="presentation"><a data-remote="false" data-toggle="modal" data-target="#modalDynamicInfo" value ="request" class=".bs-example-modal-lg">Request<span class="badge" id="request_counter_selector">0</span></a></li>
                                <li role="presentation"><a data-remote="false" data-toggle="modal" data-target="#modalDynamicInfo" value ="response" class=".bs-example-modal-lg">Response<span class="badge" id="response_counter_selector">0</span></a></li>
                            </ul>
                        </div>

                        <div id="container" class="panel">

                            <div id="db_object_tree">
                                <ul>
                                    <li>Root node 1
                                        <ul>
                                            <li>Child node 1</li>
                                            <li><a href="#">Child node 2</a></li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>

                           {# <select class="js-example-data-array">
                                <option value="vw_pg_stat_activity" selected="selected">vw_pg_stat_activity</option>
                            </select>
                            <button type="button" class="btn btn-default" onclick="wrapper.rebuildTable()">Refresh</button>#}
                        </div>

                        <div class="tt">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>


<div class="modal fade" id="modalStaticInfo" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
            </div>
            <div class="modal-body">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalDynamicInfo" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
            </div>
            <div class="modal-body">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>




<script>
    var wrapper;
    $(document).ready(function () {

        $('#db_object_tree').jstree({ 'core' : {
            'data' : [
                { "id" : "ajson1", "parent" : "#", "text" : "Simple root node" },
                { "id" : "ajson2", "parent" : "#", "text" : "Root node 2" },
                { "id" : "ajson3", "parent" : "ajson2", "text" : "Child 1" },
                { "id" : "ajson4", "parent" : "ajson2", "text" : "Child 2" },
            ]
        }});


/*
        var gridParams = {
            urlColumnData: '/blog/columndata',
            urlDataTable: '/blog/showdata',
            checkedUrl: '/blog/idsdata',
            checkedCounterSelector: '#checked_counter',
            visibleColumnsSelector: '#visible_columns_selected',
            idName: 'id',
            select2Input: true,
            dtFilters:  true,
            tableDefault: 'vw_pg_stat_activity',
            dtTheadButtons:false,
            checkboxes: true
        };
        wrapper = $('.tt').DataTableWrapperExt(gridParams);


        $(".js-example-data-array").select2({
            data: [{id: 'vw_pg_locks', text: 'vw_pg_locks' }, { id:'vw_pg_stat_activity', text: 'vw_pg_stat_activity' }, { id: 'test_p3', text: 'test_p3' }]
        });
*/

    });
</script>
