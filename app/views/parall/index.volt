


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

<parall>
<link rel="stylesheet" type="text/css" href="/parallel/parallel.css" />

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
    <div id="wrap">
    </div>
    </div>

</parall>

<br>
<div class="row">
    {#<hr>#}
    <div class="col-md-4">
        <input class="search-input form-control" placeholder="Поиск">
        <div id = "bible-tree"></div>
    </div>
    <div class="col-md-8">
            <div id="container-chart">
        </div>
    </div>
</div>

<script src="/parallel/d3.v2.js"></script>
<script src="/parallel/underscore.js"></script>
<script src="/parallel/parallel.js"></script>

<script>

    var v = {"pie_part_of_speech": {"data": [{"y": 19039, "name": "НАРЕЧИЕ"}, {"y": 44645, "name": "ПРЕДЛОГ"}, {"y": 32479, "name": "ЧАСТИЦА"}, {"y": 69163, "name": "ПРИЛАГАТЕЛЬНОЕ"}, {"y": 9792, "name": "ИНФИНИТИВ"}, {"y": 12666, "name": "МЕСТОИМ_СУЩ"}, {"y": 572, "name": "БЕЗЛИЧ_ГЛАГОЛ"}, {"y": 5386, "name": "ЧИСЛИТЕЛЬНОЕ"}, {"y": 138929, "name": "СУЩЕСТВИТЕЛЬНОЕ"}, {"y": 4515, "name": "ДЕЕПРИЧАСТИЕ"}, {"y": 256, "name": "ПОСЛЕЛОГ"}, {"y": 73970, "name": "ГЛАГОЛ"}, {"y": 709, "name": "ВВОДНОЕ"}, {"y": 47591, "name": "СОЮЗ"}, {"y": 51451, "name": "МЕСТОИМЕНИЕ"}], "title": "Доля частей речий", "subtitle": "Библия"}, "pie_word_by_part_of_speech": [{"data": [{"y": 2366, "name": "когда"}, {"y": 1653, "name": "вот"}, {"y": 1090, "name": "тогда"}, {"y": 807, "name": "против"}, {"y": 674, "name": "там"}, {"y": 596, "name": "пусть"}, {"y": 516, "name": "только"}, {"y": 511, "name": "дома"}, {"y": 407, "name": "где"}, {"y": 372, "name": "ныне"}], "title": "НАРЕЧИЕ", "subtitle": "Библия"}, {"data": [{"y": 12118, "name": "в"}, {"y": 4516, "name": "с"}, {"y": 4204, "name": "от"}, {"y": 3870, "name": "из"}, {"y": 3681, "name": "к"}, {"y": 2596, "name": "по"}, {"y": 2336, "name": "у"}, {"y": 1960, "name": "для"}, {"y": 1470, "name": "пред"}, {"y": 1219, "name": "до"}], "title": "ПРЕДЛОГ", "subtitle": "Библия"}, {"data": [{"y": 8674, "name": "не"}, {"y": 7114, "name": "на"}, {"y": 3724, "name": "как"}, {"y": 2712, "name": "же"}, {"y": 2101, "name": "за"}, {"y": 2046, "name": "так"}, {"y": 1913, "name": "во"}, {"y": 1814, "name": "о"}, {"y": 785, "name": "бы"}, {"y": 694, "name": "ни"}], "title": "ЧАСТИЦА", "subtitle": "Библия"}, {"data": [{"y": 2533, "name": "то"}, {"y": 1755, "name": "это"}, {"y": 1386, "name": "которые"}, {"y": 1214, "name": "который"}, {"y": 1208, "name": "всех"}, {"y": 916, "name": "своего"}, {"y": 850, "name": "тот"}, {"y": 763, "name": "того"}, {"y": 758, "name": "твоего"}, {"y": 732, "name": "твой"}], "title": "ПРИЛАГАТЕЛЬНОЕ", "subtitle": "Библия"}, {"data": [{"y": 949, "name": "есть"}, {"y": 452, "name": "быть"}, {"y": 293, "name": "говорить"}, {"y": 222, "name": "жить"}, {"y": 205, "name": "делать"}, {"y": 177, "name": "сказать"}, {"y": 160, "name": "идти"}, {"y": 153, "name": "сделать"}, {"y": 142, "name": "служить"}, {"y": 136, "name": "пить"}], "title": "ИНФИНИТИВ", "subtitle": "Библия"}, {"data": [{"y": 5506, "name": "что"}, {"y": 1851, "name": "все"}, {"y": 1328, "name": "кто"}, {"y": 674, "name": "себя"}, {"y": 663, "name": "себе"}, {"y": 467, "name": "всем"}, {"y": 299, "name": "никто"}, {"y": 287, "name": "чего"}, {"y": 238, "name": "ничего"}, {"y": 229, "name": "собою"}], "title": "МЕСТОИМ_СУЩ", "subtitle": "Библия"}, {"data": [{"y": 278, "name": "грех"}, {"y": 74, "name": "можно"}, {"y": 58, "name": "надлежало"}, {"y": 42, "name": "надо"}, {"y": 40, "name": "нельзя"}, {"y": 29, "name": "надлежит"}, {"y": 19, "name": "следует"}, {"y": 14, "name": "следовало"}, {"y": 4, "name": "пришлось"}, {"y": 3, "name": "жаль"}], "title": "БЕЗЛИЧ_ГЛАГОЛ", "subtitle": "Библия"}, {"data": [{"y": 314, "name": "семь"}, {"y": 307, "name": "одного"}, {"y": 306, "name": "три"}, {"y": 291, "name": "два"}, {"y": 264, "name": "двадцать"}, {"y": 221, "name": "сто"}, {"y": 209, "name": "пять"}, {"y": 179, "name": "четыре"}, {"y": 176, "name": "двух"}, {"y": 161, "name": "десять"}], "title": "ЧИСЛИТЕЛЬНОЕ", "subtitle": "Библия"}, {"data": [{"y": 3358, "name": "господь"}, {"y": 1662, "name": "бог"}, {"y": 1522, "name": "господа"}, {"y": 1164, "name": "один"}, {"y": 1162, "name": "народ"}, {"y": 1157, "name": "сын"}, {"y": 1113, "name": "царь"}, {"y": 1046, "name": "бога"}, {"y": 874, "name": "земли"}, {"y": 865, "name": "земле"}], "title": "СУЩЕСТВИТЕЛЬНОЕ", "subtitle": "Библия"}, {"data": [{"y": 810, "name": "царя"}, {"y": 506, "name": "говоря"}, {"y": 374, "name": "моя"}, {"y": 144, "name": "увидев"}, {"y": 134, "name": "услышав"}, {"y": 134, "name": "моря"}, {"y": 131, "name": "сказав"}, {"y": 103, "name": "будучи"}, {"y": 101, "name": "взяв"}, {"y": 97, "name": "придя"}], "title": "ДЕЕПРИЧАСТИЕ", "subtitle": "Библия"}, {"data": [{"y": 192, "name": "ради"}, {"y": 62, "name": "вслед"}, {"y": 2, "name": "кверху"}], "title": "ПОСЛЕЛОГ", "subtitle": "Библия"}, {"data": [{"y": 3491, "name": "сказал"}, {"y": 2165, "name": "будет"}, {"y": 1303, "name": "было"}, {"y": 1264, "name": "говорит"}, {"y": 1237, "name": "был"}, {"y": 1169, "name": "день"}, {"y": 993, "name": "будут"}, {"y": 927, "name": "мой"}, {"y": 879, "name": "были"}, {"y": 587, "name": "сделал"}], "title": "ГЛАГОЛ", "subtitle": "Библия"}, {"data": [{"y": 509, "name": "итак"}, {"y": 66, "name": "правда"}, {"y": 56, "name": "словом"}, {"y": 38, "name": "однако"}, {"y": 11, "name": "во-первых"}, {"y": 11, "name": "увы"}, {"y": 8, "name": "представьте"}, {"y": 3, "name": "во-вторых"}, {"y": 3, "name": "ура"}, {"y": 2, "name": "наоборот"}], "title": "ВВОДНОЕ", "subtitle": "Библия"}, {"data": [{"y": 28008, "name": "и"}, {"y": 3461, "name": "а"}, {"y": 3320, "name": "ибо"}, {"y": 2783, "name": "но"}, {"y": 2616, "name": "чтобы"}, {"y": 1683, "name": "если"}, {"y": 1229, "name": "потому"}, {"y": 1004, "name": "ли"}, {"y": 947, "name": "да"}, {"y": 684, "name": "также"}], "title": "СОЮЗ", "subtitle": "Библия"}, {"data": [{"y": 6608, "name": "его"}, {"y": 5354, "name": "он"}, {"y": 4907, "name": "я"}, {"y": 3817, "name": "их"}, {"y": 3211, "name": "они"}, {"y": 2984, "name": "ты"}, {"y": 2067, "name": "ему"}, {"y": 1899, "name": "меня"}, {"y": 1778, "name": "мне"}, {"y": 1632, "name": "тебя"}], "title": "МЕСТОИМЕНИЕ", "subtitle": "Библия"}]};

    runRenderPercent(v);

    function runRenderPercent(v)
    {
        $.each(v, function(key,value) {
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
    }

    function renderPiePercent(data,selector) {
        $("#container-chart").append('<div id="'+selector+'"></div>');
        var total = 0, percentage,convertArray = [];

        $.each(data.data, function() {

            total+=this.y;
        });

        $.each(data.data, function()
        {
            convertArray.push({name:this.name.toUpperCase() + ' ('+this.y +')',y: (this.y/total * 100)});
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

        console.log(node);
        /*definitionSql  = node.view;
        RebuildReport(node);*/
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
        }, "bible_part_of_speach":
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
        "ДЕЕПРИЧАСТИЕ":[200, 80, 60]},
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
        "csv":"/parallel/bible_parall.csv",
        "descr":"X-постранично c лимотом,Y - типы речи,DIM-слова"
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

    prepareData('bible_part_of_speach');
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

        var v = '<div class="third" id="legend-block">'
            +'<div class="bright">'
            +'<div class="little-box">'
            +'<h3>X(axis)</h3>'
            +'<p>'
            +xaxis
            +'</p>'
            +'</div>'
            +'<div class="little-box">'
            +'</div>'
            +'</div>'
            +'</div>'
            +'<div  class="third">'
            +'<small>'
            +'</small>'
            +'<h3>Y (axis) </h3>'
            +'<p id="legend">'
            +'</p>'
            +'</div>'
            +'<div class="third">'
            +'<h3><input type="text" id="search" placeholder=""></input></h3>'
            +'<p id="item-list">'
            +'</p>'
            +'</div>';

        $('#wrap').append(v);


       /*initParallel(item[parallId].csv,item[parallId].yaxis);*/
    }
</script>


