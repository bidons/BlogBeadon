<?php

class ObjectdbController extends ControllerBase
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
        $result_js = $this->getDI()->getShared("db")->fetchAll("
        select ptt.id as id ,  '#'::text  as parent,Concat(coalesce(descr,name),' (',(select sum(m_count) from paging_table where paging_table_type_id = ptt.id),')') as text,ptt.name as view_name,null::jsonb as col,'unknown' as icon,null::text as view
        from paging_table_type as ptt
        where ptt.id in (1,2,4,5)
        UNION ALL
        select pt.id,ptt.id::text as parent,Concat(coalesce(pt.descr,pt.name),' (',m_count::text,')'),pt.name as view_name,jsonb_build_object('columns', m_prop_column_full -> 'columns') as col,'unknown',p.definition
        from paging_table as pt
        left join pg_views as p on p.schemaname = 'public'  and p.viewname = pt.name
        left join pg_tables as pgt on pgt.schemaname = 'public' and pgt.tablename = pt.name
        join paging_table_type as ptt on ptt.id = pt.paging_table_type_id and ptt.id in (1,2,4,5);");


        $this->view->setVar('js_tree_data', json_encode($result_js));
    }

    public function part1Action()
    {

        $result_js = $this->getDI()->getShared("db")->fetchAll("
        select ptt.id as id ,  '#'::text  as parent,Concat(coalesce(descr,name),' (',(select sum(m_count) from paging_table where paging_table_type_id = ptt.id),')') as text,ptt.name as view_name,null::jsonb as col,'unknown' as icon,null::text as view
        from paging_table_type as ptt
        where ptt.id in (1,2,4,5)
        UNION ALL
        select pt.id,ptt.id::text as parent,Concat(coalesce(pt.descr,pt.name),' (',m_count::text,')'),pt.name as view_name,jsonb_build_object('columns', m_prop_column_full -> 'columns') as col,'unknown',p.definition
        from paging_table as pt
        left join pg_views as p on p.schemaname = 'public'  and p.viewname = pt.name
        left join pg_tables as pgt on pgt.schemaname = 'public' and pgt.tablename = pt.name
        join paging_table_type as ptt on ptt.id = pt.paging_table_type_id and ptt.id in (1,2,4,5);");


        $this->view->setVar('js_tree_data', json_encode($result_js));
    }

    public function part2Action()
    {
        $result_js = $this->getDI()->getShared("db")->fetchAll("
        select ptt.id as id ,  '#'::text  as parent,Concat(coalesce(descr,name),' (',(select sum(m_count) from paging_table where paging_table_type_id = ptt.id),')') as text,ptt.name as view_name,null::jsonb as col,'unknown' as icon,null::text as view
        from paging_table_type as ptt
        where ptt.id in (1,2,4,5)
        UNION ALL
        select pt.id,ptt.id::text as parent,Concat(coalesce(pt.descr,pt.name),' (',m_count::text,')'),pt.name as view_name,jsonb_build_object('columns', m_prop_column_full -> 'columns') as col,'unknown',p.definition
        from paging_table as pt
        left join pg_views as p on p.schemaname = 'public'  and p.viewname = pt.name
        left join pg_tables as pgt on pgt.schemaname = 'public' and pgt.tablename = pt.name
        join paging_table_type as ptt on ptt.id = pt.paging_table_type_id and ptt.id in (1,2,4,5);");


        $this->view->setVar('js_tree_data', json_encode($result_js));
      
    }

    public function part3Action()
    {
        $result_js = $this->getDI()->getShared("db")->fetchAll("
        select ptt.id as id ,  '#'::text  as parent,Concat(coalesce(descr,name),' (',(select sum(m_count) from paging_table where paging_table_type_id = ptt.id),')') as text,ptt.name as view_name,null::jsonb as col,'unknown' as icon,null::text as view
        from paging_table_type as ptt
        where ptt.id in (1,2,4,5)
        UNION ALL
        select pt.id,ptt.id::text as parent,Concat(coalesce(pt.descr,pt.name),' (',m_count::text,')'),pt.name as view_name,jsonb_build_object('columns', m_prop_column_full -> 'columns') as col,'unknown',p.definition
        from paging_table as pt
        left join pg_views as p on p.schemaname = 'public'  and p.viewname = pt.name
        left join pg_tables as pgt on pgt.schemaname = 'public' and pgt.tablename = pt.name
        join paging_table_type as ptt on ptt.id = pt.paging_table_type_id and ptt.id in (1,2,4,5);");


        $this->view->setVar('js_tree_data', json_encode($result_js));

    }

}
