    {{ assets.outputCss('blog-css') }}
    {{ assets.outputJs('blog-js') }}

    <div class="nav-side-menu">
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
                    <ul><li><a href="/blog/part1">(Static) Part:1</a></li>
                        <li><a href="/part2">(Dynamic) Part:2</a></li>
                        <li><a href="/part3">(Dynamic,Filter)  Part:3</a></li>
                        <li><a href="/part4">(Checked,Filter)  Part:4</a></li>
                        <li><a href="/part5">(Columns,Visible) Part:5</a></li></ul></ul>


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
    </div>


    <script>
        $(document).ready(function () {
            $(".wrapper_blog").load("/blog/part1");

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