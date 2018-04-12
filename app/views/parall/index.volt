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
            <li><a class="wrapper-blog" href="/parall/part1" title="Анализ частей речи (Супер книга)">Анализ частей речи (Супер книга)</a></li>
            <li><a class="wrapper-blog" href="/parall/part2" title="Tsvector (Могучая индексация)">Tsvector (Могучая индексация)</a></li>
            <li><a class="wrapper-blog" href="/parall/part5" title="Исходники">Исходники</a></li>
        </ol>
    </div>
</div>
<hr>
</div>
<link rel="stylesheet" type="text/css" href="/parallel/parallel.css" />
<parall>
    <div id ="row">
        <div class="center-wrap">
            <h5>Параллельные координаты</h5>
            <div id ='select-parallel'> </div>
        </div>
    <div id="header">
        <button title="Zoom in on selected data" id="keep-data" disabled="disabled">Приблизить</button>
        <button title="Remove selected data" id="exclude-data" disabled="disabled">Исключить</button>
        <button title="Export data as CSV" id="export-data">Export</button>
        <div class="controls">
            <strong id="rendered-count"></strong>/<strong id="selected-count"></strong>
            <div class="fillbar"><div id="selected-bar"><div id="rendered-bar">&nbsp;</div></div></div>
            Lines at <strong id="opacity"></strong> opacity.
            <span class="settings"></span>
        {#<button id="hide-ticks">Спрятать описание</button>
        <button id="show-ticks" disabled="disabled">Show Ticks</button>#}
        </div>
    </div>
        <div style="clear:both;"></div>
    <div id="chart">
</div>
    </div>
    <div id="wrap">
    </div>
</parall>
<hr>
<div class="center-wrap">
    <h5>Части речи</h5>
</div>
<div class="row">
    <div class="col-md-5">
        <div id = "bible-tree"></div>
    </div>
    <div class="col-md-7">
        <div id="container-chart">
        </div>
    </div>
</div>

<script src="/parallel/d3.v2.js"></script>
<script src="/parallel/underscore.js"></script>
<script src="/parallel/parallel.js"></script>

<script>
    function runRenderPercent(book_id) {
        $("#container-chart").empty();
        $.ajax({
            url: "/parall/biblepie/" + book_id,
        }).done(function (response) {
            /*response = JSON.parse(response);*/
            $.each(JSON.parse(response), function(key,value) {
                var itt = 0;
                if(key == 'pie_word_by_part_of_speech') {
                    $.each(value, function(key,value2) {
                        itt++;
                        renderPiePercent(value2, 'pie_word_by_part_of_speech_' + itt);
                    });
                }
                else {
                    renderPiePercent(value, key);
                }
            });
        })
    };

    function renderPiePercent(data,selector)
    {
        $("#container-chart").append('<div id="'+selector+'"></div>');
        var total = 0, percentage,convertArray = [];

        $.each(data.data, function() {

            total+=this.y;
        });

        $.each(data.data, function() {
            convertArray.push({name:this.name.toUpperCase() + ' ('+this.y +')',y: (this.y/total * 100)});
        });

        Highcharts.map(Highcharts.getOptions().colors, function (color) {
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

        Highcharts.chart(selector, {
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
                text: data.title,
            },
            credits: {
                enabled: false
            },
            subtitle: {
                text: data.subtitle
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
                    showInLegend: false
                }
            },
            series: [{
                name: '%',
                data: convertArray
            }]
        });
    }

    nodeObjects = {{ js_tree_data }};

   var bibleTree = $('#bible-tree').jstree({
        'core':
            {data:nodeObjects},
        plugins: ["search","types"],
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

    bibleTree.bind('ready.jstree', function(e, data) {
        $(this).jstree('open_all');
        $(this).jstree(true).select_node(10000);
        node = ($(this).jstree(true).get_node('10000')).original;

        runRenderPercent(node.id);
    });

    $('#bible-tree').bind("click.jstree", function (event,data) {
        var tree = $(this).jstree();
        var node = tree.get_node(event.target);
        runRenderPercent(node.id);
    });

var item = {
        "bible_by_type": {
            "yaxis": {
                "Старый завет": [318, 65, 67],
                "Новый завет": [185, 80, 45]
            },
                "xaxis": {
                    "ЧАСТИЦА":"ЧАСТИЦА",
                    "МЕСТОИМ_СУЩ":"МЕСТОИМ_СУЩ",
                    "БЕЗЛИЧ_ГЛАГОЛ":"БЕЗЛИЧ_ГЛАГОЛ",
                    "СУЩЕСТВИТЕЛЬНОЕ":"СУЩЕСТВИТЕЛЬНОЕ",
                    "СОЮЗ":"СОЮЗ",
                    "ЧИСЛИТЕЛЬНОЕ":"ЧИСЛИТЕЛЬНОЕ",
                    "ПРИЛАГАТЕЛЬНОЕ":"ПРИЛАГАТЕЛЬНОЕ",
                    "ВВОДНОЕ":"ВВОДНОЕ",
                    "МЕСТОИМЕНИЕ":"МЕСТОИМЕНИЕ",
                    "ИНФИНИТИВ":"ИНФИНИТИВ",
                    "ПРЕДЛОГ":"ПРЕДЛОГ",
                    "ПОСЛЕЛОГ":"ПОСЛЕЛОГ",
                    "ГЛАГОЛ":"ГЛАГОЛ",
                    "НАРЕЧИЕ":"НАРЕЧИЕ",
                    "ДЕЕПРИЧАСТИЕ":"ДЕЕПРИЧАСТИЕ"
                },
                "csv": "/parallel/bible_parall_type.csv",
                "descr": "X-тип речи, Y- по класификации,DIM-слова"
        }, "bible_part_of_speech":
    {"yaxis":
    {   "ЧАСТИЦА":[318, 29, 10],
        "МЕСТОИМ_СУЩ":[37, 50, 0],
        "БЕЗЛИЧ_ГЛАГОЛ":[325, 50, 39],
        "СУЩЕСТВИТЕЛЬНОЕ":[120, 56, 40],
        "СОЮЗ":[555, 55, 55],
        "ЧИСЛИТЕЛЬНОЕ":[185, 80, 45],
        "ПРИЛАГАТЕЛЬНОЕ":[300, 80, 20],
        "ВВОДНОЕ":[150, 30, 40],
        "МЕСТОИМЕНИЕ":[160, 20, 20],
        "ИНФИНИТИВ":[190, 244, 10],
        "ПРЕДЛОГ":[250, 20, 20],
        "ПОСЛЕЛОГ":[300, 80, 20],
        "ГЛАГОЛ":[185, 80, 45],
        "НАРЕЧИЕ":[240, 80, 90],
        "ДЕЕПРИЧАСТИЕ":[200, 80, 60]
    },
        "xaxis":{
            "0_5000_old":"Страницы (0-5000) старый завет",
            "5000_10000_old":"Страницы (5000-10000) старый завет",
            "10000_15000_old":"Страницы (10000-15000) старый завет",
            "15000_20000_old":"Страницы (15000-20000) старый завет",
            "20000_25000_old":"Страницы (20000-25000) старый завет",
            "25000_30000_old":"Страницы (25000-30000) старый завет",
            "30000_35000_new":"Страницы (30000-35000) новый завет",
            "35000_38546_new":"Страницы (35000-38546) новый завет",
        },
        "csv":"/parallel/bible_parall_full.csv",
        "descr":"X-постранично c лимотом,Y - типы речи,DIM-слова"
    }, "bible_part_of_speech_main":
        {"yaxis": {
            "ПРИЛАГАТЕЛЬНОЕ": [300, 80, 20],
            "ИНФИНИТИВ": [190, 244, 10],
            "БЕЗЛИЧ_ГЛАГОЛ": [325, 50, 39],
            "ЧИСЛИТЕЛЬНОЕ": [185, 80, 45],
            "СУЩЕСТВИТЕЛЬНОЕ": [120, 56, 40],
            "ДЕЕПРИЧАСТИЕ": [200, 80, 60],
            "ПОСЛЕЛОГ": [300, 80, 20],
            "ГЛАГОЛ": [185, 80, 45],
            "ВВОДНОЕ": [150, 30, 40],
            "МЕСТОИМЕНИЕ": [160, 20, 20],
        },
            "xaxis":{
                "0_5000_old":"Страницы (0-5000) старый завет",
                "5000_10000_old":"Страницы (5000-10000) старый завет",
                "10000_15000_old":"Страницы (10000-15000) старый завет",
                "15000_20000_old":"Страницы (15000-20000) старый завет",
                "20000_25000_old":"Страницы (20000-25000) старый завет",
                "25000_30000_old":"Страницы (25000-30000) старый завет",
                "30000_35000_new":"Страницы (30000-35000) новый завет",
                "35000_38546_new":"Страницы (35000-38546) новый завет",
            },
            "csv":"/parallel/bible_parall_main.csv",
            "descr":"X-постранично c лимотом,Y - основные типы речи,DIM-слова"
        }};

    createRadioBt();

    function createRadioBt() {
        $.each(item, function (key, value) {
            $('#select-parallel').append('<label><input type="radio" checked id = "' + key + '" name="parallel-type">'+item[key].descr+'</label>');
        });

        $("input[name=parallel-type]").on("click", function (e) {
            var parallId = ($(this).attr('id'));
            prepareData(parallId);
        });
    };

    prepareData('bible_part_of_speech_main');
    function prepareData(parallId)
    {
        d3.select('#chart').selectAll('svg').remove();
        d3.select("svg").empty();

        $('#chart').empty();
        $('#legend').empty();
        $('#chart').append('<canvas id="background"></canvas>  <canvas id="foreground"></canvas>  <canvas id="highlight"></canvas> <svg></svg>');

        $('#wrap').empty();

        var xaxis = '';
        $.each(item[parallId].xaxis, function (key, value) {
            xaxis = xaxis + '<strong>'+key+' - </strong>'+value+'<br>';
        });

        var v =
             '<div class="row">'
            +'<div class="col-sm">'
            +'<div class="third" id="legend-block">'
            +'<div class="little-box"><h3>X(axis)</h3>'
            +'<p>'+xaxis +'</p>'
            +'</div>'
            +'</div>'
             +'</div>'
            +'<div class="col-sm">'
            +'<div class="third"><h3>Y(axis)</h3>'
            +'<p id="legend"> </p></div>'
            +'</div>'
            +'<div class="col-sm">'
            +'<div class="third">'
            +'<h3><input type="text" id="search" placeholder=""/></h3>'
            +'<p id="item-list"></p></div>'
            +'</div>'
            +'</div>';

        $('#wrap').append(v);

       initParallel(item[parallId].csv,item[parallId].yaxis);
    }
</script>



