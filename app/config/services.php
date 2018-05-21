<?php

use Phalcon\DI\FactoryDefault;
use Phalcon\Mvc\View;
use Phalcon\Mvc\Url as UrlResolver;
use Phalcon\Db\Adapter\Pdo\Mysql as DbAdapter;
use Phalcon\Mvc\View\Engine\Volt as VoltEngine;
use Phalcon\Mvc\Model\Metadata\Memory as MetaDataAdapter;
use Phalcon\Session\Adapter\Files as SessionAdapter;
use Phalcon\Mvc\View\Engine\Php as PhpViewEngine;
use Phalcon\Cache\Backend\Redis;
use Phalcon\Cache\Frontend\Data as FrontData;

/**
 * The FactoryDefault Dependency Injector automatically registers the right
 * services to provide a full stack framework
 */
$di = new FactoryDefault();

/**
 * The URL component is used to generate all kind of urls in the application
 */
$di->set(
    "url",
    function () use ($config) {
        $url = new UrlResolver();

        $url->setBaseUri(
            $config->application->baseUri
        );

        return $url;
    },
    true
);
$listener = new \Phalcon\Debug();
$listener->listen();

$di->set('modelsManager', function () use ($di) {
    $manager = new \App\Library\Model\ModelsManager();
    $em = $di->getShared('eventsManager');
    $manager->setEventsManager($em);
    $manager->registerNamespaceAlias('Model', 'App\Models');

    return $manager;
});

$di->set(
    "view",
    function () use ($config) {
        $view = new View();

        $view->setViewsDir(
            $config->application->viewsDir
        );

        $view->registerEngines(
            [
                ".volt" => function ($view, $di) use ($config) {
                    $volt = new VoltEngine($view, $di);

                    $volt->setOptions(
                        [
                            "compiledPath"      => $config->application->cacheDir,
                            "compiledSeparator" => "_",
                        ]
                    );

                    return $volt;
                },

                // Generate Template files uses PHP itself as the template engine
                ".phtml" => PhpViewEngine::class
            ]
        );

        return $view;
    },
    true
);

$di->set(
    'db',
    function () use ($config, $di){
        $em = $di->getShared('eventsManager');
        
        if ($GLOBALS['DB_LOG']) {
            $logger = new \Phalcon\Logger\Adapter\File($config->application->logDir . 'db_log.log');
            
            $em->attach(
                "db:beforeQuery",
                function ($event, $connection) use ($logger) {
                    $sqlVariables = $connection->getSQLVariables();
                    $logger->log(
                        $connection->getSQLStatement()."; PLACEHOLDERS: ".str_replace("\n", " ", var_export($sqlVariables, true)),
                        \Phalcon\Logger::INFO
                    );
                }
            );
        }

        $adapter = new \Phalcon\Db\Adapter\Pdo\Postgresql(array(
            'host'     => $config->database->host,
            'username' => $config->database->username,
            'password' => $config->database->password,
            'dbname'   => $config->database->dbname
        ));

        $adapter->setEventsManager($em);

        return $adapter;
    }
);
/**
 * Start the session the first time some component request the session service
 */
$di->set(
    "session",
    function () {
        $session = new SessionAdapter();

        $session->start();

        return $session;
    }
);

$di->set('cache', function () use ($config) {
    $frontCache = new FrontData([
        "lifetime" => 172800
    ]);

    $cache = new Redis (
        $frontCache,
        $config->get('redisCache')->toArray()
    );

    return $cache;
});