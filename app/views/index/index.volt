{{ assets.outputCss('main-css') }}
{{ assets.outputJs('main-js') }}


<div class="container">
<div class="col-md-12">
        {#<div class="text-center">
            <img class="rounded-bottom" src="/main/img/postgresql.png"  width="20" height="30">
        </div>#}
    </div>
    <br>
    <br>
    <br>
</div>
{#
{% for field in projectTree %}
    {% for parent in field %}
        {{ dump(parent['href'])}}
{% endfor %}
{% endfor %}#}

<div class="row">
    <div class="col-md-12">
        <div class="center-wrap">
    <pre>
Материал представляет собой иллюстрацию работы различных механизмов,
где основой акцент делается на описание реляционных механизмов PostgreSQL.
    </pre>
        </div>
        <div class="text-center">
            <img class="img-fluid img-thumbnail" src="/main/img/slide-3.jpg"  alt="">
        </div>
    </div>
</div>

<style>
    .highcharts-point-hover {
        stroke: rgb(204, 248, 243);
        stroke-width: 1px;
    }
</style>

<script>

    var data = {{ projectTree }};

    console.log(data);
    data = data.objectdb;


    /*Highcharts.chart('container', {
        tooltip: { enabled: false },
        chart:{ backgroundColor: 'transparent'},
        series: [{
            type: 'wordcloud',
            data: data,
            name: 'Occurrences'

        }],
        title: {
            text: ''
        }
    });*/
</script>


