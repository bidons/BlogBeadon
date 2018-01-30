<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/pg.php'; //required api-base and other

$argg   = (json_encode($_GET));

$query = "select * from paging_objectdb_part_3('$argg')";
$result = PG::dbScalar($query);

print_r($result);

?>
