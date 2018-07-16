{{ assets.outputCss('main-css') }}
<link rel="stylesheet" type="text/css" href="/components/select2/dist/css/select2.css">
{#<link rel="stylesheet" type="text/css" href="/plugins/select2/select2-bootstrap4.min.css">#}
<link rel="stylesheet" type="text/css" href="/components/bootstrap-daterangepicker/daterangepicker.css">
<link rel="stylesheet" type="text/css" href="/comonents/datatable/media/css/dataTables.bootstrap4.min.css">
<link type="text/css" rel="stylesheet" href="/parallel/d3.relationshipgraph.min.css">
{{ assets.outputJs('main-js') }}

<script type="text/javascript" src="/components/select2/dist/js/select2.min.js"></script>
<script type="text/javascript" src="/components/bootstrap/dist/js/bootstrap.min.js"></script>

<script type="text/javascript" src="/components/moment/moment.js"></script>
<script type="text/javascript" src="/components/bootstrap-daterangepicker/daterangepicker.js"></script>
<script type="text/javascript" src="/components/highcharts/highstock.js"></script>
<script type="text/javascript" src="/main/js/highstockWrapper.js"></script>
<script type="text/javascript" src="/components/datatable/media/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="/components/datatable/media/js/dataTables.bootstrap4.min.js"></script>

<script type="text/javascript" src="/main/js/highstockWrapper.js"></script>
<script src="/components/proj4/dist/proj4.js"></script>
<script type="text/javascript" src="/components/highcharts/modules/map.js"></script>
<script src="//code.highcharts.com/mapdata/countries/ua/ua-all.js"></script>

{#<script src="/components/d3/d3.js"></script>#}
<script src="https://d3js.org/d3.v4.min.js" charset="utf-8"></script>
<script src="/parallel/d3.relationshipgraph.js"></script>

{{ partial('layouts/olapl') }}

<style>
    th { font-size: 12px; }
    td { font-size: 12px; }

    .relationshipGraph-tip {
        font-weight: 700;
        font-family: Helvetica, sans-serif;
        font-size: 9pt;
        line-height: 1;
        padding: 12px;
        background: #FFFFFF;
        color: #e7e7e7;
        border-radius: 6px;
        z-index: 50;
        max-width: 350px;
        max-height: 300px
    }

</style>

<div class="container">

    <li> Цель материала показать принципы построения OLAP кубов с реляционными примерами. Материал будет интересен
        в первую очередь людям которые захотят "связать свою жизнь" c
        <a class="wrapper-blog" href="https://ru.wikipedia.org/wiki/Business_Intelligence" title="">
            Business Intelligence
        </a>
    </li>
    <li>
        Все реляционные базы данных без исключения призваны по своей сути составить отношение-связь между объектами,
        что позволяет получить связанность объектов и контролировать консистентность и целостность данных.
        Для статистического анализа реляционный подход не совсем подходит,
        возникают сложности с выборками, скоростью и анализом, реляционная алгебра очевидна для архитектора баз данных,
        но не для человека который работает с статистическими данными,
        отсюда появилась необходимость создавать сущности которые содержать преагрегированное состояние для быстрой выборки и анализа и сама концепция OLAP.
    </li>
    <li>
        Вики статья:
        <a class="wrapper-blog" href="https://ru.wikipedia.org/wiki/OLAP" title="">
            OLAP (англ. online analytical processing, интерактивная аналитическая обработка) — технология обработки данных, заключающаяся в подготовке суммарной (агрегированной) информации на основе больших массивов данных, структурированных по многомерному принципу</a>
        </p>
    </li>

    <div class="col-12 center-wrap">
<pre>И так что мы имеем:
1) Измерения (Категории и справочники категорий)
</pre>

                <div id="graph"></div>
<pre>2) Измерения (время, дни, 2016-11-29 - 2018-05-03)
3) агрегат (событие №1)
4) агрегат (событие №2)
5) агрегат (событие №3)</pre>

</div>
    <div class="center-wrap">
        <div style="margin-bottom:16px">
            <div class="table-info" style="margin-bottom:16px"></div></div>
    </div>

    <div class="center-wrap">
        <div class="btn-group text-center">
            <button type="button" style ="width: 250px" class="btn btn" style="width:300"  id="refresh-charts">Обновить</button>
            <input type="text" class="form-control input-sm active"  style="width:300"  type="text" data-filter-cond="interval" placeholder="Time...">
        </div>
    </div>

    </br>
    <div class="center-wrap">
        <div class="btn-group text-center">
            <select class="form-control" id="section-agg">
                {#<option value="total">Событие №1 (агрегат)   </option>#}
                <option value="event_1">Событие №1 (агрегат) </option>
                <option value="event_2">Событие №2 (агрегат) </option>
                <option value="event_3">Событие №3 (агрегат) </option>
            </select>

            <select id="section-type" class="form-control">
                <option value="4">Ремёсла (тип)</option>
                <option value="8">Образование</option>
                <option value="1">Ремёсла (состояние)</option>
                <option value="6">Ремёсла (сотрудники)</option>
                <option value="5">Образование (детализация)</option>
                <option value="7">Имущество</option>
                <option value="10">Cемейное положение</option>
                <option value="11">Пол</option>
                {#<option value="2">Тел. операторы</option>#}
                <option value="9">Регионы</option>
            </select>
        </div>
    </div>
</div>

<div class="container center-wrap">
    <select name="type" id="section-value" class="form-control"> </select>
</div>
<div class="container-fluid">
    <br>
    <br>
    <br>
    <br>
    <div class="col-12">
        <div id="pie-chart" style="min-width: 400px; height: 750px; max-width: 1500px; margin: 0 auto"></div>
    </div>
    <div class="col-12">
        <div id="line-chart" style="min-width: 600px; height: 750px; max-width: 1500px; margin: 0 auto"></div>
    </div>
    <div class="col-12">
        <div id="data-table"></div>
    </div>
    <div class="col-12">
        <div id="geo-chart" style="min-width: 600px; height: 750px; max-width: 1500px; margin: 0 auto"></div>
    </div>
</div>
<br>
<script>
    $(document).ready(function () {
        var json1 = [{"Категория измерения:" : "Безработный", "parent" : "Ремёсла (состояние)", "value" : 7796}, {"Категория измерения:" : "Неполная занятость", "parent" : "Ремёсла (состояние)", "value" : 12500}, {"Категория измерения:" : "Полная занятость", "parent" : "Ремёсла (состояние)", "value" : 88361}, {"Категория измерения:" : "Студент", "parent" : "Ремёсла (состояние)", "value" : 6675}, {"Категория измерения:" : "Самозанятость", "parent" : "Ремёсла (состояние)", "value" : 16454}, {"Категория измерения:" : "Не определено", "parent" : "Ремёсла (состояние)", "value" : 64079}, {"Категория измерения:" : "Пенсионер", "parent" : "Ремёсла (состояние)", "value" : 3963},
            /*{"Категория измерения:" : "Киевстар (Beeline +38068)", "parent" : "Тел. операторы", "value" : 19942}, {"Категория измерения:" : "life(+38063)", "parent" : "Тел. операторы", "value" : 18900},
            {"Категория измерения:" : "Не определено", "parent" : "Тел. операторы", "value" : 327},
            {"Категория измерения:" : "МТС(+38099)", "parent" : "Тел. операторы", "value" : 18317},
            {"Категория измерения:" : "МТС(+38095)", "parent" : "Тел. операторы", "value" : 18540},
            {"Категория измерения:" : "life(+38073)", "parent" : "Тел. операторы", "value" : 8216},
            {"Категория измерения:" : "МТС(+38066)", "parent" : "Тел. операторы", "value" : 20531},
            {"Категория измерения:" : "life(+38093)", "parent" : "Тел. операторы", "value" : 15454},
            {"Категория измерения:" : "PEOPLEnet(+38092)", "parent" : "Тел. операторы", "value" : 1},
            {"Категория измерения:" : "МТС(+38050)", "parent" : "Тел. операторы", "value" : 15112},
            {"Категория измерения:" : "Utel(+38091)", "parent" : "Тел. операторы", "value" : 62},
            {"Категория измерения:" : "Интертелеком(+38094)", "parent" : "Тел. операторы", "value" : 89},
            {"Категория измерения:" : "Киевстар(+38067)", "parent" : "Тел. операторы", "value" : 12280},
            {"Категория измерения:" : "Киевстар(+38096)", "parent" : "Тел. операторы", "value" : 17259},
            {"Категория измерения:" : "Киевстар(+38097)", "parent" : "Тел. операторы", "value" : 17749},
            {"Категория измерения:" : "Киевстар(+38098)", "parent" : "Тел. операторы", "value" : 17049},*/
            {"Категория измерения:" : "Прядильное", "parent" : "Ремёсла (тип)", "value" : 19272},
            {"Категория измерения:" : "Не определено", "parent" : "Ремёсла (тип)", "value" : 82514},
            {"Категория измерения:" : "Кожевенное", "parent" : "Ремёсла (тип)", "value" : 2183},
            {"Категория измерения:" : "Ювелирное", "parent" : "Ремёсла (тип)", "value" : 7403},
            {"Категория измерения:" : "Печное", "parent" : "Ремёсла (тип)", "value" : 28760},
            {"Категория измерения:" : "Cапожное", "parent" : "Ремёсла (тип)", "value" : 13167},
            {"Категория измерения:" : "Пекарное", "parent" : "Ремёсла (тип)", "value" : 1311},
            {"Категория измерения:" : "Скорняжное", "parent" : "Ремёсла (тип)", "value" : 18907},
            {"Категория измерения:" : "Ткацкое", "parent" : "Ремёсла (тип)", "value" : 3382},
            {"Категория измерения:" : "Портняжное дело", "parent" : "Ремёсла (тип)", "value" : 3230}, {"Категория измерения:" : "Столярное ремесло", "parent" : "Ремёсла (тип)", "value" : 1753}, {"Категория измерения:" : "Плотницкое дело", "parent" : "Ремёсла (тип)", "value" : 3950}, {"Категория измерения:" : "Гончарное производство", "parent" : "Ремёсла (тип)", "value" : 7082}, {"Категория измерения:" : "Кузнечное дело", "parent" : "Ремёсла (тип)", "value" : 6914}, {"Категория измерения:" : "Другой", "parent" : "Образование (детализация)", "value" : 5423}, {"Категория измерения:" : "Точные науки", "parent" : "Образование (детализация)", "value" : 1813}, {"Категория измерения:" : "Не определено", "parent" : "Образование (детализация)", "value" : 147523}, {"Категория измерения:" : "Строительство", "parent" : "Образование (детализация)", "value" : 2145}, {"Категория измерения:" : "Экономика и предпринимательство", "parent" : "Образование (детализация)", "value" : 14250}, {"Категория измерения:" : "Пищевая и легкая промышленность", "parent" : "Образование (детализация)", "value" : 1755}, {"Категория измерения:" : "Технические науки", "parent" : "Образование (детализация)", "value" : 9719}, {"Категория измерения:" : "Природоведческие науки", "parent" : "Образование (детализация)", "value" : 1383}, {"Категория измерения:" : "Гуманитарные науки", "parent" : "Образование (детализация)", "value" : 6603}, {"Категория измерения:" : "Медицина", "parent" : "Образование (детализация)", "value" : 2055}, {"Категория измерения:" : "Право", "parent" : "Образование (детализация)", "value" : 5760}, {"Категория измерения:" : "Военное дело", "parent" : "Образование (детализация)", "value" : 1399}, {"Категория измерения:" : "50-100 человек", "parent" : "Ремёсла (сотрудники)", "value" : 13388}, {"Категория измерения:" : "Не определено", "parent" : "Ремёсла (сотрудники)", "value" : 82521}, {"Категория измерения:" : "до 5-ти человек", "parent" : "Ремёсла (сотрудники)", "value" : 28871}, {"Категория измерения:" : "20-50 человек", "parent" : "Ремёсла (сотрудники)", "value" : 14758}, {"Категория измерения:" : "Більше 500 человек", "parent" : "Ремёсла (сотрудники)", "value" : 22947}, {"Категория измерения:" : "5-20 человек", "parent" : "Ремёсла (сотрудники)", "value" : 21989}, {"Категория измерения:" : "100-500 человек", "parent" : "Ремёсла (сотрудники)", "value" : 15354}, {"Категория измерения:" : "Депозити", "parent" : "Имущество", "value" : 1777}, {"Категория измерения:" : "Ценные бумаги", "parent" : "Имущество", "value" : 1074}, {"Категория измерения:" : "Несколько видов имущества", "parent" : "Имущество", "value" : 6936}, {"Категория измерения:" : "Не определено", "parent" : "Имущество", "value" : 64079}, {"Категория измерения:" : "Недвижимое имущество (будинок, квартира итд)", "parent" : "Имущество", "value" : 61206}, {"Категория измерения:" : "Движимое имущество (авто, катер итд)", "parent" : "Имущество", "value" : 9226}, {"Категория измерения:" : "Отсутствует", "parent" : "Имущество", "value" : 55530}, {"Категория измерения:" : "Среднее специальное", "parent" : "Образование", "value" : 56956}, {"Категория измерения:" : "Научная степень", "parent" : "Образование", "value" : 301}, {"Категория измерения:" : "Не полное высшее", "parent" : "Образование", "value" : 18483}, {"Категория измерения:" : "Неполное среднее", "parent" : "Образование", "value" : 2503}, {"Категория измерения:" : "Два или более (высших)", "parent" : "Образование", "value" : 1406}, {"Категория измерения:" : "Не определено", "parent" : "Образование", "value" : 64079}, {"Категория измерения:" : "Высшее", "parent" : "Образование", "value" : 23983}, {"Категория измерения:" : "Среднее", "parent" : "Образование", "value" : 32117}, {"Категория измерения:" : "Сумская", "parent" : "Регионы", "value" : 4382}, {"Категория измерения:" : "Житомирская", "parent" : "Регионы", "value" : 4132}, {"Категория измерения:" : "Донецкая", "parent" : "Регионы", "value" : 5992}, {"Категория измерения:" : "Днепропетровская", "parent" : "Регионы", "value" : 19767}, {"Категория измерения:" : "Волынская", "parent" : "Регионы", "value" : 2574}, {"Категория измерения:" : "Винницкая", "parent" : "Регионы", "value" : 4398}, {"Категория измерения:" : "Севастополь", "parent" : "Регионы", "value" : 13}, {"Категория измерения:" : "Ровенская", "parent" : "Регионы", "value" : 2846}, {"Категория измерения:" : "Республика Крым", "parent" : "Регионы", "value" : 98}, {"Категория измерения:" : "Тернопольская", "parent" : "Регионы", "value" : 1436}, {"Категория измерения:" : "Полтавская", "parent" : "Регионы", "value" : 6109}, {"Категория измерения:" : "Харьковская", "parent" : "Регионы", "value" : 8808}, {"Категория измерения:" : "Херсонская", "parent" : "Регионы", "value" : 4972}, {"Категория измерения:" : "Хмельницкая", "parent" : "Регионы", "value" : 3702}, {"Категория измерения:" : "Одесская", "parent" : "Регионы", "value" : 7558}, {"Категория измерения:" : "Черкасская", "parent" : "Регионы", "value" : 4548}, {"Категория измерения:" : "Черниговская", "parent" : "Регионы", "value" : 3663}, {"Категория измерения:" : "Черновицкая", "parent" : "Регионы", "value" : 2019}, {"Категория измерения:" : "Николаевская", "parent" : "Регионы", "value" : 5490}, {"Категория измерения:" : "Львовская", "parent" : "Регионы", "value" : 5511}, {"Категория измерения:" : "Луганская", "parent" : "Регионы", "value" : 1774}, {"Категория измерения:" : "Кировоградская", "parent" : "Регионы", "value" : 4744}, {"Категория измерения:" : "Не определено", "parent" : "Регионы", "value" : 64080}, {"Категория измерения:" : "Киевская", "parent" : "Регионы", "value" : 8287}, {"Категория измерения:" : "Киев", "parent" : "Регионы", "value" : 9714}, {"Категория измерения:" : "Ивано-Франковская", "parent" : "Регионы", "value" : 2445}, {"Категория измерения:" : "Запорожская", "parent" : "Регионы", "value" : 8633}, {"Категория измерения:" : "Закарпатская", "parent" : "Регионы", "value" : 2133}, {"Категория измерения:" : "Разведен/Разведена", "parent" : "Cемейное положение", "value" : 12143}, {"Категория измерения:" : "Не определено", "parent" : "Cемейное положение", "value" : 64079}, {"Категория измерения:" : "Замужем/Женат", "parent" : "Cемейное положение", "value" : 41903}, {"Категория измерения:" : "В гражданском браке", "parent" : "Cемейное положение", "value" : 13343}, {"Категория измерения:" : "Вдовец/Вдова", "parent" : "Cемейное положение", "value" : 2078}, {"Категория измерения:" : "Не замужем/Не женат", "parent" : "Cемейное положение", "value" : 66282}, {"Категория измерения:" : "Женщина", "parent" : "Пол", "value" : 66601}, {"Категория измерения:" : "Мужчина", "parent" : "Пол", "value" : 105341}, {"Категория измерения:" : "Не определено", "parent" : "Пол", "value" : 27886}];

        var graph = d3.select('#graph').relationshipGraph({
            'maxChildCount': 28,
            'thresholds': [-1,1,0],
            showTooltips: true
        });

        graph.data(json1);

        var interval = null;

        $('[data-filter-cond=interval]').daterangepicker({
            minDate:"2016.11.29",
            maxDate:"2018.05.03",
            defaultDate: null,
            autoUpdateInput: false,
          /*  defaultDate: [moment().format('YYYY.MM.DD'), today],*/
            locale: {
                format: "YYYY.MM.DD",
                applyLabel: "Применить",
                "cancelLabel": "Отмена",
                customRangeLabel: "Выбрать интервалы",
                "daysOfWeek": [
                    "Вс",
                    "Пн",
                    "Вт",
                    "Ср",
                    "Чт",
                    "Пт",
                    "Сб"
                ],
                "monthNames": [
                    "Январь",
                    "Февраль",
                    "Март",
                    "Апрель",
                    "Май",
                    "Июнь",
                    "Июль",
                    "Август",
                    "Сентябрь",
                    "Октябрь",
                    "Ноябрь",
                    "Декабрь"
                ],
            },
            /*autoUpdateInput: true,*/
            /*ranges: {
                'Сегодня': [moment(), moment().add(1, 'days')],
                'Вчера': [moment().subtract(1, 'days'), moment()],
                'За последние 7-емь дней': [moment().subtract(6, 'days'), moment().add(1, 'days')],
                'За последние 30-ать дней': [moment().subtract(29, 'days'), moment().add(1, 'days')],
                'Текущий месяц': [moment().startOf('month'), moment().endOf('month').add(1, 'days')],
                'Прошлый месяц': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month').add(1, 'days')]
            }*/
        });

        $('[data-filter-cond=interval]').val('2016-05-01' + ' - ' + '2017-04-01');

        $('#refresh-charts').on('click', function () {
            renderData();
        });

        $('[data-filter-cond=interval]').on('apply.daterangepicker', function (ev, picker) {
            console.log(123123);
            $(this).val(picker.startDate.format('YYYY.MM.DD') + ' - ' + picker.endDate.format('YYYY.MM.DD'));
            renderData();
        });

        $("#section-agg").select2({}
        ).on("select2:select", function (e) {
            renderData();
        });

        $("#section-type").select2({}
        ).on("select2:select", function (e) {
            getSectionValue();
        });

        getSectionValue();

        function getSectionValue() {
            $('#section-value').empty();
            $.ajax({
                type: "POST",
                url: "/olap/profcategory/" + $('#section-type').val(),
            }).done(function (data) {
                $('#section-value').select2({
                    data: JSON.parse(data),
                    multiple: "multiple",
                    dropdownAutoWidth: true
                });

                $("#section-value > option").prop("selected", "selected");
                $("#section-value").trigger("change");

                renderData();
            });
        };

        function renderData() {
            queryArr = [];

            $('.table-info').empty();
            $('#line-chart').empty();
            $('#geo-chart').empty();
            $('#pie-chart').empty();
            $('#data-table').empty();

            renderPie();
        }

        var queryArr = [];
        function renderPie() {
            $.ajax({
                type: "GET",
                url: "/olap/piechart",
                data: {
                    'value': $('#section-value').val(),
                    'interval': $('[data-filter-cond=interval]').val(),
                    'type_id': $('#section-type').val(),
                    'agg': $('#section-agg').val()
                }
            }).done(function (data) {

                $('.table-info').append('<span class="badge badge-secondary" id="pie-info" data-toggle="modal"  data-target="#modalDynamicInfo">Пирог:' + data.time + '</span>');
                queryArr.push(data.query);
                var total = 0, percentage, convertArray = [];

                $.each(data.data, function () {
                    total += this.y;
                });

                $.each(data.data, function () {
                    convertArray.push({name: this.name + ' (' + this.y + ')', y: (this.y / total * 100)});
                });

                Highcharts.chart('pie-chart', {
                    chart: {
                        plotShadow: false,
                        type: 'pie',
                        backgroundColor: 'transparent',
                    },
                    title: {
                        text: $('#section-agg').select2('data')[0].text
                    },
                    subtitle: {
                        text: 'Общее количество: ' + total
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
                            showInLegend: true
                        }
                    },
                    series: [{
                        name: '%',
                        data: convertArray
                    }]
                });
                renderGeo();
            });
        };
        function renderGeo() {
            if ($('#section-type').val() == 9) {
                renderLine();
            } else {
                $.ajax({
                    url: "/olap/geochart",
                    data: {
                        'value': $('#section-value').val(),
                        'interval': $('[data-filter-cond=interval]').val(),
                        'type_id': $('#section-type').val(),
                        'agg': $('#section-agg').val()
                    }
                }).done(function (data) {

                    $('.table-info').append('<span class="badge badge-secondary" id="geo-info" data-toggle="modal"  data-target="#modalDynamicInfo">Гео:' + data.time + '</span>');
                    queryArr.push(data.query);

                    Highcharts.seriesType('mappie', 'pie', {
                            center: null,
                            clip: true,
                            states: {
                                hover: {
                                    halo: {
                                        size: 2
                                    }
                                }
                            },
                            dataLabels: {
                                enabled: false
                            },
                        },
                        {
                            getCenter: function () {
                                var options = this.options,
                                    chart = this.chart,
                                    slicingRoom = 2 * (options.slicedOffset || 0);
                                if (!options.center) {
                                    options.center = [null, null]; // Do the default here instead
                                }
                                if (options.center.lat !== undefined) {
                                    var point = chart.fromLatLonToPoint(options.center);
                                    options.center = [
                                        chart.xAxis[0].toPixels(point.x, true),
                                        chart.yAxis[0].toPixels(point.y, true)
                                    ];
                                }
                                if (options.sizeFormatter) {
                                    options.size = options.sizeFormatter.call(this);
                                }
                                var result = Highcharts.seriesTypes.pie.prototype.getCenter.call(this);
                                result[0] -= slicingRoom;
                                result[1] -= slicingRoom;
                                return result;
                            },
                            translate: function (p) {
                                this.options.center = this.userOptions.center;
                                this.center = this.getCenter();
                                return Highcharts.seriesTypes.pie.prototype.translate.call(this, p);
                            }
                        });

                    var keysdata = data.values;

                    var data = data.data;

                    var maxPieValues = 0;
                    var dataPieArray = [];
                    var colorAxisData = [];
                    var lengthArray = keysdata.length;
                    var itt = 1;
                    var from = -1;

                    data = data.filter(function (item, idx) {
                        return item[keysdata.length - 2] > 0;
                    });

                    colorArray = Highcharts.getOptions().colors;

                    $.each(keysdata, function (index, value) {
                        if (itt !== 1 && itt < lengthArray - 1) {
                            var color = colorArray[from + 1];

                            t = {color: color, 'name': value, from: from, to: from + 1};

                            dataPieArray.push(value);
                            colorAxisData.push(t);
                            from++;
                        }
                        itt++;
                    });

                    Highcharts.each(data, function (row) {
                        maxPieValues = Math.max(maxPieValues, row[lengthArray - 2]);
                    });

                    function getPointerData(data) {

                        itt = 0;
                        array = [];
                        $.each(dataPieArray, function (index, value) {
                            array.push([value, data[value], colorArray[itt]]);
                            itt++;
                        });

                        return array
                    };

                    // Build the chart
                    var chart = Highcharts.mapChart('geo-chart', {
                        title: {
                            text: ''
                        },
                        subtitle: {text: ''},
                        chart: {
                            animation: false,
                            backgroundColor: 'transparent',
                        },
                        colorAxis: {
                            dataClasses: colorAxisData
                        },
                        mapNavigation: {
                            enabled: false
                        },
                        allowPointSelect: false,

                        yAxis: {
                            minRange: 2300
                        },
                        tooltip: {
                            useHTML: true
                        },
                        plotOptions: {
                            mappie: {
                                borderColor: 'rgba(255,255,255,0.4)',
                                borderWidth: 1,
                                tooltip: {
                                    headerFormat: ''
                                }
                            }
                        },
                        series: [{
                            mapData: Highcharts.maps['countries/ua/ua-all'],
                            data: data,
                            name: 'Region',
                            borderColor: '#bcbad1',
                            showInLegend: false,
                            joinBy: ['woe-id', 'id'],
                            keys: keysdata,
                            tooltip: {
                                headerFormat: '',
                                pointFormatter: function () {
                                    var hoverVotes = this.hoverVotes; // Used by pie only

                                    var v = '<b>' + this.name + '</b><br/>' +
                                        Highcharts.map(getPointerData(this)
                                            .sort(function (a, b) {
                                                return b[1] - a[1]; // Sort tooltip by most votes
                                            }), function (line) {
                                            return '<span style="color:' + line[2] +
                                                // Colorized bullet
                                                '">\u25CF</span> ' +
                                                // Party and votes
                                                (line[0] === hoverVotes ? '<b>' : '') +
                                                line[0] + ': ' +
                                                Highcharts.numberFormat(line[1], 0) +
                                                (line[0] === hoverVotes ? '</b>' : '') +
                                                '<br/>';
                                        }).join('') +
                                        '<hr/>Total: ' + Highcharts.numberFormat(this.total, 0);

                                    return v;
                                }
                            }
                        }, {
                            name: 'Separators',
                            type: 'mapline',
                            data: Highcharts.geojson(Highcharts.maps['countries/ua/ua-all'], 'mapline'),
                            color: '#707070',
                            showInLegend: false,
                            enableMouseTracking: false
                        }, {
                            name: 'Connectors',
                            type: 'mapline',
                            color: 'rgba(130, 130, 130, 0.5)',
                            zIndex: 10,
                            showInLegend: false,
                            enableMouseTracking: false
                        }]
                    });

                    function getChartPieData(state, _this) {
                        itt = 0;
                        var charttooltip = {name: state.name};
                        var chartPieData = [];

                        charttooltip['hoverVotes'] = state.name;
                        charttooltip[keysdata[lengthArray - 2]] = state[keysdata[lengthArray - 2]];

                        $.each(dataPieArray, function (index, value) {
                            chartPieData.push({'name': value, y: state[value], color: colorArray[itt]});
                            charttooltip[value] = state[value];
                            itt++;
                        });
                        return [charttooltip, chartPieData];
                    };

                    Highcharts.each(chart.series[0].points, function (state) {
                        var rs = getChartPieData(state, this);

                        if (!state.id) {
                            return;
                        }

                        var pieOffset = state.pieOffset || {},
                            centerLat = parseFloat(state.properties.latitude),
                            centerLon = parseFloat(state.properties.longitude);

                        chart.addSeries({
                            type: 'mappie',
                            name: state.id,
                            zIndex: 6, // Keep pies above connector lines
                            sizeFormatter: function () {
                                var yAxis = this.chart.yAxis[0],
                                    zoomFactor = (yAxis.dataMax - yAxis.dataMin) / (yAxis.max - yAxis.min);

                                return Math.max(
                                    this.chart.chartWidth / 45 * zoomFactor,
                                    this.chart.chartWidth / 11 * zoomFactor * state.total / maxPieValues
                                );
                            },
                            tooltip: {
                                pointFormatter: function () {
                                    return state.series.tooltipOptions.pointFormatter.call(
                                        rs[0]
                                    );
                                }
                            },
                            data: rs[1],
                            center: {
                                lat: centerLat + (pieOffset.lat || 0),
                                lon: centerLon + (pieOffset.lon || 0)
                            }
                        }, false);
                        if (pieOffset.drawConnector !== false) {
                            var centerPoint = chart.fromLatLonToPoint({
                                    lat: centerLat,
                                    lon: centerLon
                                }),
                                offsetPoint = chart.fromLatLonToPoint({
                                    lat: centerLat + (pieOffset.lat || 0),
                                    lon: centerLon + (pieOffset.lon || 0)
                                });
                            chart.series[2].addPoint({
                                name: state.id,
                                path: 'M' + offsetPoint.x + ' ' + offsetPoint.y +
                                'L' + centerPoint.x + ' ' + centerPoint.y
                            }, false);
                        }
                    });
                    chart.redraw();

                    renderLine();
                });
            }
        }

        function renderLine() {
            $.ajax({
                url: "/olap/linechart",
                data: {
                    'value': $('#section-value').val(),
                    'interval': $('[data-filter-cond=interval]').val(),
                    'type_id': $('#section-type').val(),
                    'agg': $('#section-agg').val()
                }
            }).done(function (data) {
                $('.table-info').append('<span class="badge badge-secondary" id="line-info" data-toggle="modal"  data-target="#modalDynamicInfo">Координаты:' + data.time + '</span>');
                queryArr.push(data.query);

                itt = 0;
                $.each(data.data, function (index, value) {
                    data.data[itt]['color'] = Highcharts.getOptions().colors[itt];
                    itt++
                });

                lineOlapChart = Highcharts.chart('line-chart', {
                    chart: {
                        type: 'area',
                        backgroundColor: 'transparent',
                    },
                    title: {
                        text: ''
                    },
                    subtitle: {
                        text: ''
                    },
                    xAxis: {
                        categories: data.values,
                        tickmarkPlacement: 'on',
                        title: {
                            enabled: false
                        }
                    },
                    credits: {
                        enabled: false
                    },
                    yAxis: {
                        title: {
                            text: ''
                        },
                    },
                    tooltip: {
                        split: true,
                        valueSuffix: ''
                    },
                    plotOptions: {
                        area: {
                            stacking: 'normal',
                            lineColor: '#666666',
                            lineWidth: 1,
                            marker: {
                                lineWidth: 1,
                                lineColor: '#666666'
                            }
                        }
                    },
                    series: data.data
                });
                renderTable();
            })
        };

        function renderTable() {
            $.ajax({
                url: "/olap/tablechart",
                data: {
                    'value': $('#section-value').val(),
                    'interval': $('[data-filter-cond=interval]').val(),
                    'type_id': $('#section-type').val(),
                    'agg': $('#section-agg').val()
                }
            }).done(function (data) {
                $('.table-info').append('<span class="badge badge-secondary" id="table-info" data-toggle="modal"  data-target="#modalDynamicInfo">Таблица:' + data.time + '</span>');
                queryArr.push(data.query);

                $('#data-table').append('<table id="table-chart" class="table table-striped table-bordered" cellspacing="0" width="100%"></table>');

                var columns =[];

                Object.keys(data.data[0]).forEach(function (key) {
                    columns.push({data:key,title:(key == 'create_time') ? 'Временная метка': key});
                });

                $('#table-chart').DataTable({
                    data: data.data,
                    ordering: false,
                    sortable: false,
                    info: true,
                    paging: true,
                    responsive: true,
                    language:  {
                        "processing": "Подождите...",
                        "search": "Поиск:",
                        "lengthMenu": "Показать _MENU_ записей",
                        "info": "Записи с _START_ до _END_ из _TOTAL_ записей",
                        "infoEmpty": "Записи с 0 до 0 из 0 записей",
                        "infoFiltered": "(отфильтровано из _MAX_ записей)",
                        "infoPostFix": "",
                        "loadingRecords": "Загрузка записей...",
                        "zeroRecords": "Записи отсутствуют.",
                        "emptyTable": "В таблице отсутствуют данные",
                        "paginate": {
                            "first": "Первая",
                            "previous": "Предыдущая",
                            "next": "Следующая",
                            "last": "Последняя"
                        },
                        "aria": {
                            "sortAscending": ": активировать для сортировки столбца по возрастанию",
                            "sortDescending": ": активировать для сортировки столбца по убыванию"
                        }
                    },
                    lengthChange: false,
                    searching: false,
                    columns: columns
                });
                queryArr.push(data.query);
            });
        };

        $('#modalDynamicInfo').on("show.bs.modal", function(e) {

            console.log(123123);
            var value = ($(e.relatedTarget).attr('id'));

            console.log(queryArr[0]);
            if(value) {
                switch (value) {
                    case 'pie-info':
                        object = queryArr[0];
                        break;
                    case 'geo-info':
                        object = queryArr[1];
                        break;
                    case 'line-info':
                        object = queryArr[2];
                        break;
                    case 'table-info':
                        object = queryArr[3];
                        break;
                    default:
                }
                $(this).find(".modal-body").html('<pre class="prettyprint lang-sql">'+object+'</pre>');
            }
        });
    });
</script>