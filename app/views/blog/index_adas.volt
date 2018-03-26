 <!DOCTYPE html>
    <html lang="en">

    <head>

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>Bare - Start Bootstrap Template</title>
    </head>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#">Каят хуйня тут будет написана </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="#">Home
                            <span class="sr-only">(current)</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Contact</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row">
            <div class="col-lg-12 text-center">
                <ul class="list-unstyled">
                    {#<div id="container"></div>#}
                </ul>
        </div>
        <div class="rows">
          <div class="wrapper-blog"></div>
        </div>
    </div>
    </div>

    <script>
        $(document).ready(function () {
            var text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean bibendum erat ac justo sollicitudin, quis lacinia ligula fringilla. Pellentesque hendrerit, nisi vitae posuere condimentum, lectus urna accumsan libero, rutrum commodo mi lacus pretium erat. Phasellus pretium ultrices mi sed semper. Praesent ut tristique magna. Donec nisl tellus, sagittis ut tempus sit amet, consectetur eget erat. Sed ornare gravida lacinia. Curabitur iaculis metus purus, eget pretium est laoreet ut. Quisque tristique augue ac eros malesuada, vitae facilisis mauris sollicitudin. Mauris ac molestie nulla, vitae facilisis quam. Curabitur placerat ornare sem, in mattis purus posuere eget. Praesent non condimentum odio. Nunc aliquet, odio nec auctor congue, sapien justo dictum massa, nec fermentum massa sapien non tellus. Praesent luctus eros et nunc pretium hendrerit. In consequat et eros nec interdum. Ut neque dui, maximus id elit ac, consequat pretium tellus. Nullam vel accumsan lorem.';
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
            console.log(data);
            Highcharts.chart('container',
                    {
                        chart: {
                            type: 'line',
                           /* backgroundImage: '/main/img/concrete_seamless.png'*/
                        },
                series: [{
                    type: 'wordcloud',
                    data: data,
                    name: 'Occurrences',
                    events: {
                        click: function (event) {
                            console.log(this);
                        }
                    }
                }],
                title: {
                    text: 'Плюшки вкусняхи'
                },

                credits:false,
            });

            $(".wrapper-blog").load("/blog/part1");

            /*$(".ssSelect2").select2({
                placeholder: "Поиск",
                minimumInputLength: 3,
                width: "35em",
                ajax: {
                    url: "/admin/pg/pg/txtsrch",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    data: function (srch) {
                        return Object.assign({}, srch, {
                            'objdb': 'vw_client_application',
                            'col': ($(this).attr('data-column')),
                            'ident': 'application_id'
                        });
                    },
                    processResults: function (data, page) {
                        return {results: data};
                    }
                },
            });

            $('.ssSelect2').on('select2:close', function (evt) {
                var id = $(this).select2('data')[0].id;
                if (id) {
                    $("#wrapper_monitor").load("/admin/monitor/monitor_application/wrapper/" + id);
                }
            });*/
        });
    </script>