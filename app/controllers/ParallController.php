<?php

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

    public function part1Action()
    {

    }
}
