    {#{{ assets.outputCss('main-css') }}
    {{ assets.outputJs('main-js') }}#}
   {{ assets.outputCss('blog-css') }}
    {{ assets.outputJs('blog-js') }}

    {{ partial('layouts/header') }}

{{ partial('layouts/nav') }}
{#<body>#}
    <div class="container">
            {{ content() }}
    </div>
{#</body>#}
{{ partial('layouts/footer') }}




