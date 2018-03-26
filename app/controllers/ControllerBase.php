<?php

use Phalcon\Mvc\Controller;

class ControllerBase extends Controller
{

    public function initialize()
    {
        /*$this->addAssetsMain();*/
        $this->addAssetsBlog();
    }

    protected function addAssetsMain()
    {
       $mainCss = $this->assets->collection("main-css");
        $mainJs =  $this->assets->collection("main-js");

        $mainCss
            ->addCss("plugins/bootstrap/dist/css/bootstrap.css")
            ->addCss("blog/css/blog.css");
        $mainJs -> addJs("main/js/jquery.js")
                ->addJs("plugins/bootstrap/dist/js/bootstrap.js");
    }

    protected function addAssetsBlog()
    {
        /*<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.4/js/bootstrap.min.js" />
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.4/js/bootstrap.min.js"></script>*/

        $blogCss = $this->assets->collection("blog-css");
        $blogJs =  $this->assets->collection("blog-js");
        
        $blogCss
            ->addCss("plugins/bootstrap/dist/css/bootstrap.css")
            /*->addCss("https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.css")*/
            ->addCss("plugins/datatables/jquery.dataTables.min.css")
            ->addCss("blog/css/blog.css")
            ->addCss("plugins/select2/select2.css")
            ->addCss("plugins/daterangepicker/daterangepicker-bs3.css")
            ->addCss("plugins/vakata/dist/themes/default/style.min.css");

        $blogJs -> addJs("main/js/jquery.js")
            /*->addJs("plugins/bootstrap/dist/js/bootstrap.bundle.min.js")*/
            ->addJs("plugins/bootstrap/dist/js/bootstrap.js")
            /*->addJs("https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.4/js/bootstrap.min.js")*/
            ->addJs("plugins/datatables/jquery.dataTables.min.js")
            ->addJs("main/js/DataTableWrapperExt.js")
            /*->addJs("https://code.highcharts.com/highcharts.js")
            ->addJs("https://code.highcharts.com/modules/wordcloud.js")*/
            /*->addJs("plugins/highcharts/highcharts.js")
            ->addJs("plugins/highcharts/modules/wordcloud.js")*/
            ->addJs("plugins/select2/select2.min.js")
            ->addJs("plugins/daterangepicker/moment.js")
            ->addJs("plugins/daterangepicker/daterangepicker.js")
            ->addJs("plugins/vakata/dist/jstree.min.js");
    }

    public function responseJson($data, $code = 200)
    {
        $this->view->disable();
        $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_NO_RENDER);


        $this->response->setJsonContent($data);

        return $this->response;
    }
}
