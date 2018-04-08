

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

<div class="center-wrap">
    <div id ='select-parallel'> </div>
</div>

<parall>



<link rel="stylesheet" type="text/css" href="/parallel/parallel.css" />

    <div id="header">
        <h1></h1>
        <button title="Zoom in on selected data" id="keep-data" disabled="disabled">Keep</button>
        <button title="Remove selected data" id="exclude-data" disabled="disabled">Exclude</button>
        <button title="Export data as CSV" id="export-data">Export</button>
        <div class="controls">
            <strong id="rendered-count"></strong>/<strong id="selected-count"></strong>
            <div class="fillbar"><div id="selected-bar"><div id="rendered-bar">&nbsp;</div></div></div>
            Lines at <strong id="opacity"></strong> opacity.
            <span class="settings">
        <button id="hide-ticks">Hide Ticks</button>
        <button id="show-ticks" disabled="disabled">Show Ticks</button>
        </div>
        <div style="clear:both;"></div>
    </div>
    <div id="chart">
    </div>
    <div id="wrap"> </div>
</parall>


<script src="/parallel/d3.v2.js"></script>
<script src="/parallel/underscore.js"></script>
<script src="/parallel/parallel.js"></script>

<script>

    /*$('body').addClass('skin-blue sidebar-mini sidebar-collapse');*/
var item = {
//    "approval-rate-verif":
//        {"yaxis":
//            {   "Отказ от подписания (time-out)": [318, 65, 67],
//                "Отказ от подписания (client)": [37, 50, 75],
//                "Отказано верификацией": [325, 50, 39],
//                "Отказано (time-out)": [120, 56, 40],
//                "Первый заем": [555, 55, 55],
//                "Повторный заем": [185, 80, 45],
//                "Не известно": [200, 20, 20]},
//            "xaxis": {"day_passed_from_app_create":"Количество дней назад (от текущей даты)",
//                "ttl_app_veriff":"Всего заявок на вериф",
//                "ttl_rej_sc_first":"Отказано по первым займам",
//                "ttl_rej_sc_mrthn":"Отказано по вторым займам",
//                "ttl_rej_sc_lst_first":"Отказано по первым займам (в след. дне)",
//                "ttl_rej_sc_lst_mrthn":"Отказано по вторым займам (в след. дне)",
//                "ttl_approve":"Одобрено",
//                "fact_credit":"Выданый займ",
//                "pen_loan":"Штрафники"},'descr':'Approval rate (верификация)','csv':'/parallel/approval_rate.csv'},
//        "collection-efficiency":
//            {"yaxis":
//                {   "Олег Ведякин":[318, 65, 67],
//                    "Манзюк Евгения":[37, 50, 75],
//                    "Станислав Осадченко":[325, 50, 39],
//                    "Парукова Ольга":[120, 56, 40],
//                    "Касян Виктория":[555, 55, 55],
//                    "Сергеев Артем":[185, 80, 45],
//                    "Владимир Голубин":[100, 40, 70],
//                    "Виктория Коновал":[150, 30, 40],
//                    "Гопкало Александр":[160, 20, 30],
//                    "Бойко Роман":[190, 244, 10],
//                    "Ксения Федорова":[250, 20, 20],
//                    "Горай Игорь":[300, 80, 20]},
//                "xaxis":{"amount":"Сумма займа",
//                    "coll_balance":"Баланс выхода на просрочку",
//                    "curr_balance":"Текущий баланс",
//                    "day_passed_closed":"Дни (время закрытия - время коллекшена)",
//                    "day_passed_forb":"Дни (время как стал мошенником - время коллекшена)",
//                    "day_passed_from_coll_create":"Дни (сейчас - время коллекшена)",
//                    "day_passed_sold":"Дни (время продажи займа - время коллекшена)",
//                    "pay_sum_of_col":"Платежи после попадания на колекшен",
//                    "pay_sum_bf_col":"Сбор коллекторами",
//                    "prc_coll": "Процент сбора от балнса выхода на коллекшен coll_balance"
//                },
//                "csv":"/parallel/coll_efficiency.csv",
//                "descr":"Эфективность коллекторов"
//            },
//        "client_loan_scoring": {
//            "yaxis": {
//                "Займ (мошенники) 1": [100, 40, 70],
//                "Займы (мошенники) 2-5":[150, 30, 40],
//                "Займы (мошенники) 5-10":[160, 20, 30],
//                "Займы (мошенники) 10-20":[190, 244, 10],
//                "Займы (мошенники) 20-40":[250, 20, 20],
//                "Займы (мошенники) > 40":[300, 80, 20],
//                "Займ 1":[318, 65, 90],
//                "Займы 2-5":[37, 50, 75],
//                "Займы 5-10":[325, 50, 39],
//                "Займы 10-20":[200, 80, 60],
//                "Займы 20-40":[240, 80, 90],
//                "Займы > 40":[185, 80, 45]},
//            "xaxis": {
//                "cnt_clc_dvc_clc":"Кол-во клиентов на клиента (девайсы)",
//                "cnt_fraud_by_contact":"Кол-во клиентов связаных по пересч. контактами с мошенниками",
//                "cnt_external": "Кол-во сработок внешних правил (по заявкам) клиента",
//                "cnt_internal": "Кол-во сработок внутренних правил (по заявкам) клиента ",
//                "cnt_model":    "Кол-во сработок модели (по заявкам) клиента",
//                "day_psd_now_clc_crt":"Дни (от сейчас до создания клиента) ",
//                "day_psd_now_forb":"Дни (от созд. клиента до  попадения в мошенники)",
//                "day_psd_now_sold":"Дни (от созд. клиента до  продажи)",
//                "penalties_lst_loan":"Сумма штрафов последний займ",
//                "prc_amt_pay":"Процент пагашений от суммы займа",
//                "sum_payment":"Общ. cумма погашений клиентом",
//                "sum_penalties":"Сумма штрафов",
//                "ttl_app":"Кол-во заявок клиента",
//                "ttl_cnt_rej":"Кол-во отказов клиенту",
//                "ttl_sum_appr":"Общ. сумма по займам ",
//            },
//            "csv": "/parallel/client_loan.csv",
//            "descr": "Займы клиентов (скоринг)"
//        },
        "bible_by_type": {
            "yaxis": {
                "Старый завет": [318, 65, 67],
                "Новый завет": [185, 80, 45]
            },
                "xaxis": {
                    "amount": "Сумма займа",
                    "coll_balance": "Баланс выхода на просрочку",
                    "curr_balance": "Текущий баланс",
                    "day_passed_closed": "Дни (время закрытия - время коллекшена)",
                    "day_passed_forb": "Дни (время как стал мошенником - время коллекшена)",
                    "day_passed_from_coll_create": "Дни (сейчас - время коллекшена)",
                    "day_passed_sold": "Дни (время продажи займа - время коллекшена)",
                    "pay_sum_of_col": "Платежи после попадания на колекшен",
                    "pay_sum_bf_col": "Сбор коллекторами",
                    "prc_coll": "Процент сбора от балнса выхода на коллекшен coll_balance"
                },
                "csv": "/parallel/bible_parall_type.csv",
                "descr": "X-тип речи, Y- по класификации,DIM-слова"
        }, "bible_part_of_speach":
    {"yaxis":
    {   "ЧАСТИЦА":[318, 65, 67],
        "МЕСТОИМ_СУЩ":[37, 50, 75],
        "БЕЗЛИЧ_ГЛАГОЛ":[325, 50, 39],
        "СУЩЕСТВИТЕЛЬНОЕ":[120, 56, 40],
        "СОЮЗ":[555, 55, 55],
        "ЧИСЛИТЕЛЬНОЕ":[185, 80, 45],
        "ПРИЛАГАТЕЛЬНОЕ":[300, 80, 20],
        "ВВОДНОЕ":[150, 30, 40],
        "МЕСТОИМЕНИЕ":[160, 20, 30],
        "ИНФИНИТИВ":[190, 244, 10],
        "ПРЕДЛОГ":[250, 20, 20],
        "ПОСЛЕЛОГ":[300, 80, 20],
        "ГЛАГОЛ":[185, 80, 45],
        "НАРЕЧИЕ":[240, 80, 90],
        "ДЕЕПРИЧАСТИЕ":[200, 80, 60]},
        "xaxis":{"amount":"Сумма займа",
            "coll_balance":"Баланс выхода на просрочку",
            "curr_balance":"Текущий баланс",
            "day_passed_closed":"Дни (время закрытия - время коллекшена)",
            "day_passed_forb":"Дни (время как стал мошенником - время коллекшена)",
            "day_passed_from_coll_create":"Дни (сейчас - время коллекшена)",
            "day_passed_sold":"Дни (время продажи займа - время коллекшена)",
            "pay_sum_of_col":"Платежи после попадания на колекшен",
            "pay_sum_bf_col":"Сбор коллекторами",
            "prc_coll": "Процент сбора от балнса выхода на коллекшен coll_balance"
        },
        "csv":"/parallel/bible_parall.csv",
        "descr":"X-постранично c лимотом,Y - типы речи,DIM-слова"
    }};
    function getRandomRgb() {
        var num = Math.round(0xffffff * Math.random());
        var r = num >> 16;
        var g = num >> 8 & 220;
        var b = num & 255;

        var r =[r, g ,b];

        return r;
    }

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

        var v = '<div class="third" id="legend-block"'
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
            +'<p id="food-list">'
            +'</p>'
            +'</div>';

        $('#wrap').append(v);

        initParallel(item[parallId].csv,item[parallId].yaxis);
    }
</script>


