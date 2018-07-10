<?php

use Phalcon\Mvc\Controller;
use App\Library\Model\ModelsManager;

/**
 * Class ControllerBase
 *
 * @property ModelsManager $modelsManager
 */
class ControllerBase extends Controller
{
    public function initialize()
    {
        $this->addAssetsMain();
        $this->addAssetsDt();
    }

    protected function addAssetsMain()
    {
        $mainCss = $this->assets->collection("main-css");
        $mainJs = $this->assets->collection("main-js");

        $mainCss->addCss("components/bootstrap/dist/css/bootstrap.min.css")
                ->addCss("blog/css/blog.css");
        $mainJs ->addJs("components/jquery/dist/jquery.min.js")
                ->addJs("components/bootstrap/dist/js/bootstrap.min.js");
    }

    protected function addAssetsDt()
    {
        $css =  $this->assets->collection("blog-dt-css");
        $js =   $this->assets->collection("blog-dt-js");

        $css
            ->addCss("components/bootstrap/dist/css/bootstrap.min.css")
            ->addCss("components/datatable/media/css/dataTables.bootstrap4.min.css")
            ->addCss("blog/css/blog.css")
            ->addCss("components/select2/dist/css/select2.min.css")
            ->addCss("components/bootstrap-daterangepicker/daterangepicker.css");
        $js
            ->addJs("components/jquery/dist/jquery.min.js")
            ->addJs("components/datatable/media/js/jquery.dataTables.min.js")
            ->addJs("components/datatable/media/js/dataTables.bootstrap4.min.js")
            ->addJs("main/js/DataTableWrapperExt.js")
            ->addJs("components/select2/dist/js/select2.min.js")
            ->addJs("components/moment/moment.js")
            ->addJs("components/bootstrap-daterangepicker/daterangepicker.js")
            ->addJs("components/bootstrap/dist/js/bootstrap.min.js");
    }

    public function responseJson($data, $code = 200)
    {
        $this->view->disable();

        $this->response->setJsonContent($data);
        return $this->response;
    }
}
