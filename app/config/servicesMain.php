<?php
/**
 * File with services configuration for all application
 * @copyright (c) SOSCredit
 */

use Phalcon\Cache\Backend\Redis as BackRedis;
use Phalcon\Cache\Frontend\Data as FrontData;

/**
 * Database connection is created based in the parameters defined in the configuration file
 */
$di->set(
    'db',
    function () use ($config, $di) {
        $em = $di->getShared('eventsManager');

        if ($config->get('databaseLog')) {
            $logger = new \Phalcon\Logger\Adapter\File($config->path('application.logDir')."db_log.log");

            $em->attach(
                "db:beforeQuery",
                function ($event, $connection) use ($logger) {
                    /** @var \Phalcon\Db\AdapterInterface $connection */
                    $sqlVariables = $connection->getSQLVariables();
                    $logger->log(
                        $connection->getSQLStatement()
                            ."; PLACEHOLDERS: ".str_replace("\n", " ", var_export($sqlVariables, true)),
                        \Phalcon\Logger::INFO
                    );
                }
            );
        }

        $adapter = new \App\Library\Model\PgPdoAdapter(array(
            'host'     => $config->path('database.host'),
            'username' => $config->path('database.username'),
            'password' => $config->path('database.password'),
            'dbname'   => $config->path('database.dbname')
        ));

        // Apply TimeZone (Event afterConnect was not work =( )
        $adapter->execute("SET TIME ZONE '{$config->path('application.localTZ')}'");

        $adapter->setEventsManager($em);

        return $adapter;
    }
);

/**
 * Database connection is created based in the parameters defined in the configuration file
 */
$di->set(
    'dbRead1',
    function () use ($config, $di) {
        $em = $di->getShared('eventsManager');

        if ($config->get('databaseLog')) {
            $logger = new \Phalcon\Logger\Adapter\File($config->path('application.logDir')."db_log.log");

            $em->attach(
                "db:beforeQuery",
                function ($event, $connection) use ($logger) {
                    /** @var \Phalcon\Db\AdapterInterface $connection */
                    $sqlVariables = $connection->getSQLVariables();
                    $logger->log(
                        $connection->getSQLStatement()
                            ."; PLACEHOLDERS: "
                            .str_replace("\n", " ", var_export($sqlVariables, true)),
                        \Phalcon\Logger::INFO
                    );
                }
            );
        }

        $adapter = new \App\Library\Model\PgPdoAdapter(array(
            'host'     => $config->path('databaseRead1.host'),
            'username' => $config->path('databaseRead1.username'),
            'password' => $config->path('databaseRead1.password'),
            'dbname'   => $config->path('databaseRead1.dbname')
        ));

        // Apply TimeZone (Event afterConnect was not work =( )
        $adapter->execute("SET TIME ZONE '{$config->path('application.localTZ')}'");

        $adapter->setEventsManager($em);

        return $adapter;
    }
);

$di->set('modelsMetadata', function () use ($config) {
    if ($config->path('modelsMetadata.cache_meta')) {
        $config = $config->get('redisCache')->toArray();

        $prefix = "prod";
        if (DEBUG) {
            $prefix = "dev";
        }

        $config["lifetime"] = 86400;
        $config["prefix"] = $prefix."_soscredit_models_meta_";

        $metaData = new \Phalcon\Mvc\Model\MetaData\Redis($config);
    } else {
        $metaData = new \Phalcon\Mvc\Model\MetaData\Memory($config);
    }

    return $metaData;
});


// Регистрация сервиса кэша моделей
$di->set(
    "modelsCache",
    function () use ($config) {
        // По умолчанию данные кэша хранятся один день
        $frontCache = new FrontData([
            "lifetime" => 86400
        ]);

        $cache = new BackRedis(
            $frontCache,
            $config->get('redisCache')->toArray()
        );

        return $cache;
    }
);

$di->setShared('eventsManager', function () use ($config) {
    $eventManager = new \Phalcon\Events\Manager();

    // Attach event listeners from config
    $listeners = $config->path('eventsManager.listeners')->toArray();
    foreach ($listeners as $component => $classes) {
        if (!is_array($classes)) {
            $classes = [$classes];
        }

        foreach ($classes as $class) {
            $listener = new $class();
            $eventManager->attach($component, $listener);
        }
    }

    return $eventManager;
});

$di->setShared('AMQPConnection', function () use ($config) {
    return new \PhpAmqpLib\Connection\AMQPStreamConnection(
        $config->path('AMQP.host'),
        $config->path('AMQP.port'),
        $config->path('AMQP.login'),
        $config->path('AMQP.password')
    );
});

$di->setShared('QueueService', function () {
    return new \App\Library\Queue\QueueService();
});

/**
 * Crypt service
 */
$di->set('crypt', function () use ($config) {
    $crypt = new \Phalcon\Crypt();
    $crypt->setKey($config->path('application.cryptSalt'));

    return $crypt;
});

$di->setShared('cache', function () use ($config) {
    $frontCache = new FrontData([
        "lifetime" => 3600*24
    ]);

    $cache = new BackRedis(
        $frontCache,
        $config->get('redisCache')->toArray()
    );

    return $cache;
});

$di->setShared('mailer', function () use ($config) {
    return new \App\Library\Mailer\Mailer();
});

$di->setShared('platon', function () {
    return new \App\Library\Platon\PlatonService();
});

$di->setShared('sms', function () use ($config) {
    return new \App\Library\Sms\SmsService();
});

$di->setShared('billing', function () use ($config) {
    return new \App\Library\Billing\BillingManager();
});

$di->setShared('pdf', function () {
    return new \App\Library\Pdf\Pdf();
});

$di->setShared('settings', function () {
    return new \App\Library\Settings\Settings();
});

$di->setShared('clientAttachmentService', function () {
    return new \App\Library\File\ClientAttachmentService();
});

$di->setShared('applicationAttachmentService', function () {
    return new \App\Library\File\ApplicationAttachmentService();
});

$di->setShared('prolongationAttachmentService', function () {
    return new \App\Library\File\ProlongationAttachmentService();
});

$di->setShared('pdfView', function () use ($config) {

    $view = new \Phalcon\Mvc\View();

    $view->setViewsDir($config->path('application.resourcesDir').'templates');

    $view->registerEngines(array(
        '.volt' => function ($view, $di) use ($config) {
            $volt = new Phalcon\Mvc\View\Engine\Volt($view, $di);

            $volt->setOptions(array(
                'compiledPath' => $config->path('application.cacheDir'),
                'compiledSeparator' => '_',
            ));

            // Object for creating custom function and filters to Volt Engine
            $compiler = $volt->getCompiler();

            $compiler->addFilter('str_num', function ($resolvedArgs, $exprArgs) {
                return "str_num({$resolvedArgs})";
            });

            $compiler->addFilter('number_format', function ($resolvedArgs, $exprArgs) {
                return "number_format({$resolvedArgs}, 2, '.', '')";
            });

            $compiler->addFilter('roundAmount', function ($resolvedArgs, $exprArgs) {
                return "roundAmount({$resolvedArgs})";
            });

            return $volt;
        },
        '.phtml' => 'Phalcon\Mvc\View\Engine\Php',
    ));

    return $view;
});

$di->setShared(
    'cpaService',
    function () {
        return new \App\Library\Cpa\CpaService();
    }
);


$di->setShared(
    'mbkiService',
    function () {
        return new \App\Library\Bki\MBki\MBkiService();
    }
);

$di->setShared(
    'pvbkiService',
    function () {
        return new \App\Library\Bki\PVBki\PVBkiService();
    }
);

$di->setShared(
    'bkiUploadService',
    function () {
        return new \App\Library\Bki\BkiUploadService();
    }
);

$di->setShared('counterService', function () {
    return new \App\Library\Counter\Counter();
});

$di->setShared('cmsMedia', function () use ($config) {
    $basePath = $config->path('application.publicDir').'/media-resources';
    $baseUrl = '/media-resources';

    return new \App\Library\File\FileManager\FileManager($basePath, $baseUrl);
});


$di->setShared('sentry', function () use ($config) {
// Sentry service to log exceptions
    return new App\Library\Logger\Adapter\Sentry($config);
});

$di->setShared('filter', function () use ($config) {
    $filter = new \Phalcon\Filter();

    $filter->add('phone', new \App\Library\CustomSanitizeFilters\PhoneFilter());
    $filter->add('clearDouble', new \App\Library\CustomSanitizeFilters\ClearDoubleCharsFilter());
    $filter->add('apostrophe', new \App\Library\CustomSanitizeFilters\ApostropheFilter());
    $filter->add('capitalize', new \App\Library\CustomSanitizeFilters\CapitalizeFilter());
    $filter->add('clear', new \App\Library\CustomSanitizeFilters\ClearFilter());
    $filter->add('emailASCII', new \App\Library\CustomSanitizeFilters\EmailToASCIIFilter());
    $filter->add('bool', new \App\Library\CustomSanitizeFilters\BoolFilter());

    return $filter;
});

$di->setShared('verificationService', function () {
    return new \App\Library\Verification\VerificationService();
});
