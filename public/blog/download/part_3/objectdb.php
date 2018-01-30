<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/pg.php'; //required api-base and other

$query = "SELECT jsonb_agg(json_build_object('id',table_name,'text',table_name))::text
                  FROM (SELECT table_name
                        FROM information_schema.columns c
                        WHERE table_schema = 'public'
                        GROUP BY table_name) AS s";

$result = PG::dbScalar($query);

print_r($result);
