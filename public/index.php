<?php

use Phalcon\DI\FactoryDefault;
error_reporting(E_ALL);

try {

    $config = include __DIR__ . "/../app/config/config.php";
    include __DIR__ . "/../app/config/loader.php";
    include __DIR__ . "/../app/config/services.php";

    
    $application = new \Phalcon\Mvc\Application();
    $application->setDI($di);
    
    echo $application->handle()->getContent();
} catch (Phalcon\Exception $e) {
    echo $e->getMessage();
    die();
} catch (PDOException $e) {
    echo $e->getMessage();
}
