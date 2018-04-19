<?php

$GLOBALS['DB_LOG'] = false;

function dd()
{
    array_map(function ($x) {
        echo (new \Phalcon\Debug\Dump(null, true))->variable($x);
    }, func_get_args());

    die(1);
}
