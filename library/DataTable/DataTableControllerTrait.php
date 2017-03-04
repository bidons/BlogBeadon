<?php

namespace App\Modules\Backend\Library\DataTable;

use App\Modules\Backend\Controllers\ControllerBase;

/**
 * Class DataTableControllerTrait
 * @package App\Modules\Backend\Library\DataTable
 *
 * @property string $table
 */
trait DataTableControllerTrait
{
    public function getConditions()
    {
        /** @var ControllerBase $this */
        $data = $this->request->get();
        $data['objdb'] = $this->table;

        return $data;
    }

    public function showDataAction()
    {
        $data = $this->getConditions();
        $data = json_encode($data);

        /** @var ControllerBase $this */

        $result = $this->modelsManager->exeFnScalar('paging_objectdb', [$data, null, -1], true);

        return $this->responseJson($result);
    }

    public function idsDataAction()
    {
        $data = $this->getConditions();
        $data = json_encode($data);

        /** @var ControllerBase $this */

        $result = $this->modelsManager->exeFnScalar('paging_objectdb', [$data, null, -1], true);

        return $this->responseJson($result);
    }

    public function columnDataAction()
    {
        $data = $this->getConditions();

        /** @var ControllerBase $this */
        if (isset($data['visCol'])) {
            $data = json_encode($data['visCol']);
            $this->modelsManager->exeFnScalar('paging_dbnamespace_column_prop_save', [$data, $this->table], true);
        }

        $time = microtime();
        $result = $this->modelsManager->exeFnScalar('paging_dbnamespace_column_prop', [$this->table], true);

        $result = array_merge($result, ['createColumns' => ['query' => $this->modelsManager->getLastQueryFn(), 'time' => (microtime() - $time)]]);

        return $this->responseJson($result);
    }

    public function txtSrchAction()
    {
        $data = $this->getConditions();
        $data = json_encode($data);

        /** @var ControllerBase $this */
        $result = $this->modelsManager->exeFnScalar('paging_object_db_srch', [$data], true);

        if (empty($result)) {
            $result = [];
        }

        return $this->responseJson($result);
    }

}