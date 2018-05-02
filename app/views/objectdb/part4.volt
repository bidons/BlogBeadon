{{ assets.outputCss('blog-css') }}
{{ assets.outputJs('blog-js') }}

<div class="container">
<h2 class="center-wrap">Конструкторы
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
            <li><a class="wrapper-blog" href="/objectdb/part5" title="Как всё устроено" >Как всё устроено</a></li>
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
            Создадим обвёртку и материализуем её:
            Сгенерим существительных  13-ать на 200000-тысч строк в интервале двух лет по дням, рандомно.
                 <pre class="prettyprint lang-sql">
CREATE VIEW vw_gen_materialize as
WITH cte AS (
    SELECT
      generate_series(1, 200000)                                                                                    AS id,
      md5(
          (random()) :: TEXT)                                                                                       AS md5,
      ('{Дятел, Братство, Духовность, Мебель,
               Любовник, Аристократ, Ковер, Портос,
               Трещина, Зубки, Бес, Лень, Благоговенье}' :: TEXT []) [(random() * (12) :: DOUBLE PRECISION)] AS series,
      date((((('now' :: TEXT) :: DATE - '2 years' :: INTERVAL) +
             (trunc((random() * (365) :: DOUBLE PRECISION)) * '1 day' :: INTERVAL)) +
            (trunc((random() * (1) :: DOUBLE PRECISION)) *
             '1 year' :: INTERVAL)))                                                                                AS action_date
)
    SELECT
      cte.id,
      cte.md5,
      cte.series,
      cte.action_date
    FROM cte
    ORDER BY cte.action_date;
        </pre>
        </li>
        <li>
            Создадим материализованное представление, екземпляр идентичен самой обвёртки, но теперь он статичен и может
            быть проиндексирован. Опция WITH NO DATA - таблица появится без данных,
            есть определённая полезность в этом,рестор бекапа не будет выполнять инструкцию "REFRESH MATERIALIZED"
            <pre class="prettyprint lang-sql">
                CREATE MATERIALIZED VIEW mv_gen_materialize AS
                  (
                    SELECT *
                    FROM vw_gen_materialize
                  ) WITH NO DATA;

                REFRESH MATERIALIZED VIEW mv_gen_materialize;

                CREATE EXTENSION if NOT EXISTS pg_trgm;

                CREATE INDEX mv_gen_materialize_series_trg_idx          ON mv_gen_materialize USING GIN (series gin_trgm_ops);
                CREATE INDEX mv_gen_materialize_series_action_date_idx ON mv_gen_materialize USING BTREE (action_date);
            </pre>
        </li>
        <li>
            Поскольку множество статично и его преагрегированное состояние не изменно на момент времени перестроения,
            мы можем процедурно вызывать различные запросы для получения данных для визулизаций, CSV, JSON и тд.
            <pre class="prettyprint lang-sql">
                REFRESH MATERIALIZED VIEW mv_gen_materialize;

                WITH prepare_data AS
                    (
                        SELECT
                          date_part('epoch', date_trunc('day', mv.action_date :: DATE)) :: BIGINT * 1000 AS date,
                          series,
                          count(mv.action_date)                                                          AS cn
                        FROM mv_gen_materialize AS mv
                        WHERE series IS NOT NULL
                        GROUP BY series, mv.action_date :: DATE
                    ), get_data AS
                    (
                        SELECT
                          g.series,
                          jsonb_agg(json_build_array(date, cn) ORDER BY date)  AS rs,
                          array_agg(date) AS d
                        FROM prepare_data AS g
                        WHERE series IS NOT NULL
                        GROUP BY g.series
                    ), get_pie_data AS
                    (
                        SELECT
                          series   AS name,
                          count(*) AS y
                        FROM mv_gen_materialize
                        WHERE series IS NOT NULL
                        GROUP BY series
                    )
                    SELECT json_build_array((SELECT json_build_object('title', 'Генерация (сток)', 'type', 'stock', 'chart',
                                                                      json_agg(
                                                                          json_build_object('type', 'area', 'name', series, 'data', rs)))
                                             FROM get_data),
                                            json_build_object('title', 'Генерация (пирог)', 'type', 'pie', 'chart',
                                                              (SELECT json_agg(get_pie_data)
                                                               FROM get_pie_data))
                    );

                            ---Output
                                    [
                        {
                            "type": "stock",
                            "chart": [
                                {
                                    "data": [
                                        [
                                            1461013200000,
                                            55
                                        ],
                                        [
                                            1461099600000,
                                            45
                                        ],
                                        [
                                            1461186000000,
                                            50
                                        ],
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

    RebuildReport(getPagingViewObject('vw_gen_materialize'));

    function renderCharts(view_name) {
        $.ajax({
            url: "/objectdb/viewchart/" + view_name,
        }).done(function (response) {
            console.log(response);
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

        renderCharts('vw_gen_materialize');

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