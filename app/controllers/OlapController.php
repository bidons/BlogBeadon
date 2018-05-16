<?php

use Phalcon\Mvc\Model\Query;

class OlapController extends ControllerBase
{
    public function initialize()
    {
        parent::initialize();
        $this->view->setVar('projectTree',projectTree('olap'));
    }
    public function indexAction() {}
    public function part1Action() {}

    public function piechartAction()
    {
        $result = $this->modelsManager->exeFnScalar('get_pie_chart_olap', [json_encode($_GET)], true);
        return $this->responseJson($result);
    }

    public function geochartAction()
    {
        $result = $this->modelsManager->exeFnScalar('get_geo_chart_olap', [json_encode($_GET)], true);
        return $this->responseJson($result);
    }

    public function linechartAction()
    {
        $result = $this->modelsManager->exeFnScalar('get_line_chart_olap', [json_encode($_GET)], true);
        return $this->responseJson($result);
    }

    public function profcategoryAction($argg)
    {
        $query = "with cte as(
                        SELECT
                          value_id as id,
                          Coalesce(first(value),'Не определён') as text
                        FROM client_dimension_guide
                        WHERE type_id = '$argg'
                        GROUP BY type_id,value_id)
                    select json_agg(row_to_json(cte)) 
                    from cte";

        $result = $this->modelsManager->exeQrScalar($query);

        return  $result;
    }
}
