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
        array(array("href"=>"/objectdb/index","name"=> "Пагинаторы: Введение","sname"=>"Введение"),
              array("href"=>"/objectdb/part1","name"=> "Пагинаторы: Cвязывание","sname"=>"Cвязывание"),
              array("href"=>"/objectdb/part2","name"=> "Пагинаторы: Планировщик запросов","sname"=>"Планировщик запросов"),
              array("href"=>"/objectdb/part3","name"=> "Пагинаторы: Предикаты","sname"=>"Предикаты"),
              array("href"=>"/objectdb/part4","name"=> "Пагинаторы: Materialize View","sname"=>"Materialize View"),
              array("href"=>"/objectdb/part5","name"=> "Пагинаторы: Исходники","sname"=>"Исходники"),
              array("href"=>"/objectdb/part6","name"=> "Пагинаторы: Пример конструктора","sname"=>"Пример конструктора")));
    if ($node){
        return $data[$node];
    }
    return $data;
};
