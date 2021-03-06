{{ assets.outputCss('main-css') }}
{{ assets.outputJs('main-js') }}

<style>

    /*.parcoords{
        background: url('/main/img/concrete_seamless.png');
        background-repeat: repeat;
        background-position: 0 0;
        background-color: #e2e2de;
    }
*/
    .parcoords > canvas {
        font: 14px sans-serif;
        position: absolute;
    }
    .parcoords > canvas {
        pointer-events: none;
    }
    .parcoords text.label {
        cursor: default;
    }
    .parcoords rect.background:hover {
        fill: rgba(120,120,120,0.2);
    }
    .parcoords canvas {
        opacity: 1;
        transition: opacity 0.3s;
        -moz-transition: opacity 0.3s;
        -webkit-transition: opacity 0.3s;
        -o-transition: opacity 0.3s;
    }
    .parcoords canvas.faded {
        opacity: 0.25;
    }
    .parcoords {
        -webkit-touch-callout: none;
        -webkit-user-select: none;
        -khtml-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
        background-color: white;
    }
</style>


<link rel="stylesheet" type="text/css" href="https://syntagmatic.github.io/parallel-coordinates/d3.parcoords.css">


<script src="/plugins/d3/d3.min.js"></script>
<script src="/plugins/d3/d3.parcoords.js"></script>

{{ partial('layouts/paralll') }}

<div class="container">
    <div class="row">
    <div id="example-progressive" class="parcoords" style="width:1000px;height:400px"></div>
    </div>
</div>

<script>
    $(document).ready(function () {

        var colors = d3.scale.category20b();

        d3.csv('/parallel/nutrients.csv', function (data) {

            /*var colorgen = d3.scale.ordinal()
                .range(["#a6cee3","#1f78b4","#b2df8a","#33a02c",
                    "#fb9a99","#e31a1c","#fdbf6f","#ff7f00",
                    "#cab2d6","#6a3d9a","#ffff99","#b15928"]);*/

            var color = function(d) { return colors(d.group); };


            var parcoords = d3.parcoords()("#example-progressive")
                .data(data)
                .hideAxis(["name"])
                .color(color)
                .alpha(0.25)
                .composite("darken")
                .margin({top: 24, left: 150, bottom: 12, right: 0})
                .mode("queue")
                .render()
                .brushMode("1D-axes");  // enable brushing

            parcoords.svg.selectAll("text")
                .style("font", "10px sans-serif");
        })
    });
</script>