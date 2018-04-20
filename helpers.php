<?php

$GLOBALS['DB_LOG'] = true;

function dd()
{
    array_map(function ($x) {
        echo (new \Phalcon\Debug\Dump(null, true))->variable($x);
    }, func_get_args());

    die(1);
}
