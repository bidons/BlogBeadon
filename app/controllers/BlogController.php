<?php

class BlogController extends ControllerBase
{
    protected $table;
    protected $table_condition;
    use DataTableControllerTraitExt;

    public function initialize()
    {
        parent::initialize();

        $this->table = $_GET['objdb'] ?? 'vw_pg_stat_activity';
        $this -> table_condition = $_GET;
    }

    public function indexAction()
    {
        $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
    }

    public function part1Action()
    {
        $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_ACTION_VIEW);

    }
}
