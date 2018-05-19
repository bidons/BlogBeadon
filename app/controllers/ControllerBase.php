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

        $mainCss->addCss("plugins/bootstrap/dist/css/bootstrap.css")
            ->addCss("blog/css/blog.css");
        $mainJs->addJs("main/js/jquery.js")
            ->addJs("plugins/bootstrap/dist/js/bootstrap.js");
    }

    protected function addAssetsDt()
    {
        $css =  $this->assets->collection("blog-dt-css");
        $js =   $this->assets->collection("blog-dt-js");

        $css
            ->addCss("plugins/bootstrap/dist/css/bootstrap.css")
            ->addCss("plugins/datatables/dataTables.bootstrap4.min.css")
            ->addCss("blog/css/blog.css")
            ->addCss("plugins/select2/select2.css")
            ->addCss("plugins/daterangepicker/daterangepicker-bs3.css");
        $js
            ->addJs("main/js/jquery.js")
            ->addJs("plugins/bootstrap/dist/js/bootstrap.js")
            ->addJs("plugins/datatables/jquery.dataTables.min.js")
            ->addJs("plugins/datatables/dataTables.bootstrap4.min.js")
            ->addJs("main/js/DataTableWrapperExt.js")
            ->addJs("plugins/select2/select2.min.js")
            ->addJs("plugins/daterangepicker/moment.js")
            ->addJs("plugins/daterangepicker/daterangepicker.js");
    }

    public function responseJson($data, $code = 200)
    {
        $this->view->disable();

        $this->response->setJsonContent($data);
        return $this->response;
    }
}
