<?php

use Phalcon\Config;

return new Config(
    [
        "database" => [
            "adapter"     => "postgresql",
            "host"        => "localhost",
            "username"    => "root",
            "password"    => "root",
            "dbname"      => "blog",
        ],
        "application" => [
            "controllersDir" => __DIR__ . "/../../app/controllers/",
            "modelsDir"      => __DIR__ . "/../../app/models/",
            "viewsDir"       => __DIR__ . "/../../app/views/",
            "pluginsDir"     => __DIR__ . "/../../app/plugins/",
            "libraryDir"     => __DIR__ . "/../../app/library/",
            "cacheDir"       => __DIR__ . "/../../app/cache/",
            "baseUri"        => "/",
        ],
    ]
);
