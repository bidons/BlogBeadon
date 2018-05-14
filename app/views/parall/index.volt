{{ assets.outputCss('blog-css') }}
{{ assets.outputJs('blog-js') }}

<h2 class="center-wrap">
    <h2 class="center-wrap">Параллельные координаты</h2>
</h2>

<div class="container">
    <div class="row">
        <div class="col-md-4">
            <div class="text-center">
                <img class="rounded-circle" src="/main/img/super_book.jpg" width="370" height="300">
            </div>
        </div>
        <div class="entry-content"></div>
        <div class="post-series-content">
            <ol>
                <li><a class="wrapper-blog" href="/parall/index" title="Параллельные кординаты">Введение
              {#          (введение)</a></li>
                <li><a class="wrapper-blog" #}{#href="/objectdb/part1" #}{#title="Практическое применение">Практическое
                        применение</a></li>
                <li><a class="wrapper-blog" #}{#href="/objectdb/part2" #}{#title="GIN(ts-vector)">GIN(ts-vector)</a></li>
                <li><a class="wrapper-blog" #}{#href="/objectdb/part2" #}{#title="GIN(ts-vector)">Примеры</a></li>#}
                    </a>
                </li>
            </ol>
        </div>
    </div>
    <hr>
    <li>
           В данном разделе предметной частью будут параллельные координаты, расматривать его стоит как механизм визулизации данных для определения узких мест при
           анализе различных преагрегированных состояний, одним словом "паралельные координаты" в этой статье это способ визуализации статистических данных в виде параллельных координат
           где координаты в плоскости X,Y расположеные параллельно друг другу. Будем анализировать книгу "Библию"
           используя части речи и формо-образующие слова. Некоторые лингвисты-антропологи считают, что религия – это языковой вирус, который переписывает нервные окончания в мозгу, притупляет критическое мышление
              (True Detective), может получится немного приблизится к разгадке разложив книгу на книгу на морфологические группы
          </pre>
        </p>
    </li>
    <li>
        Для анализа будем использовать базу русского языка в количестве 140000-тысч слов частей речи и их форм образований.
        Библия предварительно было нормализовано. Анализ проводился на точное совпадение.
        <pre>Что мы имеем:
             140000 - cлов в арсенале
             37089  - старниц в книге
             593991 - слов в книге
             511163 - слова попавшие в анализ
             23636  - тысяч уникальных слов (форм образований)
        </pre>
            </p>
    </li>
    <li>
        Координаты X (агрегаты):<p>
            Поскольку время создания каждой книги вызывает массу споров,
            временные интервалы использовать не получится да и статистической ценности в єтом очень мало.
            В качестве осей X у нас будет лимитированное количество по 5000 тысяч страниц
            (префиксы: old-старый завет, new - новый завет), в шкале количество найденых одинаковых слов и их
            количество, затемнение лининии плотность слов в категории, можно перемещатся по оси X выделяя мышкой интересующие фрагменты в разных плоскостях координат.
        </p>
    </li>
    <li>
        Координаты Y (категории):
        <p> Категория части речи, можно включать отключать</p>
    </li>
    <li>
        Множество DIM (слова и их формы образования)<p>
            В качестве множества используем уникальные слова, можно пользоваться поиском (вывод первых пять, поиск
            полнотекстовый)
    </li>
    <li>
        Ниже пироги, топ 20-ацать слов в категории по частоте использования, можно перемещатся по дереву (* - не
        каноническая), и смотреть результат в каждой из секций.
        Заранее спасибо Javascript (D3), и ребятам которые поделились инструментами
        <a class="wrapper-blog" href="http://bl.ocks.org/syntagmatic/3150059" title="">Parallel (D3)</a>
        И вот єтим <a class="wrapper-blog" href="https://www.highcharts.com/" title="">HighCharts</a>;
    </li>
</div>

<link rel="stylesheet" type="text/css" href="/parallel/parallel.css"/>
<hr>
<parall>
    <div id="row">
        <div class="center-wrap">
            <h5>Параллельные координаты</h5>
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
        <h5>Топ 20-ацать слов в категории по частоте использования</h5>
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
</div>

<script src="/parallel/d3.v2.js"></script>
<script src="/parallel/underscore.js"></script>
<script src="/parallel/parallel.js"></script>

<script>
    function renderPie() {
        var b = parseInt($('#book :selected').val());
        var bs = parseInt($('#section-type :selected').val());
        var s = parseInt($('#book-section :selected').val());

        if (b) {
            runRenderPercent(b);
            return;
        };
        if (bs) {
            runRenderPercent(bs);
            return;
        };
        if (s) {
            runRenderPercent(s);
            return;
        };
    }
    function runRenderPercent(book_id) {
        $("#container-chart").empty();
        $.ajax({
            url: "/parall/biblepie/" + book_id,
        }).done(function (response) {
            /*response = JSON.parse(response);*/
            var itt =0;
            val = '';
            $.each(JSON.parse(response), function (key, value) {
                if (key == 'pie_word_by_part_of_speech') {
                    $.each(value, function (key, value2) {
                        itt++;
                        if (itt & 1) {
                            val = value2;
                        }
                        else {
                            var fr = 'pie_word_by_part_of_speech_' + (itt - 1);
                            var tw = 'pie_word_by_part_of_speech_' + (itt);

                            console.log(itt);
                            $("#container-chart").append('<div class="row"><div class="col"><div id="' + fr + '"></div></div><div class="col"><div id="' + tw + '"></div></div></div>');

                            renderPiePercent(val, fr);
                            renderPiePercent(value2, tw);
                        }
                    });
                }
                else {
                    itt++;

                    console.log(value);
                    val = value;
                 }
            });
        })
    };
    function renderPiePercent(data, selector) {
        var total = 0, percentage, convertArray = [];

        $.each(data.data, function () {
            total += this.y;
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
                    size: '70%',
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
                "0_5000_old": "Страницы (0-5000) старый завет",
                "5000_10000_old": "Страницы (5000-10000) старый завет",
                "10000_15000_old": "Страницы (10000-15000) старый завет",
                "15000_20000_old": "Страницы (15000-20000) старый завет",
                "20000_25000_old": "Страницы (20000-25000) старый завет",
                "25000_30000_old": "Страницы (25000-30000) старый завет",
                "30000_35000_new": "Страницы (30000-35000) новый завет",
                "35000_38546_new": "Страницы (35000-38546) новый завет",
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
                "0_5000_old": "Страницы (0-5000) старый завет",
                "5000_10000_old": "Страницы (5000-10000) старый завет",
                "10000_15000_old": "Страницы (10000-15000) старый завет",
                "15000_20000_old": "Страницы (15000-20000) старый завет",
                "20000_25000_old": "Страницы (20000-25000) старый завет",
                "25000_30000_old": "Страницы (25000-30000) старый завет",
                "30000_35000_new": "Страницы (30000-35000) новый завет",
                "35000_38546_new": "Страницы (35000-38546) новый завет",
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
    };

    prepareData('bible_part_of_speech_main');

    function prepareData(parallId) {
        d3.select('#chart').selectAll('svg').remove();
        d3.select("svg").empty();

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
                + '<div class="col-sm">'
                + '<div class="third" id="legend-block">'
                + '<div class="little-box"><h3>X(axis)</h3>'
                + '<p>' + xaxis + '</p>'
                + '</div>'
                + '</div>'
                + '</div>'
                + '<div class="col-sm">'
                + '<div class="third"><h3>Y(axis)</h3>'
                + '<p id="legend"> </p></div>'
                + '</div>'
                + '<div class="col-sm">'
                + '<div class="third">'
                + '<h3><input type="text" id="search" placeholder=""/></h3>'
                + '<p id="item-list"></p></div>'
                + '</div>'
                + '</div>';

        $('#wrap').append(v);

        initParallel(item[parallId].csv, item[parallId].yaxis);
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

        runRenderPercent(10000);
    });
</script>



