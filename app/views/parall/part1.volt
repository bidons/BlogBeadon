

<div id="container">
    <h2 class="center-wrap">Морфологический анализ (супер книга)
    </h2>
<div class="row">
    <div class="col-md-4">
        <div class="text-center">.
            <img class="rounded-circle" src="/main/img/super_book.jpg"  width="370" height="300">
        </div>
    </div>
    <div class="entry-content"></div>
    <div class="post-series-content">
        <ol>
            <li><a class="wrapper-blog" href="/parall/index" title="Паралленые координаты">Паралленые координаты</a></li>
            <li><a class="wrapper-blog" href="/parall/part1" title="Анализ частей речи (Супер книга)">Анализ частей речи </a></li>
            <li><a class="wrapper-blog" href="/parall/part2" title="Tsvector (Могучая индексация)">Tsvector (Могучая индексация)</a></li>
            <li><a class="wrapper-blog" href="/parall/part5" title="Исходники">Исходники</a></li>
        </ol>
    </div>
</div>
</div>
<hr>

<div id="container">
<div class="row">
    <div class="col-md-6">
        <div id="chart_pie_by_type"></div>
    </div>

    <div class="col-md-6">
        <div id="chart_pie_by_speech"></div>
    </div>
</div>
</div>

<script>
    var data = {"chart_pie_by_type" : [{"name":"Новый завет","y":98794},
        {"name":"Старый завет","y":412369}], "chart_pie_by_speech" : [{"name":"ЧАСТИЦА","y":32481},
        {"name":"МЕСТОИМ_СУЩ","y":12668},
        {"name":"БЕЗЛИЧ_ГЛАГОЛ","y":572},
        {"name":"СУЩЕСТВИТЕЛЬНОЕ","y":140315},
        {"name":"СОЮЗ","y":47592},
        {"name":"ЧИСЛИТЕЛЬНОЕ","y":5386},
        {"name":"ПРИЛАГАТЕЛЬНОЕ","y":69217},
        {"name":"МЕСТОИМЕНИЕ","y":51451},
        {"name":"ВВОДНОЕ","y":709},
        {"name":"ИНФИНИТИВ","y":9793},
        {"name":"ПРЕДЛОГ","y":44663},
        {"name":"ПОСЛЕЛОГ","y":256},
        {"name":"ГЛАГОЛ","y":73970},
        {"name":"НАРЕЧИЕ","y":19039},
        {"name":"ДЕЕПРИЧАСТИЕ","y":4515}]};

    renderPiePercent(data.chart_pie_by_type,'chart_pie_by_type','Плотность слов');
    renderPiePercent(data.chart_pie_by_speech,'chart_pie_by_speech','Части речи');

    function renderPiePercent(data,selector,title) {

        var total = 0, percentage,convertArray = [];
        $.each(data, function() {
            total+=this.y;
        });

        $.each(data, function()
        {
            convertArray.push({name:this.name + '('+this.y +')',y: (this.y/total * 100)});
        });

        var v = Highcharts.map(Highcharts.getOptions().colors, function (color) {
            return {
                radialGradient: {
                    cx: 0.1,
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
                plotBackgroundColor:  null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie',
                backgroundColor: {
                    linearGradient: { x1: 0, y1: 0, x2: 1, y2: 1 },
                    stops: [
                        [0, 'rgb(255, 255, 255)'],
                        [1, 'rgb(200, 200, 255)']
                    ]
                },
            },

            title: {
                text: ''
            },
            credits: {
                enabled: false
            },
            subtitle: {
                text: title
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
</script>



