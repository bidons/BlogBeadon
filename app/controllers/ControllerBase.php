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
            ->addJs("plugins/bootstrap/dist/js/bootstrap.js")
            ->addJs("https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js?lang=sql")
            ->addJs("plugins/datatables/jquery.dataTables.min.js")
            ->addJs("main/js/DataTableWrapperExt.js")
            ->addJs("plugins/select2/select2.full.min.js")
            ->addJs("plugins/daterangepicker/moment.js")
            ->addJs("plugins/daterangepicker/daterangepicker.js")
            ->addJs("plugins/vakata/dist/jstree.min.js")
            ->addJs("plugins/proj4/dist/proj4.js")
            ->addJs("plugins/highcharts/highstock.js")
            ->addJs("plugins/highcharts/modules/map.js");
    }

    public function responseJson($data, $code = 200)
    {
        $this->view->disable();
        $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_NO_RENDER);


        $this->response->setJsonContent($data);

        return $this->response;
    }

    public function exeFnScalar(string $fn, $args = [], $returnArray = false)
    {
        $argsString = $this->handleArguments($args);

        $sql = 'select '.$fn.'('.$argsString.')';

        $this->_lastQueryFn = $sql;

        try {
            $result = $this->getDI()->getShared("db")->fetchOne($sql);
        } catch (\PDOException $e) {
            return null;
        }

        if (!$result) {
            return $result;
        }

        $result =  array_values($result)[0];

        $jsonResult = json_decode($result, $returnArray);

        if (json_last_error() != JSON_ERROR_NONE) {
            return $result;
        }

        return $jsonResult;
    }
}
