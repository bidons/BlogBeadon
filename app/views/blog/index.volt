    {#{{ assets.outputCss('blog-css') }}
    {{ assets.outputJs('blog-js') }}#}

{#    <div class="nav-side-menu">
        <div class="brand">PostreSql/Experience</div>
        <i class="fa fa-bars fa-2x toggle-btn" data-toggle="collapse" data-target="#menu-content"></i>
        <div class="menu-list">
            <ul id="menu-content" class="menu-content collapse out">
                <li>
                    <a href="/site/index">
                        <i class="fa fa-dashboard fa-lg"></i> О конструкторах:
                    </a>
                </li>

                <li data-toggle="collapse" data-target="#products" class="collapsed active">
                    <a href="#"><i class="glyphicon glyphicon-oil"></i>Object tables<span class="arrow"></span></a>
                </li>
                <ul class="sub-menu collapse in" id="products">
                    <ul><li class="glyphicon glyphicon-oil"><a href="/blog/part1">(Static) Part:1</a></li>
                        <li><a href="/blog/part2">(Dynamic) Part:2</a></li>
                        <li><a href="/blog/part3">(Dynamic,Filter)  Part:3</a></li>
                        <li><a href="/blog/part4">(Checked,Filter)  Part:4</a></li>
                        <li><a href="/blog/part5">(Columns,Visible) Part:5</a></li></ul></ul>


                <li data-toggle="collapse" data-target="#service" class="collapsed">
                    <a href="#"><i class="fa fa-globe fa-lg"></i> Indexes <span class="arrow"></span></a>
                </li>
                <ul class="sub-menu collapse in" id="Indexes">
                    <ul><li><a href="/part6">Trgrm or Lexems? </a></li></ul>            </ul>

                <li data-toggle="collapse" data-target="#new" class="collapsed">
                    <a href="#"><i class="fa fa-car fa-lg"></i> New <span class="arrow"></span></a>
                </li>
                <ul class="sub-menu collapse" id="new">
                    <li>New New 1</li>
                    <li>New New 2</li>
                    <li>New New 3</li>
                </ul>
            </ul>
        </div>
    </div>

    <div class="row">
        <div class="col-md-offset-2 col-md-8">
            <div class="panel panel">
                <div class="container wrapper_blog">

                </div>
            </div>
        </div>
    </div>#}

    {{ assets.outputCss('blog-css') }}
    {{ assets.outputJs('blog-js') }}

    <style>
        body,.container,.bs-callout,.list-group-item,.row,.panel,#home,.even,pre{
            background:
                    url('/main/img/concrete_seamless.png');
            background-repeat: repeat;
            background-position: 0 0;
            background-color: #e2e2de;
        }

        #container {
            background: url('/main/img/concrete_seamless.png') repeat;
        }
    </style>
    <!DOCTYPE html>
    <html lang="en">

    <head>

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>Bare - Start Bootstrap Template</title>


        <!-- Custom styles for this template -->
        <style>
            body {
                padding-top: 54px;
            }
            @media (min-width: 992px) {
                body {
                    padding-top: 56px;
                }
            }
        </style>

    </head>


    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#">Каят хуйня тут будет написана </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            {#<div class="collapse navbar-collapse" id="navbarResponsive">
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
            </div>#}
        </div>
    </nav>

    <!-- Page Content -->
    <div class="container">
        <div class="row">
            <div class="col-lg-12 text-center">
                {#<h1 class="mt-5">Пидарки это для вас</h1>#}
                <ul class="list-unstyled">
                    <div id="container"></div>
                </ul>
        </div>
        <div class="rows">
          <div class="wrapper-blog"></div>
        </div>
    </div>
    </div>

{#    <!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>#}




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
                            plotBackgroundImage: '/main/img/concrete_seamless.png'
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