{{ assets.outputCss('main-css') }}
{{ assets.outputJs('main-js') }}

<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/wordcloud.js"></script>

<div class="container">
<div class="col-md-12">
        <div class="text-center">
            {#<img class="rounded-bottom" src="/main/img/postgresql.png"  width="300" height="410">#}
        </div>
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
Материал представляет собой илюстрацию работы различных механизмов,
где основой акцент делается на описание реляционных механизмов PostgreSQL.
                </pre>
            <div id="container" style="min-width: 600px; height: 750px; max-width: 1500px; margin: 0 auto"></div>
        </div>
    </div>
</div>

<style>
    .highcharts-point-hover {
        stroke: rgb(0,206,255);
        stroke-width: 1px;
    }
</style>

<script>

    var data = {{ projectTree }};

    data = data.objectdb;
    /*var text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean bibendum erat ac justo sollicitudin, quis lacinia ligula fringilla. Pellentesque hendrerit, nisi vitae posuere condimentum, lectus urna accumsan libero, rutrum commodo mi lacus pretium erat. Phasellus pretium ultrices mi sed semper. Praesent ut tristique magna. Donec nisl tellus, sagittis ut tempus sit amet, consectetur eget erat. Sed ornare gravida lacinia. Curabitur iaculis metus purus, eget pretium est laoreet ut. Quisque tristique augue ac eros malesuada, vitae facilisis mauris sollicitudin. Mauris ac molestie nulla, vitae facilisis quam. Curabitur placerat ornare sem, in mattis purus posuere eget. Praesent non condimentum odio. Nunc aliquet, odio nec auctor congue, sapien justo dictum massa, nec fermentum massa sapien non tellus. Praesent luctus eros et nunc pretium hendrerit. In consequat et eros nec interdum. Ut neque dui, maximus id elit ac, consequat pretium tellus. Nullam vel accumsan lorem.';
    var lines = text.split(/[,\. ]+/g),
        data = Highcharts.reduce(lines, function (arr, word) {
            var obj = Highcharts.find(arr, function (obj) {
                return obj.name === word;
            });
            if (obj) {
                obj.weight += 1;
            } else {
                obj = {
                    name: word,
                    weight: 1
                };
                arr.push(obj);
            }
            return arr;
        }, []);
*/


    Highcharts.chart('container', {
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
    });
</script>


