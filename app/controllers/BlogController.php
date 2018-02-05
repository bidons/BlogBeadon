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
        $result_js = $this->getDI()->getShared("db")->fetchAll("
       select ptt.id as id ,  '#'::text  as parent,coalesce(descr,name) as text,ptt.name as view_name,'glyphicon glyphicon-list-alt' as icon
            from paging_table_type as ptt
                where ptt.id != 1
        UNION ALL
        select pt.id,ptt.id::text as parent,coalesce(pt.descr,pt.name),pt.name as view_name,case when pt.is_materialyze then 'glyphicon glyphicon-camera' else 'glyphicon glyphicon-send' end as icon
        from paging_table as pt
        join paging_table_type as ptt on ptt.id = pt.paging_table_type_id and ptt.id != 1
    ");

        $this->view->setVar('js_tree_data', json_encode($result_js));

        $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_ACTION_VIEW);

    }
}
