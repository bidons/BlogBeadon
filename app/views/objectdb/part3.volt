<h2 class="center-wrap">Конструкторы
    (<strong>Пагинаторы</strong>)
</h2>


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
                Условия 'WHERE' имеет исключительно предикативную функцию
                Логика предикатов-условий (логических операторов) теперь имеет более простую форму, выглядит это так - "дай мне что-то из таблицы по условию"
                с минимальным количеством взаимосключающих переменных. Тобишь
                всё что нельзя просто достать с простым условием, заставляет нас переделывать сам конструктор что собственно намного облегчает работу.
                </p>
            </li>
        </ul>
</div>

<script>
    $('[name=paging-table-first]').click(function () {
        var v = $(this).attr('view-name');

        RebuildReport(getPagingViewObject(v))
    });

    var condPredicate = [{"name":"bool","cond_default":["="]},
        {"name":"text","cond_default":["=", "~", "!=", "in"]},
        {"name":"int4","cond_default":["=", "!=", "<", ">", "<=", ">=", "in"]},
        {"name":"timestamp","cond_default":["between", "not between", "in"]}];

    $('#cond-predicate').html('<pre><code class="json">' + syntaxHighlight(condPredicate) + '</code> </pre>');

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