<?php
namespace axenox\DevMan\Actions;

use exface\Core\CommonLogic\AbstractActionDeferred;
use exface\Core\CommonLogic\Generator;
use exface\Core\Interfaces\DataSources\DataTransactionInterface;
use exface\Core\Interfaces\Tasks\ResultMessageStreamInterface;
use exface\Core\Interfaces\Tasks\TaskInterface;
use exface\Core\CommonLogic\Actions\ServiceParameter;
use exface\Core\Exceptions\Actions\ActionInputMissingError;
use exface\Core\Factories\DataSheetFactory;
use exface\Core\Exceptions\Actions\ActionInputInvalidObjectError;
use exface\Core\Interfaces\Actions\iCanBeCalledFromCLI;

class ProcessWebhookMessage extends AbstractActionDeferred implements iCanBeCalledFromCLI
{
    private $targetIds = null;
    
    protected function performImmediately(TaskInterface $task, DataTransactionInterface $transaction, ResultMessageStreamInterface $result): array
    {
        return [$this->getTargetIds($task)];
    }

    protected function performDeferred(array $ids = []): \Generator
    {
        $successful = 0;
        $failed = 0;
        foreach ($ids as $id) {
            $processed = $this->process($id);
            if ($processed) {
                $successful++;
            } else {
                $failed++;
            }
        }
        yield "Webhook messages processed. {$successful} messages successful processed, {$failed} messages failed to process!";
    }
    
    public function process(int $id): bool
    {
        $msgDs = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.webhook_log');
        $msgDs->getColumns()->addFromExpression('message');
        $msgDs->getFilters()->addConditionFromString('id', $id, EXF_COMPARATOR_EQUALS);
        $msgDs->dataRead();
        if ($msgDs->isEmpty()) {
            return false;
        }
        $msgJson = $msgDs->getRow(0)['message'];
        $msgArray = json_decode($msgJson, true);
        //TODO get files names from message
        
        return true;
    }
    
    /**
     *
     * @param TaskInterface $task
     * @throws ActionInputInvalidObjectError
     * @return string[]
     */
    protected function getTargetIds(TaskInterface $task) : array
    {
        if ($task->hasParameter('ids')) {
            $this->array_map('trim', explode(',', $task->getParameter('ids')));
        }
        
        $getAll = false;
        if (empty($this->targetIds) === false) {
            if (count($this->targetIds) === 1 && ($this->targetIds[0] === '*' || strcasecmp($this->targetIds[0], 'all') === 0)) {
                $getAll = true;
            } else {
                return $this->targetIds;
            }
        }
        
        try {
            $input = $this->getInputDataSheet($task);
        } catch (ActionInputMissingError $e) {
            if ($getAll) {
                $input = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.webhook_log');
            } else {
                $this->targetIds = [];
                return $this->targetIds;
            }
        }
        
        if ($input->getMetaObject()->isExactly('axenox.DevMan.webhook_log')) {
            $input->getColumns()->addFromExpression('id');
            if (! $input->isEmpty()) {
                if (! $input->isFresh()) {
                    $input->dataRead();
                }
            } elseif ($getAll === true || ! $input->getFilters()->isEmpty()) {
                $input->dataRead();
            }
            $this->targetIds = array_unique($input->getColumnValues('id', false));
        } else {
            throw new ActionInputInvalidObjectError($this, 'The action "' . $this->getAliasWithNamespace() . '" can only be called on the meta objects "axenox.DevMan.webhook_log" - "' . $input->getMetaObject()->getAliasWithNamespace() . '" given instead!');
        }
        
        return $this->targetIds;
    }
    
    public function getCliArguments(): array
    {
        return [
            (new ServiceParameter($this))->setName('ids')->setDescription('Comma-separated list of webhook log ids of the messages to precoess. Use * for all ids.')
        ];
    }
    
    public function getCliOptions(): array
    {
        return [];
    }
}