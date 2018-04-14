{{ partial('layouts/header') }}
{{ partial('layouts/nav') }}
<body>

    <div class="container-fluid">
            {{ content() }}
    </div>
</body>
{{ partial('layouts/footer') }}