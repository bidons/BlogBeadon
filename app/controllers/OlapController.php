<?php

use Phalcon\Mvc\Model\Query;

class OlapController extends ControllerBase
{
    public function initialize()
    {
        parent::initialize();
    }
    public function indexAction() {}

    public function piechartAction()
    {
        $result = $this->modelsManager->exeFnScalar('pie_chart_marketing_build', [json_encode($_POST)], true);
        return $this->responseJson($result);
    }

    public function geochartAction()
    {
        $result = $this->modelsManager->exeFnScalar('geo_chart_marketing_build', [json_encode($_POST)], true);
        return $this->responseJson($result);
    }

    public function linechartAction()
    {
        $result = $this->modelsManager->exeFnScalar('line_chart_marketing_build', [json_encode($_POST)], true);
        return $this->responseJson($result);
    }

    public function profcategoryAction($argg)
    {
        $query = "with cte as(
                        SELECT
                          value_id as id,
                          Coalesce(first(value),'Не определён') as text
                        FROM client_dimension
                        WHERE type_id = '$argg'
                        GROUP BY type_id,value_id)
                    select json_agg(row_to_json(cte)) 
                    from cte;";

        $result = $this->getDi()->getShared("db")->fetchOne($query);

        return  $this->responseJson($result['json_agg']);
    }

    public function piecalendarAction()
    {
        $result = $this->modelsManager->exeFnScalar('pie_chart_marketing_calendar', [json_encode($_GET)], true);

        return $this->responseJson($result);
    }

}
