
<link rel="icon" href="/favicon_rw.ico" />

<head>

    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-118128290-1"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', 'UA-118128290-1');
    </script>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>PgBeadon</title>

</head>

{#{{ partial('layouts/header') }}#}
{{ partial('layouts/nav') }}
<body>
    <div class="container-fluid">
            {{ content() }}
    </div>
</body>
{#
{{ partial('layouts/footer') }}#}
