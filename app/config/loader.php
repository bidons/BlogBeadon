<?php

use Phalcon\Loader;

$loader = new Loader();

/**
 * We're a registering a set of directories taken from the configuration file
 */
$loader->registerDirs(
    [
        $config->application->controllersDir,
        $config->application->modelsDir,
        $config->application->libraryDir,
        
    ]
);

$loader->registerNamespaces(
    [
        'App\Models' => $config->application->modelsDir,
        'App\Library' => $config->application->libraryDir,
    ],
    true
)->register();

$loader->register();
