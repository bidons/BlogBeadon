{{ assets.outputCss('main-css') }}
{{ assets.outputJs('main-js') }}

<link rel="stylesheet" type="text/css" href="/components/select2/dist/css/select2.min.css">
<script type="text/javascript" src="/components/select2/dist/js/select2.min.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/sunburst.js"></script>
<script type="text/javascript" src="/main/js/highstockWrapper.js"></script>
<style>
    #chart-pie-word-by-section {
        min-width: 200px;
        max-width: 700px;
        margin: 0 auto
    }
</style>
<style>


    #chart-conjunction,
    #chart-introductory,
    #chart-pronoun,
    #chart-participle,
    #chart-numeral,
    #chart-noun,
    #chart-pronoun-noun,
    #chart-particles,
    #chart-infinitive,
    #chart-verb,
    #chart-pretext,
    #chart-adjective,
    #chart-impersional-verb,
    #chart-adverb,
    #chart-post-position {
        width: 400px;
        height: 400px;
    }
</style>

{{ partial('layouts/paralll') }}

<div class="container">
    <li>
        В данном разделе предметной частью будут параллельные координаты, расматривать его стоит как механизм
        визулизации данных для определения узких мест при
        анализе различных преагрегированных состояний, одним словом "паралельные координаты" в этой статье это способ
        визуализации статистических данных в виде параллельных координат
        где координаты в плоскости X,Y расположеные параллельно друг другу. Будем анализировать книгу "Библию"
        используя части речи и формо-образующие слова. Некоторые лингвисты-антропологи считают, что религия – это
        языковой вирус, который переписывает нервные окончания в мозгу, притупляет критическое мышление
        (True Detective), может получится немного приблизится к разгадке разложив книгу на книгу на морфологические
        группы.
        Заранее спасибо Javascript (D3), и ребятам которые поделились инструментами
        <a class="wrapper-blog" href="http://bl.ocks.org/syntagmatic/3150059" title="">http://bl.ocks.org/syntagmatic/3150059</a>
        и <a class="wrapper-blog" href="https://www.highcharts.com/" title="">https://www.highcharts.com/</a>
        </pre>
        </p>
    </li>
    <li>
        Для анализа будем использовать базу русского языка в количестве 140000-тысч слов частей речи и их форм
        образований.
        Библия предварительно была нормализована. Анализ проводился на точное совпадение.
        <div class="row">
            <div class="col-4">
                <pre>









140000 - cлов в арсенале
37089  - страниц в книге
593991 - слов в книге
511163 - слова попавшие в анализ
24104  - уникальных слов
                </pre>
            </div>
            <div class="col-8">
                <div id="chart-pie-part-of-speech"></div>
            </div>
        </div>
        </p>
    </li>
</div>
<div class="container-fluid">
    <div class="col">

    </div>
    <div class="col">
        <div id="chart-pie-word-by-section"></div>
    </div>
</div>
<div class="center-wrap">
    <div id="chart-pie-word-by-section"></div>
</div>

<link rel="stylesheet" type="text/css" href="/parallel/parallel.css"/>
<hr>
<div class="container">
    <h5 class="center-wrap">Параллельные координаты</h5>
    <li>
        Координаты X (агрегаты):<p>
            Поскольку время создания каждой книги в "Библии" вызывает массу споров,
            временные интервалы использовать не получится да и статистической ценности в єтом очень мало.
            В качестве осей X у нас будет лимитированное количество по 5000 тысяч страниц
            (old-старый завет, new - новый завет), в шкале количество найденых одинаковых слов,
            затемнение лининии плотность слов в координате, можно перемещатся по оси X выделяя мышкой интересующие
            фрагменты в разных плоскостях координат.
        </p>
    </li>
    <li>
        Координаты Y (категории):
        <p> Категория части речи, можно включать отключать</p>
    </li>
    <li>
        Множество DIM (слова и их формы образования)<p>
            В качестве множества используем уникальные слова, можно пользоваться поиском (вывод первых пяти, поиск
            полнотекстовый)
    </li>
</div>

<parall>
    <div id="row">
        <div class="center-wrap">
            <div id='select-parallel'></div>
        </div>
        <div id="header">
            <button title="Zoom in on selected data" id="keep-data" disabled="disabled">Приблизить</button>
            <button title="Remove selected data" id="exclude-data" disabled="disabled">Исключить</button>
            <button title="Export data as CSV" id="export-data">Export</button>
            <div class="controls">
                <strong id="rendered-count"></strong>/<strong id="selected-count"></strong>
                <div class="fillbar">
                    <div id="selected-bar">
                        <div id="rendered-bar">&nbsp;</div>
                    </div>
                </div>
                Lines at <strong id="opacity"></strong> opacity.
                <span class="settings"></span>
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

<div class="container">
    <div class="center-wrap">
        <h5>Топ двадцать слов в категориях по частоте использования</h5>
        <div id='select-parallel'></div>
    </div>
    <button id="refresh-bible-pie" onclick="renderPie()">Обновить</button>
    <select name="type" id="book-section" style="width:300" disabled=true class="form-control">
        <option value="10000">Библия</option>
    </select>
    <select name="type" id="section-type" style="width:300" class="form-control">
        <option>--Все объекты в секции--</option>
        <option value="10001">Старый завет</option>
        <option value="10002">Новый завет</option>
    </select>
    <select name="subtype" id="book" style="width:300" class="form-control">
        <option>--Все книги--</option>
    </select>
</div>
<br>

<div id="container-chart">
    <div class="row">
        <div class="col">
            <div id="chart-conjunction"></div>
        </div>
        <div class="col">
            <div id="chart-introductory"></div>
        </div>
        <div class="col">
            <div id="chart-pronoun"></div>
        </div>
    </div>
    <div class="row">
        <div class="col">
            <div id="chart-participle"></div>
        </div>
        <div class="col">
            <div id="chart-numeral"></div>
        </div>
        <div class="col">
            <div id="chart-noun"></div>
        </div>
    </div>
    <div class="row">
        <div class="col">
            <div id="chart-pronoun-noun"></div>
        </div>
        <div class="col">
            <div id="chart-particles"></div>
        </div>
        <div class="col">
            <div id="chart-infinitive"></div>
        </div>
    </div>
    <div class="row">
        <div class="col">
            <div id="chart-verb"></div>
        </div>
        <div class="col">
            <div id="chart-pretext"></div>
        </div>
        <div class="col">
            <div id="chart-adjective"></div>
        </div>
    </div>
    <div class="row">
        <div class="col">
            <div id="chart-impersional-verb"></div>
        </div>
        <div class="col">
            <div id="chart-adverb"></div>
        </div>
        <div class="col">
            <div id="chart-post-position"></div>
        </div>
    </div>
</div>

<script src="/plugins/d3/d3.min.js"></script>
<script src="/parallel/underscore.js"></script>
<script src="/parallel/parallel.js"></script>

<script>
    var dataBibleWordsPieSunBurst = [{"id": "10000", "name": "Библия", "parent": ""},
        {"id": "10001", "name": "Старый завет", "parent": "10000", 'color': '#1aadce'},
        {"id": "10002", "name": "Новый завет", "parent": "10000"},
        {"id": "10003", "name": "Каноническая", "parent": "10001"},
        {"id": "10004", "name": "Не каноническая", "parent": "10001"},
        {"id": "2", "name": "Книга Товита *", "value": 3956, "parent": "10004"},
        {"id": "6", "name": "Третья книга Маккавейская *", "value": 3932, "parent": "10004"}, {
            "id": "7",
            "name": "Первая книга Маккавейская *",
            "value": 13265,
            "parent": "10004"
        }, {
            "id": "14",
            "name": "Книга премудрости Иисуса, сына Сирахова *",
            "value": 15832,
            "parent": "10004"
        }, {"id": "15", "name": "Третья книга Ездры *", "value": 11709, "parent": "10004"}, {
            "id": "27",
            "name": "Вторая книга Ездры *",
            "value": 5789,
            "parent": "10004"
        }, {"id": "42", "name": "Вторая книга Маккавейская *", "value": 8972, "parent": "10004"}, {
            "id": "48",
            "name": "Книга Соломона *",
            "value": 5613,
            "parent": "10004"
        }, {"id": "50", "name": "Книга Варуха *", "value": 1877, "parent": "10004"}, {
            "id": "56",
            "name": "Книга Иудифи *",
            "value": 6121,
            "parent": "10004"
        }, {"id": "58", "name": "Послание Иеремии *", "value": 1025, "parent": "10004"}, {
            "id": "3",
            "name": "Бытие",
            "value": 21848,
            "parent": "10003"
        }, {"id": "4", "name": "Книга Исаии", "value": 18848, "parent": "10003"}, {
            "id": "9",
            "name": "Книга Малахии",
            "value": 1004,
            "parent": "10003"
        }, {"id": "13", "name": "Книга Ионы", "value": 793, "parent": "10003"}, {
            "id": "16",
            "name": "Второзаконие",
            "value": 16346,
            "parent": "10003"
        }, {"id": "18", "name": "Левит", "value": 12716, "parent": "10003"}, {
            "id": "19",
            "name": "Третья книга Царств",
            "value": 13101,
            "parent": "10003"
        }, {"id": "20", "name": "Книга Аввакума", "value": 804, "parent": "10003"}, {
            "id": "21",
            "name": "Книга Софонии",
            "value": 802,
            "parent": "10003"
        }, {"id": "24", "name": "Вторая книга Царств", "value": 11021, "parent": "10003"}, {
            "id": "28",
            "name": "Книга Аггея",
            "value": 598,
            "parent": "10003"
        }, {"id": "29", "name": "Книга Есфири", "value": 3099, "parent": "10003"}, {
            "id": "30",
            "name": "Книга пророка Авдия",
            "value": 345,
            "parent": "10003"
        }, {"id": "31", "name": "Первая книга Паралипоменон", "value": 9199, "parent": "10003"}, {
            "id": "32",
            "name": "Книга Иеремии",
            "value": 22888,
            "parent": "10003"
        }, {"id": "33", "name": "Первая книга Ездры", "value": 3669, "parent": "10003"}, {
            "id": "34",
            "name": "Книга Осии",
            "value": 2745,
            "parent": "10003"
        }, {"id": "36", "name": "Книга Михея", "value": 1658, "parent": "10003"}, {
            "id": "37",
            "name": "Книга Захарии",
            "value": 3317,
            "parent": "10003"
        }, {"id": "38", "name": "Книга Наума", "value": 643, "parent": "10003"}, {
            "id": "39",
            "name": "Псалтирь",
            "value": 23954,
            "parent": "10003"
        }, {"id": "40", "name": "Четвёртая книга Царств", "value": 11818, "parent": "10003"}, {
            "id": "41",
            "name": "Книга Руфи",
            "value": 1456,
            "parent": "10003"
        }, {"id": "45", "name": "Первая книга Царств", "value": 13757, "parent": "10003"}, {
            "id": "47",
            "name": "Книга Иова",
            "value": 10829,
            "parent": "10003"
        }, {"id": "51", "name": "Книга Иоиля", "value": 1060, "parent": "10003"}, {
            "id": "53",
            "name": "Книга Иезекииля",
            "value": 21310,
            "parent": "10003"
        }, {"id": "54", "name": "Песнь песней Соломона", "value": 1418, "parent": "10003"}, {
            "id": "57",
            "name": "Притчи Соломона",
            "value": 8384,
            "parent": "10003"
        }, {"id": "59", "name": "Книга Иисуса Навина", "value": 9716, "parent": "10003"}, {
            "id": "63",
            "name": "Книга Судей израилевых",
            "value": 9853,
            "parent": "10003"
        }, {"id": "64", "name": "Плач Иеремии", "value": 1866, "parent": "10003"}, {
            "id": "66",
            "name": "Книга Даниила",
            "value": 8712,
            "parent": "10003"
        }, {"id": "68", "name": "Вторая книга Паралипоменон", "value": 13615, "parent": "10003"}, {
            "id": "69",
            "name": "Книга Неемии",
            "value": 5148,
            "parent": "10003"
        }, {"id": "70", "name": "Исход", "value": 17450, "parent": "10003"}, {
            "id": "71",
            "name": "Книга Екклезиаста",
            "value": 3320,
            "parent": "10003"
        }, {"id": "76", "name": "Книга Амоса", "value": 2241, "parent": "10003"}, {
            "id": "77",
            "name": "Числа",
            "value": 16407,
            "parent": "10003"
        }, {"id": "1", "name": "Послание Иакова", "value": 1372, "parent": "10002"}, {
            "id": "5",
            "name": "3-е послание Иоанна",
            "value": 189,
            "parent": "10002"
        }, {"id": "8", "name": "Послание Иуды", "value": 342, "parent": "10002"}, {
            "id": "10",
            "name": "Послание к Филиппийцам",
            "value": 1342,
            "parent": "10002"
        }, {"id": "11", "name": "1-е послание к Тимофею", "value": 1348, "parent": "10002"}, {
            "id": "12",
            "name": "Послание к Ефесянам",
            "value": 1753,
            "parent": "10002"
        }, {"id": "17", "name": "Послание к Колоссянам", "value": 1152, "parent": "10002"}, {
            "id": "22",
            "name": "Евангелие от Иоанна",
            "value": 12046,
            "parent": "10002"
        }, {"id": "23", "name": "Послание к Евреям", "value": 3897, "parent": "10002"}, {
            "id": "25",
            "name": "Послание к Галатам",
            "value": 1816,
            "parent": "10002"
        }, {"id": "26", "name": "Послание к Филимону", "value": 309, "parent": "10002"}, {
            "id": "35",
            "name": "2-е послание к Фессалоникийцам",
            "value": 656,
            "parent": "10002"
        }, {"id": "43", "name": "Послание к Титу", "value": 528, "parent": "10002"}, {
            "id": "44",
            "name": "1-е послание Петра",
            "value": 1368,
            "parent": "10002"
        }, {"id": "46", "name": "2-е послание к Коринфянам", "value": 3640, "parent": "10002"}, {
            "id": "49",
            "name": "2-е послание к Тимофею",
            "value": 959,
            "parent": "10002"
        }, {"id": "52", "name": "Деяния святых апостолов", "value": 14157, "parent": "10002"}, {
            "id": "60",
            "name": "Евангелие от Луки",
            "value": 14930,
            "parent": "10002"
        }, {"id": "61", "name": "1-е послание к Коринфянам", "value": 5370, "parent": "10002"}, {
            "id": "62",
            "name": "Послание к Римлянам",
            "value": 5365,
            "parent": "10002"
        }, {"id": "65", "name": "2-е послание Иоанна", "value": 197, "parent": "10002"}, {
            "id": "67",
            "name": "Евангелие от Марка",
            "value": 8695,
            "parent": "10002"
        }, {"id": "72", "name": "Евангелие от Матфея", "value": 13766, "parent": "10002"}, {
            "id": "73",
            "name": "1-е послание Иоанна",
            "value": 1543,
            "parent": "10002"
        }, {"id": "74", "name": "2-е послание Петра", "value": 860, "parent": "10002"}, {
            "id": "75",
            "name": "1-е послание к Фессалоникийцам",
            "value": 1194,
            "parent": "10002"
        }, {"id": "55", "name": "Откровение Иоанна Богослова", "value": 6520, "parent": "10002"}];

    var dataBiblePartOfSpeech =
    {
        "data": [{"y": 19039, "name": "НАРЕЧИЕ"}, {
            "y": 44645,
            "name": "ПРЕДЛОГ"
        }, {"y": 32479, "name": "ЧАСТИЦА"}, {"y": 69163, "name": "ПРИЛАГАТЕЛЬНОЕ"}, {
            "y": 9792,
            "name": "ИНФИНИТИВ"
        }, {"y": 12666, "name": "МЕСТОИМ_СУЩ"}, {"y": 572, "name": "БЕЗЛИЧ_ГЛАГОЛ"}, {
            "y": 5386,
            "name": "ЧИСЛИТЕЛЬНОЕ"
        }, {"y": 138929, "name": "СУЩЕСТВИТЕЛЬНОЕ"}, {"y": 4515, "name": "ДЕЕПРИЧАСТИЕ"}, {
            "y": 256,
            "name": "ПОСЛЕЛОГ"
        }, {"y": 73970, "name": "ГЛАГОЛ"}, {"y": 709, "name": "ВВОДНОЕ"}, {"y": 47591, "name": "СОЮЗ"}, {
            "y": 51451,
            "name": "МЕСТОИМЕНИЕ"
        }], "title": "Доля частей речи", "subtitle": "Библия"
    };

    function renderPie() {
        var b = parseInt($('#book :selected').val());
        var bs = parseInt($('#section-type :selected').val());
        var s = parseInt($('#book-section :selected').val());

        if (b) {
            runRenderPercent(b);
            return;
        }
        ;
        if (bs) {
            runRenderPercent(bs);
            return;
        }
        ;
        if (s) {
            runRenderPercent(s);
            return;
        }
        ;
    }

    function runRenderPercent(book_id) {
        $.ajax({
            url: "/parall/biblepie/" + book_id,
        }).done(function (response) {
            var itt = 0;
            val = '';

            var data = JSON.parse(response).pie_word_by_part_of_speech;

            $.each(data, function (key, value) {
                var title = value.title;
                var selector;

                if (title) {
                    switch (title) {
                        case 'СОЮЗ':
                            selector = 'chart-conjunction';
                            break;
                        case 'ВВОДНОЕ':
                            selector = 'chart-introductory';
                            break;
                        case 'МЕСТОИМЕНИЕ':
                            selector = 'chart-pronoun';
                            break;
                        case 'ДЕЕПРИЧАСТИЕ':
                            selector = 'chart-participle';
                            break;
                        case 'ЧИСЛИТЕЛЬНОЕ':
                            selector = 'chart-numeral';
                            break;
                        case 'СУЩЕСТВИТЕЛЬНОЕ':
                            selector = 'chart-noun';
                            break;
                        case 'МЕСТОИМ_СУЩ':
                            selector = 'chart-pronoun-noun';
                            break;
                        case 'ЧАСТИЦА':
                            selector = 'chart-particles';
                            break;
                        case 'ИНФИНИТИВ':
                            selector = 'chart-infinitive';
                            break;
                        case 'ГЛАГОЛ':
                            selector = 'chart-verb';
                            break;
                        case 'ПРЕДЛОГ':
                            selector = 'chart-pretext';
                            break;
                        case 'ПРИЛАГАТЕЛЬНОЕ':
                            selector = 'chart-adjective';
                            break;
                        case 'БЕЗЛИЧ_ГЛАГОЛ':
                            selector = 'chart-impersional-verb';
                            break;
                        case 'НАРЕЧИЕ':
                            selector = 'chart-adverb';
                            break;
                        case 'ПОСЛЕЛОГ':
                            selector = 'chart-post-position';
                            break;
                        default:
                    }
                }
                renderPiePercent(value, selector);
            });
        })
    }
    ;
    function renderPiePercent(data, selector) {
        var total = 0, percentage, convertArray = [];

        $.each(data.data, function () {
            total += this.y;
        });

        $.each(data.data, function () {
            convertArray.push({name: this.name.toUpperCase() + ' (' + this.y + ')', y: (this.y / total * 100)});
        });

        Highcharts.chart(selector, {
            chart: {

                plotShadow: false,
                type: 'pie',
                backgroundColor: 'transparent',
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
                    size: '55%',
                    allowPointSelect: false,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        },
                        connectorColor: 'silver'

                    },
                    animation: false,
                    showInLegend: false
                }
            },
            series: [{
                name: '%',
                data: convertArray
            }]
        });
    }

    var item = {
        "bible_part_of_speech": {
            "yaxis": {
                "ЧАСТИЦА": [318, 29, 10],
                "МЕСТОИМ_СУЩ": [37, 50, 0],
                "БЕЗЛИЧ_ГЛАГОЛ": [325, 50, 39],
                "СУЩЕСТВИТЕЛЬНОЕ": [120, 56, 40],
                "СОЮЗ": [555, 55, 55],
                "ЧИСЛИТЕЛЬНОЕ": [185, 80, 45],
                "ПРИЛАГАТЕЛЬНОЕ": [300, 80, 20],
                "ВВОДНОЕ": [150, 30, 40],
                "МЕСТОИМЕНИЕ": [160, 20, 20],
                "ИНФИНИТИВ": [190, 244, 10],
                "ПРЕДЛОГ": [250, 20, 20],
                "ПОСЛЕЛОГ": [300, 80, 20],
                "ГЛАГОЛ": [185, 80, 45],
                "НАРЕЧИЕ": [240, 80, 90],
                "ДЕЕПРИЧАСТИЕ": [200, 80, 60]
            },
            "xaxis": {
                "0_5000_old": "Страницы (0-5000)",
                "5000_10000_old": "Страницы (5000-10000)",
                "10000_15000_old": "Страницы (10000-15000)",
                "15000_20000_old": "Страницы (15000-20000)",
                "20000_25000_old": "Страницы (20000-25000)",
                "25000_30000_old": "Страницы (25000-30000)",
                "30000_35000_new": "Страницы (30000-35000)",
                "35000_38546_new": "Страницы (35000-38546)",
            },
            "csv": "/parallel/bible_parall_full.csv",
            "descr": "Все категории"
        }, "bible_part_of_speech_main": {
            "yaxis": {
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
            "xaxis": {
                "0_5000_old": "Страницы (0-5000)",
                "5000_10000_old": "Страницы (5000-10000)",
                "10000_15000_old": "Страницы (10000-15000)",
                "15000_20000_old": "Страницы (15000-20000)",
                "20000_25000_old": "Страницы (20000-25000)",
                "25000_30000_old": "Страницы (25000-30000)",
                "30000_35000_new": "Страницы (30000-35000)",
                "35000_38546_new": "Страницы (35000-38546)",
            },
            "csv": "/parallel/bible_parall_main.csv",
            "descr": "Основные категории"
        }
    };

    createRadioBt();

    function createRadioBt() {
        $.each(item, function (key, value) {
            $('#select-parallel').append('<label><input type="radio" checked id = "' + key + '" name="parallel-type">' + item[key].descr + '</label>');
        });

        $("input[name=parallel-type]").on("click", function (e) {
            var parallId = ($(this).attr('id'));
            prepareData(parallId);
        });
    }
    ;

    function prepareData(parallId) {
        d3.select('#chart').selectAll('svg').remove();

        $('#chart').empty();
        $('#legend').empty();
        $('#chart').append('<canvas id="background"></canvas>  <canvas id="foreground"></canvas>  <canvas id="highlight"></canvas> <svg></svg>');
        $('#wrap').empty();

        var xaxis = '';
        $.each(item[parallId].xaxis, function (key, value) {
            xaxis = xaxis + '<strong>' + key + ' - </strong>' + value + '<br>';
        });

        var v =
                '<div class="row">'
                + '<div class="col">'
                + '<div class="third" id="legend-block">'
                + '<div class="little-box"><h3>X(axis)</h3>'
                + '<p>' + xaxis + '</p>'
                + '</div>'
                + '</div>'
                + '</div>'
                + '<div class="col">'
                + '<div class="third"><h3>Y(axis)</h3>'
                + '<p id="legend"> </p></div>'
                + '</div>'
                + '<div class="col">'
                + '<div class="third">'
                + '<h3><input type="text" id="search" placeholder=""/></h3>'
                + '<p id="item-list"></p></div>'
                + '</div>'
                + '</div>';

        $('#wrap').append(v);

        initParallel(item[parallId].csv, item[parallId].yaxis);
    }

    function renderPieSunBurst(data, selector) {
        Highcharts.chart(selector, {

            chart: {
                height: '100%',
                backgroundColor: 'transparent',
            },

            title: {
                text: 'Плотность слов в разрезе трудов'
            },
            subtitle: {
                text: 'Библия'
            },
            plotOptions: {
                series: {
                    animation: false
                }
            },
            series: [{
                type: "sunburst",
                data: data,
                allowDrillToNode: true,
                cursor: 'pointer',
                dataLabels: {
                    format: '{point.name}',
                    filter: {
                        property: 'innerArcLength',
                        operator: '>',
                        value: 0
                    }
                },
                levels: [{
                    level: 1,
                    levelIsConstant: false,

                    /*levelSize:2,*/
                    dataLabels: {
                        rotationMode: 'parallel',
                        filter: {
                            property: 'outerArcLength',
                            operator: '>',
                            value: 0
                        }
                    }
                }, {
                    level: 2,
                    colorByPoint: true,
                    dataLabels: {
                        rotationMode: 'parallel'
                    }
                },
                    {
                        level: 3,
                        colorVariation: {
                            key: 'brightness',
                            to: -0.5
                        }
                    }, {
                        level: 4,
                        colorVariation: {
                            key: 'brightness',
                            to: 0.5
                        }
                    }]

            }],
            tooltip: {
                headerFormat: "",
                pointFormat: '<b>{point.name}</b><b> ({point.value})</b>'
            }
        });
    }

    var Select2Cascade = (function (window, $) {
        function Select2Cascade(parent, child, url, select2Options) {
            var afterActions = [];
            var options = select2Options || {};

            this.then = function (callback) {
                afterActions.push(callback);
                return this;
            };

            parent.select2(select2Options).on("change", function (e) {
                child.prop("disabled", true);

                var _this = this;
                $.getJSON(url.replace(':parentId:', $(this).val()), function (items) {
                    var newOptions = '<option value="">-- Все книги --</option>';
                    for (var id in items) {
                        newOptions += '<option value="' + items[id].id + '">' + items[id].text + '</option>';
                    }

                    child.select2('destroy').html(newOptions).prop("disabled", false)
                            .select2(options);

                    afterActions.forEach(function (callback) {
                        callback(parent, child, items);
                    });
                });
            });
        }

        return Select2Cascade;
    })(window, $);

    $(document).ready(function () {

        var select2Options = {};
        var apiUrl = '/parall/book/:parentId:';

        $('select').select2(select2Options);
        var cascadLoading = new Select2Cascade($('#section-type'), $('#book'), apiUrl, select2Options);
        cascadLoading.then(function (parent, child, items) {
        });

        prepareData('bible_part_of_speech_main');

        renderPiePercent(dataBiblePartOfSpeech, 'chart-pie-part-of-speech');
        renderPieSunBurst(dataBibleWordsPieSunBurst, 'chart-pie-word-by-section');

        var flag = true
        setInterval(function () {
            if (flag) {
                runRenderPercent(10000)
                flag = false;
            }
            ;
        }, 1000);

    });

</script>



