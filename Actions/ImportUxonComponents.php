<?php
namespace axenox\DevMan\Actions;

use exface\Core\CommonLogic\AbstractActionDeferred;
use exface\Core\Interfaces\Actions\iCanBeCalledFromCLI;
use exface\Core\Interfaces\Actions\iModifyData;
use exface\Core\Interfaces\Tasks\TaskInterface;
use exface\Core\Interfaces\DataSources\DataTransactionInterface;
use exface\Core\Interfaces\Tasks\ResultMessageStreamInterface;
use exface\Core\Factories\DataSheetFactory;
use exface\Core\Uxon\WidgetSchema;
use exface\Core\DataTypes\PhpFilePathDataType;
use exface\Core\Interfaces\UxonSchemaInterface;

class ImportUxonComponents extends AbstractActionDeferred implements iCanBeCalledFromCLI, iModifyData
{
    
    /**
     *
     * {@inheritDoc}
     * @see \exface\Core\CommonLogic\AbstractActionDeferred::performImmediately()
     */
    protected function performImmediately(TaskInterface $task, DataTransactionInterface $transaction, ResultMessageStreamInterface $result) : array
    {
        return [];
    }
    
    /**
     *
     * {@inheritDoc}
     * @see \exface\Core\CommonLogic\AbstractActionDeferred::performDeferred()
     */
    protected function performDeferred() : \Generator
    {
        $newRows = [];
        $schema = new WidgetSchema($this->getWorkbench());
        
        $codeSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'exface.Core.WIDGET');
        $codeSheet->getColumns()->addMultiple([
            'PATHNAME_RELATIVE'
        ]);
        $codeSheet->dataRead();
        
        $dbSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.test_case_files');
        $dbSheet->getColumns()->addMultiple([
            'file',
            'option',
            'autocreated_flag'
        ]);
        $dbSheet->dataRead();
        $dbRows = $dbSheet->getRows();
        
        foreach ($codeSheet->getRows() as $row) {
            $file = $row['PATHNAME_RELATIVE'];
            $class = PhpFilePathDataType::findClassInFile($this->getWorkbench()->filemanager()->getPathToVendorFolder() . DIRECTORY_SEPARATOR . $file);
            yield 'Widget "' . $file . '": ';
            
            $fileOpts = [];
            foreach ($dbRows as $dbRow) {
                if ($dbRow['file'] === $file) {
                    $fileOpts[] = $dbRow;
                }
            }
            
            $props = $schema->getProperties($class);
            
            yield 'found ' . count($props) . ' properties.';
            
            foreach ($props as $prop) {
                foreach ($fileOpts as $dbIdx => $dbRow) {
                    if ($dbRow['file'] === $file && $dbRow['option'] === $prop) {
                        unset($fileOpts[$dbIdx]);
                        continue 2;
                    }
                }
                if ($prop && ! $this->isToBeSkipped($schema, $prop)) {
                    $newRows[] = [
                        'schema' => 'widget', // TODO make schema configurable!
                        'file' => $file, 
                        'option' => ($prop ?? ''), 
                        'autocreated_flag' => 1
                    ];
                    $newOpts[] = $prop;
                }
            }
            
            if (! empty($newOpts)) {
                yield PHP_EOL . '  New properties: ' . implode(', ', $newOpts);
            }
            
            yield PHP_EOL;
        }
        
        if (! empty($newRows)) {
            $ds = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.test_case_files');
            $ds->addRows($newRows);
            $ds->dataCreate(false);
            yield 'DONE: found ' . count($newRows) . ' new properties' . PHP_EOL;
        } else {
            yield 'DONE: no new properties found' . PHP_EOL;
        }
        
        return;
    }
    
    public function isToBeSkipped(UxonSchemaInterface $schema, string $property) : bool
    {
        switch (true) {
            case $schema instanceof WidgetSchema:
                switch ($property) {
                    case 'widget_type': return true;
                    case 'object_alias': return true;
                }
                break;
        }
        return false;
    }
    
    public function getCliArguments(): array
    {
        return [];
    }

    public function getCliOptions(): array
    {
        return [];
    }
}