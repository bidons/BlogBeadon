{{ assets.outputCss('blog-dt-css') }}
{{ assets.outputJs('blog-dt-js') }}
<script type="text/javascript" src="https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js?lang=sql"></script>

{{ partial('layouts/objdb') }}

<div class="container">
<div class="well">
    <ul>
        <li>
            <p>
                При использовании обвёрток, мы используем простое условие 'WHERE'. Логика предикатов-условий (логических операторов) теперь имеет более простую форму, выглядит это так - "дай мне что-то из таблицы по условию, где это и это true с минимальным количеством взаимоисключающих переменных. Всё что нельзя просто достать с простым условием, заставляет нас переделывать сам конструктор что собственно намного облегчает работу с множеством в реляционной среде.
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

        <div class="col">
            <div class="center-wrap">
                <pre><h1 class="view_name"></h1></pre>
                <div class="table-info"> </div>
                <span class="badge badge-secondary" id="response-json"  data-toggle="modal"  data-target="#modalDynamicInfo">Ответ (json)</span>
                <span class="badge badge-secondary" id="request-json"   data-toggle="modal"  data-target="#modalDynamicInfo">Запрос (json)</span>
                <div class="table-info-select"> </div>
                <div class="btn-group">
                    <div class="input-group-btn">
                        <button type="button" class="btn btn-default" id="sql-view"data-toggle="modal"  data-target="#modalDynamicInfo"><span class="glyphicon glyphicon-remove-circle">View (sql)</span></button>
                    </div>
                </div>
            </div>
        </div>
            <div class="data-tbl"></div>
        </div>
    </li>
</div>

</div>

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

<script>
    RebuildReport(getPagingViewObject('vw_word_with_prop'))

    function RebuildReport(node){
        definitionSql  = node.view;
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
</script>