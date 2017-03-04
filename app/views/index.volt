
    {{ assets.outputCss() }}
    {{ assets.outputJs() }}

    {{ partial('layouts/header') }}

<body>

<div class="brand">PosgreSql Experience</div>
<div class="address-bar">3481 Melrose Place | Beverly Hills, CA 90210 | 123.456.7890</div>

{{ partial('layouts/nav') }}

{{ content() }}

</body>
{{ partial('layouts/footer') }}

<div class="modal fade" id="imagemodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-body">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <img src="" class="imagepreview" style="width: 100%;" >
                </div>
            </div>
        </div>
</div>

<script>
        $(function() {
            $('.modal_pop').on('click', function() {
                $('.imagepreview').attr('src', $(this).attr('src'));
                $('#imagemodal').modal('show');
            });
        });


        $('.carousel').carousel({
            interval: 5000 //changes the speed
        })
</script>


