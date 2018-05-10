<?php

namespace App\Library\Model;


use Phalcon\Mvc\Model\Manager;

class ModelsManager extends Manager
{
    protected $_lastQueryFn;

    public function exeFn($fn, $args = [], $returnArray = false)
    {
        $argsString = implode(',', array_map(
            function($value) {
                if (is_array($value)) {
                    return "'{$value[0]}'::{$value['type']}";
                } elseif (!is_numeric($value) && $value != '') {
                    return "'" . str_replace("'", "''", $value) . "'";
                } elseif ($value == '') {
                    return "null";
                } else {
                    return $value;
                }
            },
            $args))
        ;

        $sql = 'select '.$fn.'('.$argsString.')';

        $this->_lastQueryFn = $sql;

        try {
            $result = $this->getDI()->getShared('db')->fetchAll($sql);
        } catch (\PDOException $e) {
            dd($sql);
            return NULL;
        }

        $jsonResult = json_decode($result, $returnArray);

        if (json_last_error()) {
            var_dump('Wrong Format!');
            die();
        }

        return $jsonResult;
    }

    public function exeFnScalar($fn, $args = [], $returnArray = false)
    {
        $argsString = implode(',', array_map(
            function($value) {
                if (is_string($value) && $value != '') {
                    return "'" . str_replace("'", "''", $value) . "'";
                } elseif (is_array($value)) {
                    return "'{$value[0]}'::{$value['type']}";
                } elseif (!is_numeric($value) && $value != '') {
                    return "'" . str_replace("'", "''", $value) . "'";
                } elseif ($value == '') {
                    return "null";
                } else {
                    return $value;
                }
            },
            $args));

        $sql = 'select '.$fn.'('.$argsString.')';

        $this->_lastQueryFn = $sql;

        try {
            $result =  ($this->getDI()->getShared("db")->fetchOne($sql));
        } catch (\PDOException $e) {
            /*dd($sql);*/
            return NULL;
        }
        $result =  array_values($result)[0];

        $jsonResult = json_decode($result, $returnArray);

        if (json_last_error()) {
            return $result;
        }

        return $jsonResult;
    }

    public function exeQrScalar($query)
    {
        $query = $query . ' limit 1;';
        $this->_lastQueryFn = $query;

        try {
            $result =  ($this->getDI()->getShared("db")->fetchOne($query));
        } catch (\PDOException $e) {
            return NULL;
        }



        return reset($result);
    }
    public function getLastQueryFn()
    {
        return $this->_lastQueryFn;
    }

}