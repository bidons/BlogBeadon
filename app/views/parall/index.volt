


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
<div class="col-md-12">
    {#<hr>#}
    <div class="col-md-4">
        <input class="search-input form-control" placeholder="Поиск">
        <div id = "bible-tree"></div>
    </div>
    <div class="col-md-8">
        <div class="center-wrap">
            <div id="container-chart">
            <div class="chart_class"> </div>
            <div class="chart_class"> </div>
            </div>
        </div>
    </div>
</div>

<script src="/parallel/d3.v2.js"></script>
<script src="/parallel/underscore.js"></script>
<script src="/parallel/parallel.js"></script>

<script>

    var bibleTree = $('#bible-tree').jstree({
        'core': {
            'data':[{"id":10000,"parent":"#","text":"Библия","total_word":511163},
                {"id":10001,"parent":"10000","text":"Ветхий завет","total_word":412369},
                {"id":10002,"parent":"10000","text":"Новый завет","total_word":98794},
                {"id":3,"parent":"10001","text":"Книга пророка Малахии","total_word":1004},
                {"id":7,"parent":"10001","text":"Книга премудрости Иисуса, сына Сирахова *","total_word":15832},
                {"id":8,"parent":"10001","text":"Второзаконие","total_word":16346},
                {"id":11,"parent":"10001","text":"Вторая книга Царств","total_word":11021},
                {"id":13,"parent":"10001","text":"Книга Есфири","total_word":3099},
                {"id":14,"parent":"10001","text":"Книга пророка Авдия","total_word":345},
                {"id":15,"parent":"10001","text":"Первая книга Паралипоменон","total_word":9199},
                {"id":16,"parent":"10001","text":"Книга пророка Иеремии","total_word":22888},
                {"id":18,"parent":"10001","text":"Псалтирь","total_word":23954},
                {"id":19,"parent":"10001","text":"Книга Руфи","total_word":1456},
                {"id":23,"parent":"10001","text":"Книга премудрости Соломона *","total_word":5613},
                {"id":25,"parent":"10001","text":"Книга пророка Иезекииля","total_word":21310},
                {"id":26,"parent":"10001","text":"Песнь песней Соломона","total_word":1418},
                {"id":27,"parent":"10001","text":"Откровение святого Иоанна Богослова (Апокалипсис)","total_word":6520},
                {"id":28,"parent":"10001","text":"Книга Иисуса Навина","total_word":9716},
                {"id":32,"parent":"10001","text":"Плач Иеремии","total_word":1866},
                {"id":33,"parent":"10001","text":"Книга пророка Даниила","total_word":8712},
                {"id":35,"parent":"10001","text":"Вторая книга Паралипоменон","total_word":13615},
                {"id":36,"parent":"10001","text":"Книга Неемии","total_word":5148},
                {"id":37,"parent":"10001","text":"Исход","total_word":17450},
                {"id":38,"parent":"10001","text":"Книга Екклезиаста, или Проповедника","total_word":3320},
                {"id":41,"parent":"10001","text":"Книга пророка Амоса","total_word":2241},
                {"id":42,"parent":"10001","text":"Книга Товита *","total_word":3956},
                {"id":43,"parent":"10001","text":"Бытие","total_word":21848},
                {"id":44,"parent":"10001","text":"Книга пророка Исаии","total_word":18848},
                {"id":45,"parent":"10001","text":"Третья книга Маккавейская *","total_word":3932},
                {"id":46,"parent":"10001","text":"Первая книга Маккавейская *","total_word":13265},
                {"id":48,"parent":"10001","text":"Книга пророка Ионы","total_word":793},
                {"id":49,"parent":"10001","text":"Третья книга Ездры *","total_word":11709},
                {"id":50,"parent":"10001","text":"Левит","total_word":12716},
                {"id":51,"parent":"10001","text":"Третья книга Царств","total_word":13101},
                {"id":52,"parent":"10001","text":"Книга пророка Аввакума","total_word":804},
                {"id":53,"parent":"10001","text":"Книга пророка Софонии","total_word":802},
                {"id":56,"parent":"10001","text":"Книга пророка Аггея","total_word":598},
                {"id":57,"parent":"10001","text":"Вторая книга Ездры *","total_word":5789},
                {"id":58,"parent":"10001","text":"Первая книга Ездры","total_word":3669},
                {"id":59,"parent":"10001","text":"Книга пророка Осии","total_word":2745},
                {"id":60,"parent":"10001","text":"Книга пророка Михея","total_word":1658},
                {"id":61,"parent":"10001","text":"Книга пророка Захарии","total_word":3317},
                {"id":62,"parent":"10001","text":"Книга пророка Наума","total_word":643},
                {"id":63,"parent":"10001","text":"Четвёртая книга Царств","total_word":11818},
                {"id":64,"parent":"10001","text":"Вторая книга Маккавейская *","total_word":8972},
                {"id":65,"parent":"10001","text":"Первая книга Царств","total_word":13757},
                {"id":66,"parent":"10001","text":"Книга Иова","total_word":10829},
                {"id":67,"parent":"10001","text":"Книга пророка Варуха *","total_word":1877},
                {"id":68,"parent":"10001","text":"Книга пророка Иоиля","total_word":1060},
                {"id":70,"parent":"10001","text":"Книга Иудифи *","total_word":6121},
                {"id":71,"parent":"10001","text":"Притчи Соломона","total_word":8384},
                {"id":72,"parent":"10001","text":"Послание Иеремии *","total_word":1025},
                {"id":73,"parent":"10001","text":"Книга Судей израилевых","total_word":9853},
                {"id":77,"parent":"10001","text":"Числа","total_word":16407},
                {"id":1,"parent":"10002","text":"Послание Иакова","total_word":1372},
                {"id":2,"parent":"10002","text":"3-е послание Иоанна","total_word":189},
                {"id":4,"parent":"10002","text":"Послание к Филиппийцам","total_word":1342},
                {"id":5,"parent":"10002","text":"1-е послание к Тимофею","total_word":1348},
                {"id":6,"parent":"10002","text":"Послание к Ефесянам","total_word":1753},
                {"id":9,"parent":"10002","text":"Послание к Колоссянам","total_word":1152},
                {"id":10,"parent":"10002","text":"Послание к Евреям","total_word":3897},
                {"id":12,"parent":"10002","text":"Послание к Галатам","total_word":1816},
                {"id":17,"parent":"10002","text":"2-е послание к Фессалоникийцам","total_word":656},
                {"id":20,"parent":"10002","text":"Послание к Титу","total_word":528},
                {"id":21,"parent":"10002","text":"1-е послание Петра","total_word":1368},
                {"id":22,"parent":"10002","text":"2-е послание к Коринфянам","total_word":3640},
                {"id":24,"parent":"10002","text":"2-е послание к Тимофею","total_word":959},
                {"id":29,"parent":"10002","text":"Евангелие от Луки","total_word":14930},
                {"id":30,"parent":"10002","text":"1-е послание к Коринфянам","total_word":5370},
                {"id":31,"parent":"10002","text":"Послание к Римлянам","total_word":5365},
                {"id":34,"parent":"10002","text":"Евангелие от Марка","total_word":8695},
                {"id":39,"parent":"10002","text":"Евангелие от Матфея","total_word":13766},
                {"id":40,"parent":"10002","text":"1-е послание Иоанна","total_word":1543},
                {"id":47,"parent":"10002","text":"Послание Иуды","total_word":342},
                {"id":54,"parent":"10002","text":"Евангелие от Иоанна","total_word":12046},
                {"id":55,"parent":"10002","text":"Послание к Филимону","total_word":309},
                {"id":69,"parent":"10002","text":"Деяния святых апостолов","total_word":14157},
                {"id":74,"parent":"10002","text":"2-е послание Иоанна","total_word":197},
                {"id":75,"parent":"10002","text":"2-е послание Петра","total_word":860},
                {"id":76,"parent":"10002","text":"1-е послание к Фессалоникийцам","total_word":1194}]
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

    bibleTree.bind('ready.jstree', function(e, data) {
        $(this).jstree('open_all');
        $(this).jstree(true).select_node(10000);
        node = ($(this).jstree(true).get_node('10000')).original;
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

   /* prepareData('bible_part_of_speach');*/
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

        console.log(v);
       initParallel(item[parallId].csv,item[parallId].yaxis);
    }
</script>


