<?php
namespace axenox\DevMan\Actions;

use exface\Core\CommonLogic\AbstractActionDeferred;
use exface\Core\Interfaces\DataSources\DataTransactionInterface;
use exface\Core\Interfaces\Tasks\ResultMessageStreamInterface;
use exface\Core\Interfaces\Tasks\TaskInterface;
use exface\Core\CommonLogic\Actions\ServiceParameter;
use exface\Core\Exceptions\Actions\ActionInputMissingError;
use exface\Core\Factories\DataSheetFactory;
use exface\Core\Exceptions\Actions\ActionInputInvalidObjectError;
use exface\Core\Interfaces\Actions\iCanBeCalledFromCLI;
use exface\Core\DataTypes\ComparatorDataType;
use exface\Core\Exceptions\Actions\ActionRuntimeError;
use exface\Core\DataTypes\DateTimeDataType;
use exface\Core\DataTypes\JsonDataType;
use exface\Core\Interfaces\Actions\iModifyData;
use exface\Core\DataTypes\BooleanDataType;
use exface\Core\Interfaces\Exceptions\ExceptionInterface;
use exface\Core\CommonLogic\Constants\Icons;

/**
 * 
 * @author Ralf Mulansky
 *
 */
class ProcessVcsUpdate extends AbstractActionDeferred implements iCanBeCalledFromCLI, iModifyData
{
    const INDENT = '  ';
    
    private $targetIds = null;
    
    /**
     * 
     * {@inheritDoc}
     * @see \exface\Core\CommonLogic\AbstractAction::init()
     */
    protected function init()
    {
        parent::init();
        $this->setIcon(Icons::COGS);
    }
    
    /**
     * 
     * {@inheritDoc}
     * @see \exface\Core\CommonLogic\AbstractActionDeferred::performImmediately()
     */
    protected function performImmediately(TaskInterface $task, DataTransactionInterface $transaction, ResultMessageStreamInterface $result): array
    {
        return [$this->getTargetIds($task), $transaction];
    }

    /**
     * 
     * {@inheritDoc}
     * @see \exface\Core\CommonLogic\AbstractActionDeferred::performDeferred()
     */
    protected function performDeferred(array $ids = [], DataTransactionInterface $transaction = null): \Generator
    {
        foreach ($ids as $id) {
            yield from $this->processWebhook($id, $transaction);
        }
        yield PHP_EOL . "Done.";
    }
    
    /**
     * 
     * @param int $webhookLogId
     * @param DataTransactionInterface $transaction
     * @return \Generator
     */
    public function processWebhook(int $webhookLogId, DataTransactionInterface $transaction = null) : \Generator
    {
        $processed = false;
        $result = '';
        $errorMessage = '';
        $errorLogId = null;
        
        if ($transaction === null) {
            $transaction = $this->getWorkbench()->data()->startTransaction();
            $autoCommit = true;
        } else {
            $autoCommit = false;
        }
        
        $webhookLogSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.webhook_log');
        $webhookLogSheet->getColumns()->addFromSystemAttributes();
        $webhookLogSheet->getColumns()->addMultiple([
            'message',
            'repo_url',
            'processed',
            'ignored'
        ]);
        $webhookLogSheet->getFilters()->addConditionFromString('id', $webhookLogId, EXF_COMPARATOR_EQUALS);
        $webhookLogSheet->dataRead();
        
        switch (true) {
            case $webhookLogSheet->isEmpty():
                $errorMessage .= 'Webhook log item with id "' . $webhookLogId . '" not found!' . PHP_EOL;
                $processed = false;
                break;
            case BooleanDataType::cast($webhookLogSheet->getCellValue('processed', 0)) === true:
                yield 'Skipping log item with id "' . $webhookLogId . '" as it was processed already!' . PHP_EOL;
                return;
            case BooleanDataType::cast($webhookLogSheet->getCellValue('ignored', 0)) === true:
                yield 'Skipping log item with id "' . $webhookLogId . '" as it is marked to be ignored!' . PHP_EOL;
                return;
            // IDEA add further cases here if there are will be other types of messages accept for Git push
            default:
                try {
                    $generator = $this->processGitPush($webhookLogSheet->getCellValue('message', 0), $webhookLogId, $transaction);
                    foreach ($generator as $yield) {
                        $result .= $yield;
                        yield $yield;
                    }
                    $processed = $generator->getReturn();
                } catch (\Throwable $e) {
                    $errorMessage = $e->getMessage();
                    if ($e instanceof ExceptionInterface) {
                        $errorLogId = $e->getId();
                    }
                    yield 'FAILED processing Git push message: ' . $errorMessage . PHP_EOL;
                    $processed = false;
                }
                break;
        }
        
        $logUpdateSheet = $webhookLogSheet->copy();
        $logUpdateSheet->getColumns()->removeByKey('message')->removeByKey('repo_url');
        $logUpdateSheet->setCellValue('processed', 0, ($processed ? 1 : 0));
        $logUpdateSheet->setCellValue('result', 0, $result);
        $logUpdateSheet->setCellValue('failed', 0, ($errorMessage !== '' ? 1 : 0));
        $logUpdateSheet->setCellValue('failed_message', 0, $errorMessage);
        $logUpdateSheet->setCellValue('failed_log_id', 0, $errorLogId);
        $logUpdateSheet->dataUpdate(false, $transaction);
        
        if ($autoCommit) {
            $transaction->commit();
        }
    }
    
    /**
     * 
     * @param string $message
     * @param int $webhookLogId
     * @param DataTransactionInterface $transaction
     * @throws ActionRuntimeError
     * @return \Generator
     */
    protected function processGitPush(string $message, int $webhookLogId, DataTransactionInterface $transaction = null) : \Generator
    {
        $json = JsonDataType::decodeJson($message);
        $repoUrl = $json['repository']['html_url'];
        $applicationId = $this->getApplicationId($repoUrl);
        if (! $applicationId) {
            throw new ActionRuntimeError($this, 'No application found for repository URL "' . $repoUrl . '"!');
        }
        
        if (! $json['commits'] || empty($json['commits'])) {
            yield 'Skipping log item with id "' . $webhookLogId . '" as it does not contain any commits!' . PHP_EOL;
            return false;
        }
        
        $branch = str_replace('refs/heads/', '', $json['ref']);
        
        foreach ($json['commits'] as $commit) {
            $updateDs = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.vcs_update');
            $updateDs->getColumns()->addFromUidAttribute();
            $updateDs->addRow([
                'application' => $applicationId,
                'update_time' => DateTimeDataType::formatDateNormalized(new \DateTime($commit['timestamp'])),
                'update_type' => 'git_commit',
                'name' => $commit['message'] ?? 'Unnamed Git commit',
                'branch' => $branch,
                'webhook_log' => $webhookLogId,
                'vcs_id' => $commit['id'],
                'vcs_url' => $commit['url'],
                'author_name' => ($commit['author'] ?? $commit['committer'] ?? [])['name']
            ]);
            $updateDs->dataCreate(false, $transaction);
            $vcsUpdateId = $updateDs->getUidColumn()->getValue(0);
            
            yield 'Processing Git commit "' . $commit['message'] . PHP_EOL;
            yield self::INDENT . 'Commit hash: ' . $commit['id'] . PHP_EOL;
            yield self::INDENT . 'Added files: ' . count($commit['added'] ?? []) . PHP_EOL;
            yield self::INDENT . 'Modified files: ' . count($commit['modified'] ?? []) . PHP_EOL;
            yield self::INDENT . 'Removed files: ' . count($commit['removed'] ?? []) . PHP_EOL;
            
            yield from $this->processFiles(array_merge($commit['modified'], $commit['added']), $commit['removed'], $applicationId, $vcsUpdateId, $transaction);
        }
        
        return true;
    }
    
    /**
     * 
     * @param array $modifiedFiles
     * @param array $deletedFiles
     * @param string $applicationId
     * @param string $vcsUpdateId
     * @param DataTransactionInterface $transaction
     * @return ProcessVcsUpdate
     */
    protected function processFiles(array $modifiedFiles, array $deletedFiles, string $applicationId, string $vcsUpdateId, DataTransactionInterface $transaction) : \Generator
    {
        $allFiles = array_unique(array_merge($modifiedFiles, $deletedFiles));
        $filesSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.application_file');
        $filesSheet->getColumns()->addFromUidAttribute();
        $filesSheet->getColumns()->addFromExpression('filepath');
        $filesSheet->getFilters()->addConditionFromValueArray('filepath', $allFiles);
        $filesSheet->getFilters()->addConditionFromString('application', $applicationId);
        $filesSheet->dataRead();
        
        $updatedFiles = [];
        $vcsUpdateFilesSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.vcs_update_files');
        foreach ($filesSheet->getRows() as $row) {
            $vcsUpdateFilesSheet->addRow([
                'vcs_update' => $vcsUpdateId,
                'application_file' => $row['id']
            ]);
            $updatedFiles[] = $row['filepath'];
            yield self::INDENT . 'Updating file ' . $row['filepath'] . PHP_EOL;
        }
        
        $newFiles = array_diff($allFiles, $updatedFiles);
        $newFilesSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.application_file');
        $newFilesSheet->getColumns()->addFromUidAttribute();
        foreach ($newFiles as $filepath) {
            $newFilesSheet->addRow([
                'application' => $applicationId,
                'filepath' => $filepath
            ]);
            yield self::INDENT . 'Adding file ' . $filepath . PHP_EOL;
        }
        if (! $newFilesSheet->isEmpty()) {
            $newFilesSheet->dataCreate(false, $transaction);
        }
        
        foreach ($newFilesSheet->getUidColumn()->getValues() as $newFileId) {
            $vcsUpdateFilesSheet->addRow([
                'vcs_update' => $vcsUpdateId,
                'application_file' => $newFileId
            ]);
        }
        if (! $vcsUpdateFilesSheet->isEmpty()) {
            $vcsUpdateFilesSheet->dataCreate(false, $transaction);
        }
        
        if (! empty($deletedFiles)) {
            $deletedFilesSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.application_file');
            $deletedFilesSheet->addRow([
                'deleted_flag' => 1,
                'modified_on' => DateTimeDataType::now()
            ]);
            $deletedFilesSheet->getFilters()->addConditionFromValueArray('filepath', $deletedFiles);
            $deletedFilesSheet->getFilters()->addConditionFromString('application', $applicationId);
            $deletedFilesSheet->dataUpdate(false, $transaction);
            yield self::INDENT . 'Marking ' . count($deletedFiles) . ' as deleted.' . PHP_EOL;
        }
    }
    
    /**
     * 
     * @param string $repoUrl
     * @return string|NULL
     */
    protected function getApplicationId(string $repoUrl) : ?string
    {
        $ds = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.application');
        $ds->getColumns()->addFromUidAttribute();
        $ds->getFilters()->addConditionFromString('package_url', $repoUrl, ComparatorDataType::EQUALS);
        $ds->dataRead();
        return $ds->getUidColumn()->getValue(0);
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
    
    /**
     * 
     * {@inheritDoc}
     * @see \exface\Core\Interfaces\Actions\iCanBeCalledFromCLI::getCliArguments()
     */
    public function getCliArguments(): array
    {
        return [
            (new ServiceParameter($this))->setName('ids')->setDescription('Comma-separated list of webhook log ids of the messages to precoess. Use * for all ids.')
        ];
    }
    
    /**
     * 
     * {@inheritDoc}
     * @see \exface\Core\Interfaces\Actions\iCanBeCalledFromCLI::getCliOptions()
     */
    public function getCliOptions(): array
    {
        return [];
    }
}