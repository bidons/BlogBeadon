
<h2 class="center-wrap">Конструкторы
    (<strong>Пагинаторы</strong>)
</h2>
        <div class="row">
            <div class="box">
                <div class="col-lg-12">
                    <p>
                    <ul>
                        В данном разделе мы расмотрим как можно использовать реляционные механизм PgSql для создания сущностей-конструкторов
                        для работы с лимитированым множеством где в качестве набора данных используютя "обвёртки, вьюхи"
                    </ul>
                    </p>

                    <div class="center-wrap">
                        <strong>
                            <li><a class="wrapper-blog" wrap="/blog/part1" title="DataTable demo (Server side) in Php,Mysql and Ajax" >Введение</a></li>
                            <li><a class="wrapper-blog" wrap="/blog/part2" title="DataTable demo (Server side) in Php,Mysql and Ajax" >Возможности</a></li>
                            <li><a class="wrapper-blog" wrap="/blog/part3" title="DataTable demo (Server side) in Php,Mysql and Ajax" >Особенности</a></li>
                            <li><a class="wrapper-blog" wrap="/blog/part4" title="DataTable demo (Server side) in Php,Mysql and Ajax" >Исходники</a></li>
                        </strong>
                    </div>
                    <hr>
                </div>
            </div>
        </div>

        <div id="wrapper-blog"></div>

    <script>
        $(document).ready(function () {


            $('.wrapper-blog').click(function () {
                $("#wrapper-blog").load($(this).attr('wrap'));
            });


            $("#wrapper-blog").load('/blog/part1');
        });
    </script>