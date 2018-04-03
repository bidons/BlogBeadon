<h2 class="center-wrap">Конструкторы
    (<strong>Пагинаторы</strong>)
</h2>

<div class="container">
<div class="row">
    <div class="col-md-4">
        <div class="text-center">.
            <img class="rounded-circle" src="/main/img/calosha.jpg"  width="300" height="250">
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
            <p>
                При использовании обвёрток, мы используем простое условие 'WHERE'.
                Логика предикатов-условий (логических операторов) теперь имеет более простую форму,
                выглядит это так - "дай мне что-то из таблицы по условию, где это и это true
                с минимальным количеством взаимоисключающих переменных.
                Всё что нельзя просто достать с простым условием, заставляет нас переделывать сам конструктор что собственно намного облегчает работу
                с множеством в реляицонной среде.
                </p>
            </li>


    <li> Cоздадим простую обвёртку (части речи + тип языка+ тип речи + исключим "ПУНКТУАТОРЫ")

        <pre class="prettyprint lang-sql">CREATE VIEW vw_word_with_prop AS
        SELECT sg.name AS word,
        freq,
        sgc.name AS class_name,
        sgl.name AS LANGUAGE
        FROM sg_entry sg
        LEFT JOIN sg_class AS sgc ON sgc.id = sg.id_class
        LEFT JOIN sg_language AS sgl ON sgl.id = sgc.id_lang
        WHERE sg.id_class != 22;
        </pre>
        </p>

        <li>
            <p>
                Вот оно наше условие (как пример из таблицы):
            </p>
            <pre class="prettyprint lang-sql">

            WITH objdb AS ( SELECT word, freq, class_name, language
                            FROM vw_word_with_prop
                            WHERE true
                                AND word in ('явствовать')
                                AND class_name in ('ГЛАГОЛ')
                            ORDER BY class_name ASC LIMIT 5 OFFSET 0 )
            SELECT  json_agg(row_to_json(objdb))
            FROM    objdb
            </pre>
        </li>


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
            <div class="btn-group">
                <div class="input-group-btn">
                    <button class="btn btn-default" onclick="wrapper.getDataTable().ajax.reload()"> <span class="glyphicon glyphicon-filter">Поиск</span> </button>
                    <button type="button" class="btn btn-default" onclick="wrapper.clearFilter()"> <span class="glyphicon glyphicon-remove-circle">Очистка</span> </button>
                    <button type="button" class="btn btn-default" id="sql-view"data-toggle="modal"  data-target="#modalDynamicInfo"><span class="glyphicon glyphicon-remove-circle">View-Sql</span></button>
                </div>
            </div>

            <div class="data-tbl"></div>
        </div>
    </li>
</div>

</div>
<script>

    nodeObjects = {{ js_tree_data }}

    RebuildReport(getPagingViewObject('vw_word_with_prop'))

    function RebuildReport(node) {
        definitionSql  = node.view;

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
            dtFilters: true,
            dtTheadButtons: false
        };

        wrapper = $('.data-tbl').DataTableWrapperExt(gridParams);
    }
</script>