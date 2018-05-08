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
                <li><a class="wrapper-blog" href="/parall/index" title="Введение">Введение

                    </a>
                </li>
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
    <button class="btn btn-light" id="refresh-bible-pie" onclick="renderPie()">Обновить</button>
     <input class="form-control input-sm active" style="width:250"  type="text" data-filter-cond="startTime" placeholder="Time...">
        <select name="type" id="section-agg" style="width:250" class="form-control">
            <option value = "total_reg">Регистрации</option>
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
</div>
<br>

<script>
    var filterCond = '[data-filter-cond=startTime]';

    $(filterCond).daterangepicker({
        startDate: moment().subtract(29, 'days'),
        endDate: moment(),
        defaultDate:[moment().format('YYYY.MM.DD'), moment()],
        locale: {format: 'YYYY.MM.DD'},
        autoUpdateInput: true,
        ranges: {
            'Today': [moment().format('YYYY.MM.DD'), moment()],
            'Yesterday': [moment().subtract(1, 'days').format('YYYY.MM.DD'), moment().format('YYYY.MM.DD')],
            'Last 7 Days': [moment().subtract(6, 'days').format('YYYY.MM.DD'), moment()],
            'Last 30 Days': [moment().subtract(29, 'days'), moment()],
            'This Month': [moment().startOf('month'), moment().endOf('month').add(1, 'days').format('YYYY.MM.DD')],
            'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month').add(1, 'days').format('YYYY.MM.DD')]
        }
    });
    $(filterCond).on('apply.daterangepicker', function(ev, picker) {
        $(this).val(picker.startDate.format('YYYY.MM.DD') + ' - ' + picker.endDate.format('YYYY.MM.DD'));
    });

    $("#section-agg").select2();
    $("#section-type").select2();
    $("#section-type").select2();

    getProfileCategory('rebuild');
    getProfileCategory('rebuild');

    function getProfileCategory(mode) {
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
            });
    };

</script>


