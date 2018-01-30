<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/pg.php'; //required api-base and other

$argg   = (json_encode($_GET));

$objname = $_GET['objdb'];

$query = "select * from paging_objectdb_part_1('$argg')";
$result = PG::dbScalar($query);

print_r($result);

?>
