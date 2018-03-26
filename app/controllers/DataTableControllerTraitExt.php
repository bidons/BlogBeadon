<?php


use Phalcon\Mvc\Controller;

trait DataTableControllerTraitExt
{
    public function showDataAction()
    {
        /** @var Controller $this */
        $data = json_encode($this -> table_condition);

        $query = "select paging_objectdb('{$data}',null,-1)";
        
        $result =  $this->getDi()->getShared("db")->fetchOne($query);
        $result = json_decode($result['paging_objectdb']);
        
        return $this->responseJson($result);
    }

  /*  public function idsDataAction()
    {
        $data = json_encode($this -> table_condition);

        $query = "select paging_objectdb('$data',null,-1)";

        $result =  $this->getDi()->getShared("db")->fetchOne($query);
        $result = json_decode($result['paging_objectdb']);

        return $this->responseJson($result);
    }
  */

    public function columnDataAction()
    {
        $data = json_encode($this -> table_condition);

        if(isset($data['visCol']))
        {
            /** @var Controller $this */
            $data = json_encode($data['visCol']);
            $query = "select paging_dbnamespace_column_prop_save('{$data}','{$this->table}')";
            $this->getDi()->getShared("db")->fetchOne($query);
        }

        /** @var Controller $this */
        $query = "select paging_dbnamespace_column_prop('{$this->table}')";
        $time = microtime();

        $result =  $this->getDi()->getShared("db")->fetchOne($query);

        $result = json_decode($result['paging_dbnamespace_column_prop'],true);
        $result += ['createColumns' => ['query' => $query,'time' => (microtime() - $time)]];

        return $this->responseJson($result);
    }

    public function txtSrchAction()
    {
        $data = json_encode($this->request->get());
        $result =  $this->getDi()->getShared("db")->fetchOne("select paging_object_db_srch('$data')");
        return $result['paging_object_db_srch'];
    }


}