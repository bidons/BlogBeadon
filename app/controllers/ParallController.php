<?php

use Phalcon\Mvc\Model\Query;

class ParallController extends ControllerBase
{
    public function initialize()
    {
        parent::initialize();
        $this->view->setVar('projectTree',projectTree('parall'));

    }
    public function indexAction()
    {
        $result_js = $this->getDI()->getShared("db")->fetchAll("
        select id,parent,concat(text,' (',found_word,'/',total_word,')') as text
        from bible_tree;");

        $this->view->setVar('js_tree_data', json_encode($result_js));
    }

    public function biblePieAction($section_id)
    {
        $query = "select charts from bible_tree where id = $section_id";
        $result = $this->modelsManager->exeQrScalar($query);

        return $result;
    }

    public function part1Action()
    {
    }

    public function bookAction($bible_tree_id)
    {
        $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_ACTION_VIEW);

        $query = "select json_agg(json_build_object('id',id,'text',text))
                  from bible_tree where parent = '$bible_tree_id'";

        $result = $this->modelsManager->exeQrScalar($query);

        return $result;
    }
}
