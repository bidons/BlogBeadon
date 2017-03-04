<?php

use Phalcon\Mvc\Controller;

class ControllerBase extends Controller
{

    public function initialize()
    {
        $this->addAssets();
    }

    protected function addAssets()
    {
        $this->assets->addCss("main/css/bootstrap.css");
        $this->assets->addCss("main/css/business-casual.css");
        $this->assets->addCss("main/css/blog.css");

        $this->assets->addJs("main/js/jquery.js");
        $this->assets->addJs("main/js/bootstrap.min.js");
    }
}
