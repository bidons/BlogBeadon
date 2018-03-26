<?php

class IndexController extends ControllerBase
{
    use DataTableControllerTraitExt;

    public function indexAction()
    {
        
    }

    /*public function objectDbAction()
    {
        $result_js = $this->getDI()->getShared("db")->fetchAll("
        select ptt.id as id ,  '#'::text  as parent,Concat(coalesce(descr,name),' (',(select sum(m_count) from paging_table where paging_table_type_id = ptt.id),')') as text,ptt.name as view_name,null::jsonb as col,'unknown' as icon,null::text as view
        from paging_table_type as ptt
        where ptt.id in (1,2,4)
        UNION ALL
        select pt.id,ptt.id::text as parent,Concat(coalesce(pt.descr,pt.name),' (',m_count::text,')'),pt.name as view_name,jsonb_build_object('columns', m_prop_column_full -> 'columns') as col,'unknown',p.definition
        from paging_table as pt
        join pg_views as p on p.schemaname = 'public' and p.viewname = pt.name
        join paging_table_type as ptt on ptt.id = pt.paging_table_type_id and ptt.id in (1,2,4);");

        $this->view->setVar('js_tree_data', json_encode($result_js));

    }*/


    function dd()
    {
        array_map(function ($x) {
            echo (new \Phalcon\Debug\Dump(null, true))->variable($x);
        }, func_get_args());
        die(1);
    }
}


