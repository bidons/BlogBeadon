<script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.3.15/proj4.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/maps/modules/map.js"></script>

<script src="https://code.highcharts.com/maps/modules/offline-exporting.js"></script>
<script src="//code.highcharts.com/mapdata/countries/ua/ua-all.js"></script>
{#<script src="https://code.highcharts.com/mapdata/countries/us/us-all.js"></script>#}

<div id="container"></div>

<script>
    response = {"chart" : {"data" : [["2347534", 59, 46, 4, 1, 36, 1, 111, 258], ["2347535", 65, 46, 1, 0, 33, 3, 69, 217], ["2347536", 23, 27, 0, 1, 19, 2, 46, 118], ["2347537", 186, 184, 10, 3, 101, 14, 405, 903], ["2347538", 85, 83, 2, 1, 43, 9, 209, 432], ["2347539", 35, 45, 2, 0, 25, 7, 60, 174], ["2347540", 92, 115, 7, 2, 86, 7, 192, 501], ["2347541", 75, 57, 3, 0, 38, 5, 134, 312], ["2347542", 42, 37, 0, 0, 34, 2, 112, 227], ["2347543", 68, 48, 0, 0, 18, 8, 122, 264], ["2347544", 0, 4, 0, 0, 1, 0, 2, 7], ["2347545", 78, 108, 7, 0, 69, 8, 185, 455], ["2347546", 13, 21, 1, 0, 12, 0, 66, 113], ["2347547", 35, 93, 6, 2, 41, 8, 125, 310], ["2347548", 72, 65, 4, 2, 38, 7, 149, 337], ["2347549", 97, 105, 5, 1, 67, 11, 170, 456], ["2347550", 53, 66, 2, 0, 44, 5, 132, 302], ["2347551", 33, 38, 3, 0, 15, 3, 58, 150], ["2347552", 53, 41, 1, 0, 34, 4, 99, 232], ["2347553", 15, 25, 1, 0, 15, 1, 39, 96], ["2347554", 41, 57, 3, 0, 36, 4, 117, 258], ["2347555", 33, 31, 1, 0, 26, 4, 59, 154], ["2347556", 25, 25, 0, 0, 19, 5, 39, 113], ["2347557", 97, 71, 6, 1, 44, 12, 245, 476], ["2347558", 52, 32, 1, 1, 29, 5, 102, 222], ["20070188", 55, 163, 13, 2, 81, 2, 147, 463], ["20070189", 0, 0, 0, 0, 0, 0, 1, 1]], "values" : ["id","Cреднее","Высшее","Две или больше высших","Научная степень","Не полное высшее","Неполное среднее","Среднее специальное","total","values"]}, "query" : "with cte as\n          (\n              SELECT\n                location_natural_world_woe_id,\n                Coalesce(value,'Не определено') as value,\n                value_id,\n                 count(*) as c\n              FROM client_dimension\n              WHERE value_id in  ('-1','1','2','3','4','5','6','7') AND type_id = 8 AND location_natural_world_woe_id IS NOT NULL  and create_time >= '2018-04-11 00:00:00' and create_time <  '2018-05-10 00:00:00' \n              GROUP BY location_natural_world_woe_id, value,value_id\n          ), get_max_values as\n          (\n            select array_agg(DISTINCT value) as value\n            from cte\n          ), prepare_dim as\n          (\n              SELECT\n                g.location_natural_world_woe_id,\n                unnest((SELECT value\n                        FROM get_max_values)) as v\n              FROM cte AS g\n              GROUP BY g.location_natural_world_woe_id\n          ), get_data as\n          (\n              SELECT jsonb_build_array(g.location_natural_world_woe_id::text) || jsonb_agg(coalesce(c.c,0)\n              ORDER BY g.v) || jsonb_build_array(sum(c.c)) as r\n              FROM prepare_dim AS g\n                LEFT JOIN cte AS c ON g.v = c.value AND c.location_natural_world_woe_id = g.location_natural_world_woe_id\n              GROUP BY g.location_natural_world_woe_id\n          )\n\n            select json_build_object('data',jsonb_agg(r),'values',(SELECT array['id'] ||  value || array['total','values'] FROM get_max_values order by value))\n            from get_data"};

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
            }
        },
        {
            getCenter: function () {
                var options = this.options,
                    chart = this.chart,
                    slicingRoom = 2 * (options.slicedOffset || 0);
                if (!options.center) {
                    options.center = [null, null]; // Do the default here instead
                }
                // Handle lat/lon support
                if (options.center.lat !== undefined) {
                    var point = chart.fromLatLonToPoint(options.center);
                    options.center = [
                        chart.xAxis[0].toPixels(point.x, true),
                        chart.yAxis[0].toPixels(point.y, true)
                    ];
                }
                // Handle dynamic size
                if (options.sizeFormatter) {
                    options.size = options.sizeFormatter.call(this);
                }
                // Call parent function
                var result = Highcharts.seriesTypes.pie.prototype.getCenter.call(this);
                // Must correct for slicing room to get exact pixel pos
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

    var keysdata = response.chart.values;
    var data = response.chart.data;

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

    console.log(keysdata);

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

    function getPointerData(data) {
        itt = 0;
        array = [];
        $.each(dataPieArray, function (index, value) {
            array.push([value, data[value], colorArray[itt]]);
            itt++;
        });

        return array
    };

    Highcharts.each(data, function (row) {
        maxPieValues = Math.max(maxPieValues, row[lengthArray - 2]);
    });


    var chart = Highcharts.mapChart('geo-chart', {
        title: {
            text: $('#section-agg').select2('data')[0].text
        },
        subtitle: {text: '123123'},
        chart: {
            animation: false
        },

        colorAxis: {
            dataClasses: colorAxisData
        },
        mapNavigation: {
            enabled: false
        },
        credits: {
            enabled: false
        },
        // Limit zoom range
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

    // When clicking legend items, also toggle connectors and pies
    Highcharts.each(chart.legend.allItems, function (item) {
        var old = item.setVisible;
        item.setVisible = function () {
            var legendItem = this;
            old.call(legendItem);

            Highcharts.each(chart.series[0].points, function (point) {
                if (chart.colorAxis[0].dataClasses[point.dataClass].name === legendItem.name) {
                    // Find this state's pie and set visibility
                    Highcharts.find(chart.series, function (item) {
                        return item.name === point.id;
                    }).setVisible(legendItem.visible, false);
                    // Do the same for the connector point if it exists
                    var connector = Highcharts.find(chart.series[2].points, function (item) {
                        return item.name === point.id;
                    });
                    if (connector) {
                        connector.setVisible(legendItem.visible, false);
                    }
                }
            });
            chart.redraw();
        }
    });

</script>