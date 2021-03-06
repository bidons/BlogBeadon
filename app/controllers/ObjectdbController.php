<?php

class ObjectdbController extends ControllerBase
{
    protected $table;
    protected $table_condition;
    
    use DataTableControllerTraitExt;

    public function initialize()
    {
        parent::initialize();
        $this -> table_condition = $_GET;
        $this->view->setVar('projectTree',projectTree('objectdb'));
    }

    public function indexAction(){}
    public function part1Action(){}
    public function part2Action(){}
    public function part3Action(){}
    public function part4Action(){}
    public function part6Action(){}
    public function part5Action(){}

    public function viewChartAction($viewname)
    {
        $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
        $query = "SELECT pt.m_chart_json_data
                  FROM paging_table as p
                  LEFT JOIN paging_table_materialize_info as pt on p.last_paging_table_materialize_info_id = pt.id 
                  where name = '$viewname'";

        $result = $this->modelsManager->exeQrScalar($query);
        return $result;
    }
}
