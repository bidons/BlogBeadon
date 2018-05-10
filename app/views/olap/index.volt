{{ assets.outputCss('blog-css') }}
{{ assets.outputJs('blog-js') }}

<h2 class="center-wrap">
    <h2 class="center-wrap">OLAP</h2>
</h2>
<div class="container">
    <div class="row">
        <div class="col-md-4">
            <div class="text-center">
                <img class="rounded-circle" src="/main/img/cube.jpeg" width="300" height="300">
            </div>
        </div>
        <div class="entry-content"></div>
        <div class="post-series-content">
            <ol>
                <li><a class="wrapper-blog" href="/parall/index" title="Введение">Введение</a></li>
            </ol>
        </div>
    </div>
</div>
<hr>
<div class="container">
    <div class="center-wrap">
        <h5>ОLAP</h5>
        <div id='select-parallel'></div>
    </div>
    <div class ="row center-wrap">
    <button class="btn btn-light" id="refresh-bible-pie" onclick="renderData()">Обновить</button>
     <input class="form-control input-sm active" style="width:250"  type="text" data-filter-cond="interval" placeholder="Time...">
        <select name="type" id="section-agg" style="width:250" class="form-control">
            <option value = "total">Регистрации</option>
            <option value = "event_1">Событие №1</option>
            <option value = "event_2">Событие №1</option>
            <option value = "event_3">Событие №1</option>
        </select>

        <select name="type" id="section-type" style="width:250" class="form-control">
            <option value="8">Образование</option>
            <option value="9">Регионы</option>
            <option value="4">Занятость (тип)</option>
            <option value="1">Занятость (сост.)</option>
            <option value="6">Занятость (сотрд.)</option>
            <option value="5">Образование (дет.)</option>
            <option value="7">Имущество</option>
            <option value="10">Cемейное положение</option>
            <option value="11">Пол</option>
            <option value="2">По тел. оп.</option>
            <option value="12">Маркетинг (CPA)</option>
        </select>

    </div>
    <div class="row">

    <select name="type" id="section-value" style="100%" class="form-control">
    </select>
    </div>

    <div class="row">
        <div id = "pie-chart"></div>
    </div>
</div>
<br>

<script>
    $('[data-filter-cond=interval]').daterangepicker({
        startDate: moment().subtract(29, 'days'),
        endDate: moment(),
        defaultDate:[moment().format('YYYY.MM.DD'), moment().format('YYYY.MM.DD')],
        locale: {
            format: 'YYYY.MM.DD',
            applyLabel: "Применить",
            cancelLabel: "Оменить",
            customRangeLabel: "Выбрать интервалы",
        },
        autoUpdateInput: false,
        ranges: {
            'Сегодня': [moment(), moment().add(1, 'days')],
            'Вчера': [moment().subtract(1, 'days'), moment()],
            'За последние 7-емь дней': [moment().subtract(6, 'days'), moment().add(1, 'days')],
            'За последние 30-ать дней': [moment().subtract(29, 'days'), moment().add(1, 'days')],
            'Текущий месяц': [moment().startOf('month'), moment().endOf('month').add(1, 'days')],
            'Прошлый месяц': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month').add(1, 'days')]
        }
    });

    $('[data-filter-cond=interval]').on('apply.daterangepicker', function (ev, picker) {
        $(this).val(picker.startDate.format('YYYY.MM.DD') + ' - ' + picker.endDate.format('YYYY.MM.DD'));
    });

    $("#section-agg").select2();
    $("#section-type").select2().on("select2:select", function (e) {
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
                    multiple:"multiple",
                    dropdownAutoWidth : true
                })

                $("#section-value > option").prop("selected","selected");
                $("#section-value").trigger("change");

                renderData();
            });
    };

    response = {"data" : [{"name" : "Cреднее", "y" : 1538}, {"name" : "Высшее", "y" : 1708}, {"name" : "Две или больше высших", "y" : 87}, {"name" : "Научная степень", "y" : 17}, {"name" : "Не полное высшее", "y" : 1054}, {"name" : "Неполное среднее", "y" : 142}, {"name" : "Среднее специальное", "y" : 3323}, {"name" : "Не определено", "y" : 2709}], "query" : "\n      WITH cte AS\n    (\n        SELECT json_build_object('name',coalesce(s.value,'Не определено'), 'y', count(*)) AS jb\n        FROM client_dimension AS s\n        WHERE s.create_time >= '2018-04-10 00:00:00' \n              AND s.create_time < '2018-05-10'\n              AND type_id = '8' AND value_id in ('-1','1','2','3','4','5','6','7') GROUP BY s.value\n        ORDER BY s.value\n    )\n        SELECT json_agg(jb)\n        FROM cte;"};


    function renderData()
    {
        renderPiePercent()
    }

    function renderPiePercent()
    {

        console.log({'value':$('#section-value').val(),'interval':$('[data-filter-cond=interval]').val(),'type_id':$('#section-type').val(),'agg':$('#section-agg').val()});
        $.ajax({
            type: "GET",
            url: "/olap/piechart",
            data: {'value':$('#section-value').val(),'interval':$('[data-filter-cond=interval]').val(),'type_id':$('#section-type').val(),'agg':$('#section-agg').val()}
        }).done(function (data) {
            $('#section-value').select2({
                data: JSON.parse(data),
                multiple:"multiple",
                dropdownAutoWidth : true
            });

            $("#section-value > option").prop("selected","selected");
            $("#section-value").trigger("change");
        });

        var total = 0, percentage, convertArray = [];

        $.each(data, function () {
            total += this.y;
            convertArray.push({name: this.name.toUpperCase() + ' (' + this.y + ')', y: (this.y / total * 100)});
        });

        Highcharts.chart(selector, {
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie',
                backgroundColor: {
                    linearGradient: {x1: 0, y1: 0, x2: 1, y2: 1},
                    stops: [
                        [0, 'rgb(255, 255, 255)'],
                        [1, 'rgb(200, 200, 255)']
                    ]
                },
            },
            title: {
                text: '123123',
            },
            credits: {
                enabled: false
            },
            subtitle: {
                text: '12312312'
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
    };

</script>


