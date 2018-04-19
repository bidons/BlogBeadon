<?php


use Phalcon\Mvc\Controller;
use App\Modules\Backend\Controllers\ControllerBase;

trait DataTableControllerTraitExt
{
    public function showDataAction()
    {
        $result = $this->modelsManager->exeFnScalar('paging_objectdb', [json_encode($this -> table_condition)], true);
        return $this->responseJson($result);
    }

    public function txtSrchAction()
    {
        $data = json_encode($this->request->get());
        
        $result = $this->modelsManager->exeFnScalar('paging_object_db_srch', [$data], true);
        
        return $this->responseJson($result);
    }
}