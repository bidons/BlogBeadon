<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/pg.php'; //required api-base and other

$argg   = (json_encode($_GET));
$objname = $_GET['objdb'];
$query = "select paging_dbnamespace_column_prop('$objname')";
$result = PG::dbScalar($query);
print_r($result);

?>
