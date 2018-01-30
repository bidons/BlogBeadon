<?php

class PG
{
    public static $conn = "host=localhost dbname=rudict user=root password=root";

    public static function db_cc()
    {
        return pg_connect(PG::$db_path_current);
    }

    public static function dbScalar($query)
    {
        return pg_fetch_result(pg_query(pg_connect(PG::$conn), $query), 0, 0);
    }
}



