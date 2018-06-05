{{ assets.outputCss('main-css') }}
{{ assets.outputJs('main-js') }}
<style>
    #container {
        min-width: 500px;
        max-width: 1200px;
        margin: 0 auto
    }
</style>

<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/sunburst.js"></script>
{#<script src="https://code.highcharts.com/modules/exporting.js"></script>#}

<div id="container">

</div>

<script>
    var bibleWordsDataPieSunBurst = [{"id": "10000", "name": "Библия", "parent": ""}, {"id": "10001", "name": "Старый завет", "parent": "10000"},
        {"id": "10002", "name": "Новый завет", "parent": "10000",'color':'#a6c96a'},
        {"id": "10003", "name": "Каноническая", "parent": "10001"},
        {"id": "10004", "name": "Не каноническая", "parent": "10001"}, {"id": "2", "name": "Книга Товита *", "value": 4581, "parent": "10004"}, {"id": "6", "name": "Третья книга Маккавейская *", "value": 4585, "parent": "10004"}, {"id": "7", "name": "Первая книга Маккавейская *", "value": 15124, "parent": "10004"}, {"id": "14", "name": "Книга премудрости Иисуса, сына Сирахова *", "value": 18166, "parent": "10004"}, {"id": "15", "name": "Третья книга Ездры *", "value": 13071, "parent": "10004"}, {"id": "27", "name": "Вторая книга Ездры *", "value": 7041, "parent": "10004"}, {"id": "42", "name": "Вторая книга Маккавейская *", "value": 10556, "parent": "10004"}, {"id": "48", "name": "Книга Соломона *", "value": 6558, "parent": "10004"}, {"id": "50", "name": "Книга Варуха *", "value": 2133, "parent": "10004"}, {"id": "56", "name": "Книга Иудифи *", "value": 7112, "parent": "10004"}, {"id": "58", "name": "Послание Иеремии *", "value": 1140, "parent": "10004"}, {"id": "3", "name": "Бытие", "value": 24967, "parent": "10003"}, {"id": "4", "name": "Книга Исаии", "value": 22271, "parent": "10003"}, {"id": "9", "name": "Книга Малахии", "value": 1153, "parent": "10003"}, {"id": "13", "name": "Книга Ионы", "value": 855, "parent": "10003"}, {"id": "16", "name": "Второзаконие", "value": 18302, "parent": "10003"}, {"id": "18", "name": "Левит", "value": 14755, "parent": "10003"}, {"id": "19", "name": "Третья книга Царств", "value": 15481, "parent": "10003"}, {"id": "20", "name": "Книга Аввакума", "value": 937, "parent": "10003"}, {"id": "21", "name": "Книга Софонии", "value": 951, "parent": "10003"}, {"id": "24", "name": "Вторая книга Царств", "value": 13199, "parent": "10003"}, {"id": "28", "name": "Книга Аггея", "value": 690, "parent": "10003"}, {"id": "29", "name": "Книга Есфири", "value": 3699, "parent": "10003"}, {"id": "30", "name": "Книга пророка Авдия", "value": 401, "parent": "10003"}, {"id": "31", "name": "Первая книга Паралипоменон", "value": 12542, "parent": "10003"}, {"id": "32", "name": "Книга Иеремии", "value": 26497, "parent": "10003"}, {"id": "33", "name": "Первая книга Ездры", "value": 4565, "parent": "10003"}, {"id": "34", "name": "Книга Осии", "value": 3295, "parent": "10003"}, {"id": "36", "name": "Книга Михея", "value": 1932, "parent": "10003"}, {"id": "37", "name": "Книга Захарии", "value": 3805, "parent": "10003"}, {"id": "38", "name": "Книга Наума", "value": 775, "parent": "10003"}, {"id": "39", "name": "Псалтирь", "value": 27927, "parent": "10003"}, {"id": "40", "name": "Четвёртая книга Царств", "value": 14345, "parent": "10003"}, {"id": "41", "name": "Книга Руфи", "value": 1668, "parent": "10003"}, {"id": "45", "name": "Первая книга Царств", "value": 16177, "parent": "10003"}, {"id": "47", "name": "Книга Иова", "value": 12340, "parent": "10003"}, {"id": "51", "name": "Книга Иоиля", "value": 1220, "parent": "10003"}, {"id": "53", "name": "Книга Иезекииля", "value": 24164, "parent": "10003"}, {"id": "54", "name": "Песнь песней Соломона", "value": 1702, "parent": "10003"}, {"id": "57", "name": "Притчи Соломона", "value": 9791, "parent": "10003"}, {"id": "59", "name": "Книга Иисуса Навина", "value": 11895, "parent": "10003"}, {"id": "63", "name": "Книга Судей израилевых", "value": 11831, "parent": "10003"}, {"id": "64", "name": "Плач Иеремии", "value": 2205, "parent": "10003"}, {"id": "66", "name": "Книга Даниила", "value": 9928, "parent": "10003"}, {"id": "68", "name": "Вторая книга Паралипоменон", "value": 16219, "parent": "10003"}, {"id": "69", "name": "Книга Неемии", "value": 6490, "parent": "10003"}, {"id": "70", "name": "Исход", "value": 19893, "parent": "10003"}, {"id": "71", "name": "Книга Екклезиаста", "value": 3657, "parent": "10003"}, {"id": "76", "name": "Книга Амоса", "value": 2628, "parent": "10003"}, {"id": "77", "name": "Числа", "value": 19864, "parent": "10003"}, {"id": "1", "name": "Послание Иакова", "value": 1558, "parent": "10002"}, {"id": "5", "name": "3-е послание Иоанна", "value": 203, "parent": "10002"}, {"id": "8", "name": "Послание Иуды", "value": 416, "parent": "10002"}, {"id": "10", "name": "Послание к Филиппийцам", "value": 1476, "parent": "10002"}, {"id": "11", "name": "1-е послание к Тимофею", "value": 1541, "parent": "10002"}, {"id": "12", "name": "Послание к Ефесянам", "value": 1993, "parent": "10002"}, {"id": "17", "name": "Послание к Колоссянам", "value": 1334, "parent": "10002"}, {"id": "22", "name": "Евангелие от Иоанна", "value": 13202, "parent": "10002"}, {"id": "23", "name": "Послание к Евреям", "value": 4534, "parent": "10002"}, {"id": "25", "name": "Послание к Галатам", "value": 2056, "parent": "10002"}, {"id": "26", "name": "Послание к Филимону", "value": 326, "parent": "10002"}, {"id": "35", "name": "2-е послание к Фессалоникийцам", "value": 715, "parent": "10002"}, {"id": "43", "name": "Послание к Титу", "value": 629, "parent": "10002"}, {"id": "44", "name": "1-е послание Петра", "value": 1599, "parent": "10002"}, {"id": "46", "name": "2-е послание к Коринфянам", "value": 4053, "parent": "10002"}, {"id": "49", "name": "2-е послание к Тимофею", "value": 1113, "parent": "10002"}, {"id": "52", "name": "Деяния святых апостолов", "value": 16289, "parent": "10002"}, {"id": "60", "name": "Евангелие от Луки", "value": 16829, "parent": "10002"}, {"id": "61", "name": "1-е послание к Коринфянам", "value": 6016, "parent": "10002"}, {"id": "62", "name": "Послание к Римлянам", "value": 6102, "parent": "10002"}, {"id": "65", "name": "2-е послание Иоанна", "value": 208, "parent": "10002"}, {"id": "67", "name": "Евангелие от Марка", "value": 9772, "parent": "10002"}, {"id": "72", "name": "Евангелие от Матфея", "value": 15585, "parent": "10002"}, {"id": "73", "name": "1-е послание Иоанна", "value": 1685, "parent": "10002"}, {"id": "74", "name": "2-е послание Петра", "value": 1021, "parent": "10002"}, {"id": "75", "name": "1-е послание к Фессалоникийцам", "value": 1310, "parent": "10002"}, {"id": "55", "name": "Откровение Иоанна Богослова", "value": 7343, "parent": "10002"}];

    // Splice in transparent for the center circle
    Highcharts.getOptions().colors.splice(0, 0, 'transparent');


    Highcharts.chart('container', {

        chart: {
            height: '100%',
            backgroundColor: 'transparent',
        },

        title: {
            text: 'Плотность слов в разрезе трудов'
        },
        subtitle: {
            text: ''
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
</script>