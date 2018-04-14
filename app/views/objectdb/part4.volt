{{ assets.outputCss('blog-css') }}
{{ assets.outputJs('blog-js') }}

{#
<script src="https://code.highcharts.com/stock/highstock.js"></script>
#}

<div class="container">
<h2 class="center-wrap">Конструкторы
    (<strong>Пагинаторы</strong>)
</h2>

<div class="row">
    <div class="col-md-4">
        <div class="text-center">.
            <img class="rounded-circle" src="/main/img/person_1.jpeg"  width="300" height="250">
        </div>
    </div>
    <div class="entry-content"></div>
    <div class="post-series-content">
        {#<p>This post is first part of a series called #}{#<strong>Getting Started with Datatable 1.10</strong>.</p>#}
        <ol>
            <li><a class="wrapper-blog" href="/objectdb/index" title="Введение (зачем, почему)" >Введение</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part1" title="Реляционное связывание (таблиц и полей)">Реляционное связывание таблиц и полей</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part2" title="Особенности работы  (планировщика запросов) PosgreSQL">Особенности работы  (планировщика запросов) PosgreSQL</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part3" title="Работы с фильтрами-условиями (предикативная логика)">Работы с фильтрами-условиями (предикативная логика)</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part4" title="Материализация (Materialize View)" >Материализация (Materialize View)</a></li>
        </ol>
    </div>
</div>
<hr>

<div class="well">
    <ul>
        <li>
            <p>
                Про материализованные вьюхи много чего написано в просторах, не буду об этом много писать.
                <p>
                Materialize view - это механизм преагрегации который материализует запрос, таблицу, вьюху в статическую таблицу. Перечислю несколько преимуществ:
                </p>
                <ol>
                    <li>
                        При материализации можно не волноваться об MVCC, транзакционностью и блокировками
                    </li>
                    <li>
                        Материализация позволяет нам писать cложные запросы
                    </li>
                 <li>
                     При материализации общее количество известно, его можно посчитать один раз.
                 </li>
                 <li>
                 Возможность индексации.
                 </li>
                    <li>
                        Материализованные таблицы можно исключить из бекапа, и всегда собрать при ресторе на тестовом окружении.
                    </li>
                    <li>
                        Создадим обвёртку и материализуем её. Сгенерим существительных 13-ать на 200000-тысч строк в интервале двух лет по дням, рандомно.
                    </li>
                </ol>
            </p>
        </li>

        <li>
            Поехали зауяхчим вьюху и материализуем её:
            Сгенерим существительных  13-ать на 200000-тысч строк в интервале двух лет по дням, рандомно.
                 <pre class="prettyprint lang-sql">

WITH cte AS (
            SELECT generate_series(1, 200000) AS id,
                   md5((random())::text)                                                                 AS md5,
            ('{Дятел, Братство, Духовность, Мебель,
               Любовник, Аристократ, Ковер, Портос,
               Трещина, Зубки, Бес, Лень, Благоговенье}'::text[])[(random() * (12)::double precision)]   AS series,
            date((((('now'::text)::date - '2 years'::interval) +
            (trunc((random() * (365)::double precision)) * '1 day'::interval)) +
            (trunc((random() * (1)::double precision)) * '1 year'::interval)))                           AS action_date
                     )
             SELECT cte.id, cte.md5, cte.series, cte.action_date
             FROM cte
             ORDER BY cte.action_date;
        </pre>
        </li>
    </ul>
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
    <div class="btn-group">
        <div class="input-group-btn">
            <button class="btn btn-default" onclick="wrapper.getDataTable().ajax.reload()"> <span class="glyphicon glyphicon-filter">Поиск</span> </button>
            <button type="button" class="btn btn-default" onclick="wrapper.clearFilter()"> <span class="glyphicon glyphicon-remove-circle">Очистка</span> </button>
            <button type="button" class="btn btn-default" id="sql-view"data-toggle="modal"  data-target="#modalDynamicInfo"><span class="glyphicon glyphicon-remove-circle">View-Sql</span></button>
        </div>
    </div>

    <div class="data-tbl"></div>

</div>
    <div id="stock-chart" style="min-width: 1000px; height: 600px; max-width: 1200px;"></div>
    <div id="pie-chart-2"  style="min-width: 1000px; height: 600px; max-width: 1200px;"></div>
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
    /*data = data.chart_data;*/

    RebuildReport(getPagingViewObject('vw_gen_materialize'))

    function renderCharts(view_name) {

        $.ajax({
            url: "/objectdb/viewchart/" + view_name,
        }).done(function (response) {
            response = JSON.parse(response);
            renderStockChart(response[0],'stock-chart');
            renderPiePercent(response[1],'pie-chart-2');
        })
    };

    function renderPiePercent(data,selector) {
        var total = 0, percentage,convertArray = [];
        $.each(data.chart, function() {
            total+=this.y;
        });

        $.each(data.chart, function()
        {
            convertArray.push({name:this.name + '('+this.y +')',y: (this.y/total * 100)});
        });

        var v = Highcharts.map(Highcharts.getOptions().colors, function (color) {
            return {
                radialGradient: {
                    cx: 0.5,
                    cy: 0.3,
                    r: 0.7
                },
                stops: [
                    [0, color],
                    [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
                ]
            };
        });

        var v =   Highcharts.chart(selector, {
            chart: {
                backgroundColor: {
                    linearGradient: { x1: 0, y1: 0, x2: 1, y2: 1 },
                    stops: [
                        [0, 'rgb(255, 255, 255)'],
                        [1, 'rgb(200, 200, 255)']
                    ]
                },
                plotShadow: false,
                type: 'pie'
            },
            title: {
                text: ''
            },
            credits: {
                enabled: false
            },
            subtitle: {
                text: data.title
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    size:'70%',
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        },
                        connectorColor: 'silver'

                    },
                    showInLegend: true
                }
            },
            series: [{
                name: '%',
                data: convertArray
            }]
        });
    }


    function RebuildReport(node) {

        definitionSql  = node.view;

        console.log(node)
        var gridParams = {
            urlDataTable: '/objectdb/showdata',
            checkedUrl: '/objectdb/idsdata',
            urlSelect2: '/objectdb/txtsrch',
            idName: 'id',
            columns: node.col,
            is_mat: node.is_mat,
            lengthMenu: [[5, 10], [5, 10]],
            displayLength: 5,
            select2Input: true,
            tableDefault: node.view_name,
            checkboxes: false,
            dtFilters: true,
            dtTheadButtons: false,
            initComplete: function ()
            {
                renderCharts('vw_gen_materialize');
            }
        };
        wrapper = $('.data-tbl').DataTableWrapperExt(gridParams);
    }

    function renderStockChart(d,selector) {
            var v = Highcharts.stockChart(selector, {
                title: {
                    text: d.title
                },
                chart: {
                    backgroundColor: {
                        linearGradient: {x1: 0, y1: 0, x2: 1, y2: 1},
                        stops: [
                            [0, 'rgb(255, 255, 255)'],
                            [1, 'rgb(200, 200, 255)']]
                    }
                },
                credits: {
                    enabled: false
                },
                subtitle: {
                    text: ''
                },
                rangeSelector: {
                    selected: 0
                },

                yAxis: {
                    labels: {
                        formatter: function () {
                            return (this.value > 0 ? ' + ' : '') + this.value + '%';
                        }
                    },
                    plotLines: [{
                        value: 0,
                        width: 2,
                        color: 'silver'
                    }]
                },

                plotOptions: {
                    series: {
                        compare: 'percent',
                        showInNavigator: true
                    }
                },

                tooltip: {
                    pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.change}%)<br/>',
                    valueDecimals: 0,
                    split: true
                },

                series: d.chart
            });
    };

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