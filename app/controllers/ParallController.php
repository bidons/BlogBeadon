<?php

use Phalcon\Mvc\Model\Query;

class ParallController extends ControllerBase
{
    public function initialize()
    {
        parent::initialize();
    }

    public function indexAction()
    {
        $result_js = $this->getDI()->getShared("db")->fetchAll("
        select id,parent,concat(text,' (',found_word,'/',total_word,')') as text
        from bible_tree;
        ");

        $this->view->setVar('js_tree_data', json_encode($result_js));
    }

    public function biblePieAction($section_id)
    {
        $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_ACTION_VIEW);

        if ($section_id) {
            $result_js = $this->getDI()->getShared("db")->fetchAll("
        select charts
        from bible_tree
        where id = $section_id;");
        }

        return ($result_js[0]['charts']);
    }
}
