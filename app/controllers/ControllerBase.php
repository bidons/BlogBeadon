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

        /*$mainCss
            ->addCss("plugins/bootstrap/dist/css/bootstrap.css")
            ->addCss("blog/css/blog.css");
        $mainJs -> addJs("main/js/jquery.js")
                ->addJs("plugins/bootstrap/dist/js/bootstrap.js");*/
    }

    protected function addAssetsBlog()
    {
        $blogCss = $this->assets->collection("blog-css");
        $blogJs =  $this->assets->collection("blog-js");
        
        $blogCss
            ->addCss("plugins/bootstrap/dist/css/bootstrap.css")
            ->addCss("plugins/datatables/jquery.dataTables.min.css")
            ->addCss("blog/css/blog.css")
            ->addCss("plugins/select2/select2.css")
            ->addCss("plugins/daterangepicker/daterangepicker-bs3.css")
            ->addCss("plugins/vakata/dist/themes/default/style.min.css");

        $blogJs -> addJs("main/js/jquery.js")
            ->addJs("https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-beta.3/js/bootstrap.js")
            ->addJs("plugins/bootstrap/dist/js/bootstrap.js")
            ->addJs("https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js?lang=sql")
            ->addJs("plugins/datatables/jquery.dataTables.min.js")
            ->addJs("main/js/DataTableWrapperExt.js")
            ->addJs("plugins/select2/select2.min.js")
            ->addJs("plugins/daterangepicker/moment.js")
            ->addJs("plugins/daterangepicker/daterangepicker.js")
            ->addJs("plugins/vakata/dist/jstree.min.js")
            ->addJs("plugins/highcharts/highstock.js");
    }

    public function responseJson($data, $code = 200)
    {
        $this->view->disable();
        $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_NO_RENDER);


        $this->response->setJsonContent($data);

        return $this->response;
    }
    
    
}
