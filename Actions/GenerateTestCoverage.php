<?php
namespace axenox\DevMan\Actions;

use exface\Core\Interfaces\Tasks\ResultInterface;
use exface\Core\Interfaces\Tasks\TaskInterface;
use exface\Core\Interfaces\DataSources\DataTransactionInterface;
use exface\Core\Factories\DataSheetFactory;
use exface\Core\CommonLogic\AbstractAction;
use exface\Core\Factories\WidgetFactory;
use exface\Core\DataTypes\ComparatorDataType;
use exface\Core\CommonLogic\UxonObject;
use exface\Core\Interfaces\UxonSchemaInterface;
use exface\Core\Uxon\WidgetSchema;
use exface\Core\Factories\ResultFactory;
use exface\Core\Interfaces\Actions\iModifyData;
use exface\Core\Interfaces\DataSheets\DataSheetInterface;

class GenerateTestCoverage extends AbstractAction implements iModifyData
{
    private $filesLoaded = null;
    
    private $coveredCases = null;
    
    protected function perform(TaskInterface $task, DataTransactionInterface $transaction): ResultInterface
    {
        $inputData = $this->getInputDataSheet($task);
        
        $inputSchema = $inputData->getCellValue('schema', 0);
        $uxon = UxonObject::fromAnything($inputData->getCellValue('uxon', 0));
        $targetTCId = $inputData->getCellValue('test_case', 0);
        
        $uxonSchema = new WidgetSchema($this->getWorkbench());
        
        $resultData = $this->getCoverageData($targetTCId, $uxonSchema, $uxon, $transaction);
        
        if (! $resultData->isEmpty()) {
            $resultData->dataCreate(false, $transaction);
        }
        
        return ResultFactory::createDataResult($task, $resultData, 'Found ' . $resultData->countRows() . ' test cases covered');
    }
    
    protected function getCoverageData(int $testCaseId, UxonSchemaInterface $uxonSchema, UxonObject $uxon, DataTransactionInterface $transaction) : DataSheetInterface
    {
        $resultData = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.test_case_coverage');
        
        $widgetType = $uxon->getProperty('widget_type');
        $widgetClass = WidgetFactory::getWidgetClassFromType($widgetType);
        $widgetFile = trim(str_replace(DIRECTORY_SEPARATOR, '/', $widgetClass) . '.php', '/');
        
        foreach ($uxon->getPropertiesAll() as $prop => $val) {
            $coversTcIds = $this->findTestCasesCovered($uxonSchema->getSchemaName(), $widgetFile, $prop, $val, $widgetType, $transaction, $uxonSchema, $widgetClass);
            foreach ($coversTcIds as $tcId) {
                if (! in_array($tcId, $this->getTestCasesCovered($testCaseId))) {
                    $resultData->addRow([
                        'test_case' => $testCaseId,
                        'covers_test_case' => $tcId
                    ]);
                    $this->addTestCaseCovered($testCaseId, $tcId);
                }
            }
        }
        
        return $resultData;
    }
    
    protected function findTestCasesCovered(string $schema, string $file, string $option, $value, string $componentName, DataTransactionInterface $transaction, UxonSchemaInterface $uxonSchema = null, string $uxonPrototypeClass = null) : array
    {
        $ids = [];
        if ($this->filesLoaded[$file] === null) {
            $ds = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.test_case_files');
            $ds->getColumns()->addMultiple([
                'id',
                'schema',
                'file',
                'option',
                'test_case'
            ]);
            $ds->getFilters()->addConditionFromString('file', $file, ComparatorDataType::EQUALS);
            $ds->dataRead();
            $this->filesLoaded[$file] = $ds;
        }
        
        foreach ($this->filesLoaded[$file]->getRows() as $row) {
            if ($row['schema'] === $schema && $row['option'] === $option) {
                if ($uxonSchema && $uxonPrototypeClass) {
                    foreach ($uxonSchema->getPropertyTypes($uxonPrototypeClass, $option) as $uxonType) {
                        if (substr($uxonType, 0, 1) === '\\') {
                            if ($value instanceof UxonObject) {
                                if ($value->isArray()) {
                                    foreach ($value->getPropertiesAll() as $valObj) {
                                        
                                    }
                                }
                            }
                            continue 2;
                        }
                    }
                    
                }
                if ($row['test_case'] === null) {
                    $moduleId = 2; // TODO
                    $featureSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.feature');
                    $featureSheet->getColumns()->addFromSystemAttributes();
                    $featureSheet->getFilters()->addConditionFromString('name', $componentName, ComparatorDataType::EQUALS);
                    $featureSheet->getFilters()->addConditionFromString('module', $moduleId, ComparatorDataType::EQUALS);
                    $featureSheet->dataRead();
                    if ($featureSheet->countRows() === 0) {
                        $featureSheet->addRow([
                            'module' => $moduleId,
                            'name' => $componentName
                        ]);
                        $featureSheet->dataCreate(false, $transaction);
                    }
                    $featureId = $featureSheet->getCellValue('id', 0);
                    
                    $tcSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.test_case');
                    $tcSheet->getColumns()->addFromSystemAttributes();
                    $tcSheet->addRow([
                        'name' => ucfirst($schema) . ' ' . $componentName . ' with option `' . $option . '` set',
                        'feature' => $featureId
                    ]);
                    $tcSheet->dataCreate(false, $transaction);
                    $tcId = $tcSheet->getCellValue('id', 0);
                    
                    $fileUpdateSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.test_case_files');
                    $fileUpdateSheet->addRow([
                        'test_case' => $tcId,
                        'id' => $row['id'],
                        'modified_on' => $row['modified_on']
                    ]);
                    $fileUpdateSheet->dataUpdate(false, $transaction);
                    $this->filesLoaded[$file]->dataRead();
                    $ids[] = $tcId;
                    return $ids;
                }
                $ids[] = $row['test_case'];
                return $ids;
            }
        }
        
        return $ids;
    }
    
    protected function getTestCasesCovered($testCaseId) : array
    {
        if ($this->coveredCases === null) {
            $ds = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.test_case_coverage');
            $ds->getColumns()->addFromExpression('covers_test_case');
            $ds->getFilters()->addConditionFromString('test_case', $testCaseId);
            $ds->dataRead();
            $this->coveredCases = $ds->getColumns()->get('covers_test_case')->getValues();
        }
        return $this->coveredCases;
    }
    
    protected function addTestCaseCovered(int $testCaseId, int $coversTestCaseId) : GenerateTestCoverage
    {
        $this->coveredCases[] = $coversTestCaseId;
        return $this;
    }
}