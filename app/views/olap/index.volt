{{ assets.outputCss('main-css') }}
<link rel="stylesheet" type="text/css" href="/plugins/select2/select2.css">
<link rel="stylesheet" type="text/css" href="/plugins/select2/select2-bootstrap4.min.css">
<link rel="stylesheet" type="text/css" href="/plugins/daterangepicker/daterangepicker-bs3.css">
<link rel="stylesheet" type="text/css" href="/plugins/datatables/dataTables.bootstrap4.min.css">
{{ assets.outputJs('main-js') }}

<script type="text/javascript" src="/plugins/select2/select2.min.js"></script>
<script type="text/javascript" src="/plugins/daterangepicker/moment.js"></script>
<script type="text/javascript" src="/plugins/daterangepicker/daterangepicker.js"></script>
<script type="text/javascript" src="/plugins/highcharts/highstock.js"></script>
<script type="text/javascript" src="/plugins/datatables/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="/plugins/datatables/dataTables.bootstrap4.min.js"></script>

<script type="text/javascript" src="/main/js/highstockWrapper.js"></script>
<script src="/plugins/proj4/dist/proj4.js"></script>
<script type="text/javascript" src="/plugins/highcharts/modules/map.js"></script>
<script src="//code.highcharts.com/mapdata/countries/ua/ua-all.js"></script>
<script type="text/javascript" src="https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js?lang=sql"></script>

{{ partial('layouts/olapl') }}

<div class="container">
    <div class="center-wrap">
        <div style="margin-bottom:16px">
            <div class="table-info" style="margin-bottom:16px"></div></div>
    </div>
    <div class="row">
        <button type="button" style ="width: 250px" class="btn btn-light" id="refresh-charts">Обновить</button>
        <div class="col-sm">
            <div class="btn-group text-center">
                <input type="text" class="form-control input-sm active"   type="text" data-filter-cond="interval" placeholder="Time...">
                <select class="form-control" id="section-agg">
                    <option value="total">Событие №1</option>
                    <option value="event_1">Событие №2</option>
                    <option value="event_2">Событие №3</option>
                    <option value="event_3">Событие №4</option>
                </select>

                <select id="section-type" class="form-control">
                    <option value="8">Образование</option>
                    <option value="4">Ремёсла (тип)</option>
                    <option value="1">Ремёсла (состояние)</option>
                    <option value="6">Ремёсла (сотрудники)</option>
                    <option value="5">Образование (детализация)</option>
                    <option value="7">Имущество</option>
                    <option value="10">Cемейное положение</option>
                    <option value="11">Пол</option>
                    <option value="2">Тел. операторы</option>
                    <option value="9">Регионы</option>
                </select>
            </div>
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
        <div id="pie-chart" style="min-width: 600px; height: 750px; max-width: 1500px; margin: 0 auto"></div>
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
        var today = moment().add(1,'days').format('YYYY.MM.DD');

        $('[data-filter-cond=interval]').daterangepicker({
            startDate: moment().subtract(29, 'days'),
            endDate: moment(),
            defaultDate: [moment().format('YYYY.MM.DD'), today],
            locale: {
                format: "YYYY.MM.DD",
                applyLabel: "Применить",
                customRangeLabel: "Выбрать интервалы",
            },
            autoUpdateInput: true,
            ranges: {
                'Сегодня': [moment(), moment().add(1, 'days')],
                'Вчера': [moment().subtract(1, 'days'), moment()],
                'За последние 7-емь дней': [moment().subtract(6, 'days'), moment().add(1, 'days')],
                'За последние 30-ать дней': [moment().subtract(29, 'days'), moment().add(1, 'days')],
                'Текущий месяц': [moment().startOf('month'), moment().endOf('month').add(1, 'days')],
                'Прошлый месяц': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month').add(1, 'days')]
            }
        });

        $('[data-filter-cond=interval]').val('2016-05-01' + ' - ' + '2017-04-01');

        $('#refresh-charts').on('click', function () {
            renderData();
        });

        $('[data-filter-cond=interval]').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('YYYY.MM.DD') + ' - ' + picker.endDate.format('YYYY.MM.DD'));
            renderData();
        });

        $("#section-agg").select2({ theme: 'bootstrap4'}
        ).on("select2:select", function (e) {
            renderData();
        });
        $("#section-type").select2({ theme: 'bootstrap4'}
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
                    theme: 'bootstrap4',
                    multiple: "multiple",
                    dropdownAutoWidth: true
                });

                $("#section-value > option").prop("selected", "selected");
                $("#section-value").trigger("change");

                renderData();
            });
        };

        function renderData() {
            queryArr = []
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


