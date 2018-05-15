<?php

$GLOBALS['DB_LOG'] = true;

function dd()
{
    array_map(function ($x) {
        echo (new \Phalcon\Debug\Dump(null, true))->variable($x);
    }, func_get_args());

    die(1);
}

function projectTree($node)
{
    $data = array("objectdb"=>
        array(array("href"=>"/objectdb/index","name"=>"Введение (зачем, почему)"),
            array("href"=>"/objectdb/part1","name"=>"Реляционное связывание (таблиц и полей)"),
                array("href"=>"/objectdb/part2","name"=>"Особенности работы  (планировщика запросов) PostgreSQL"),
                    array("href"=>"/objectdb/part3","name"=>"Работы с фильтрами-условиями (предикативная логика)"),
                        array("href"=>"/objectdb/part4","name"=>"Материализация (Materialize View)"),
                            array("href"=>"/objectdb/part5","name"=>"Внутренности"),
                                array("href"=>"/objectdb/part6","name"=>"Создание конструкторов для поиска по DDL")));
    if ($node){
        return $data[$node];
    }
    return $data;

};