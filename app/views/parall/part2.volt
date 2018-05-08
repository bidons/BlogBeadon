{{ assets.outputCss('blog-css') }}
{{ assets.outputJs('blog-js') }}

<div class="container">
    {#<div class="row">#}
        <div class="col-sm-12">
                <div class="col-sm-5">
                        <select name="type" id="book-section" disabled =true >
                            <option value="10000">Библия</option>
                        </select>
                </div>
                    <div class="col-sm-5">
                        <select name="type" id="section-type">
                            <option>--Все объекты в секции--</option>
                            <option value="10001">Старый завет</option>
                            <option value="10002">Новый завет</option>
                        </select>
                    </div>
                    <div class="col-sm-5">
                        <select name="subtype" id="book">
                            <option>--Все книги--</option>
                        </select>
                    </div>
        </div>
    {#</div>#}
</div>

<script>

    var Select2Cascade = ( function(window, $) {
        function Select2Cascade(parent, child, url, select2Options) {
            var afterActions = [];
            var options = select2Options || {};

            this.then = function(callback) {
                afterActions.push(callback);
                return this;
            };

            parent.select2(select2Options).on("change", function (e) {
                child.prop("disabled", true);

                var _this = this;
                $.getJSON(url.replace(':parentId:', $(this).val()), function(items) {

                    var newOptions = '<option value="">-- Все книги --</option>';
                    for(var id in items) {
                        console.log(items[id]);
                        newOptions += '<option value="'+ items[id].id +'">'+ items[id].text +'</option>';
                    }

                    child.select2('destroy').html(newOptions).prop("disabled", false)
                            .select2(options);

                    afterActions.forEach(function (callback) {
                        callback(parent, child, items);
                    });
                });
            });
        }
        return Select2Cascade;

    })( window, $);

    $(document).ready(function() {
        var select2Options = { width: 'resolve',theme: "bootstrap4"};
        var apiUrl = '/parall/book/:parentId:';

        $('select').select2(select2Options);
        var cascadLoading = new Select2Cascade($('#section-type'), $('#book'), apiUrl, select2Options);
        cascadLoading.then( function(parent, child, items) {
            // Dump response data
            console.log(items);
        });
    });

</script>