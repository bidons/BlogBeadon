<?php

class IndexController extends ControllerBase
{
    public function indexAction()
    {
        
    }
    public function aboutAction()
    {

    }

    public function contactAction()
    {
        
    }

    public function blogAction()
    {
        
    }


    function dd()
    {
        array_map(function ($x) {
            echo (new \Phalcon\Debug\Dump(null, true))->variable($x);
        }, func_get_args());
        die(1);
    }
}


