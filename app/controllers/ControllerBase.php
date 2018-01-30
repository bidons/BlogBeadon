<?php

use Phalcon\Mvc\Controller;

class ControllerBase extends Controller
{

    public function initialize()
    {
        $this->addAssetsMain();
        $this->addAssetsBlog();
    }

    protected function addAssetsMain()
    {
        $mainCss = $this->assets->collection("main-css");
        $mainJs =  $this->assets->collection("main-js");


        // Add components
        $mainCss
            ->addCss("main/css/bootstrap.css")
            ->addCss("main/css/business-casual.css");

        $mainJs -> addJs("main/js/jquery.js")
                ->addJs("main/js/bootstrap.min.js")
        ;
    }

    protected function addAssetsBlog()
    {

        $blogCss = $this->assets->collection("blog-css");
        $blogJs =  $this->assets->collection("blog-js");


        $blogCss
            ->addCss("main/css/bootstrap.css")
            ->addCss("blog/css/blog.css")
            ->addCss("plugins/datatables/jquery.dataTables.min.css")
            ->addCss("plugins/select2/select2.css")
            ->addCss("plugins/daterangepicker/daterangepicker-bs3.css")
            ->addCss("plugins/vakata/dist/themes/default/style.min.css");

        $blogJs -> addJs("main/js/jquery.js")
            ->addJs("main/js/bootstrap.min.js")
            ->addJs("plugins/datatables/jquery.dataTables.min.js")
            ->addJs("main/js/DataTableWrapperExt.js")
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
