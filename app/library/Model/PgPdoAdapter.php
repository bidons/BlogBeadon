<?php

namespace App\Library\Model;


use Phalcon\Db\Adapter\Pdo\Postgresql;

/**
 * Class PgPdoAdapter
 *
 * For use subquery and JSON query
 * Ex:
 *
 * UserModel::query()->where("PG_JSON_PATH(\"data->>'email'\") = :email:");
 *
 * $query->andWhere('SUBQUERY("SELECT count(*) FROM dealer_areas Areas where Areas.dealer_id = Dealers.id and Areas.state_cd = :state ") > 0', array('state' => $state));
 *
 * @package App\Library\Model
 */
class PgPdoAdapter extends Postgresql
{
    public function query($sqlStatement, $bindParams = null, $bindTypes = null)
    {
        $sqlStatement = $this->handle93syntax($sqlStatement);
        return parent::query($sqlStatement, $bindParams, $bindTypes);
    }

    private function handle93syntax($sqlStatement)
    {
        $specials = join('|', ['SUB_QUERY', 'PG_JSON_PATH', 'DATE_INTERVAL']);
        $pattern = "/($specials)[\\s]*\\([\\s]*\\'(.*?)\\'[\\s]*\\)/";

        $sqlStatement = preg_replace_callback(
            $pattern,
            function(array $matches){
                $content = str_replace("''", "'", $matches[2]);
                return $content;
            },
            $sqlStatement
        );

        return $sqlStatement;
    }
}