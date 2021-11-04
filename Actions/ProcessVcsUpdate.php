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
use exface\Core\Factories\ConditionGroupFactory;
use exface\Core\DataTypes\ComparatorDataType;
use exface\Core\Exceptions\Actions\ActionRuntimeError;
use exface\Core\DataTypes\DateTimeDataType;
use exface\Core\DataTypes\JsonDataType;
use exface\Core\Interfaces\Actions\iModifyData;
use exface\Core\DataTypes\BooleanDataType;

/**
 * 
 * @author Ralf Mulansky
 *
 */
class ProcessVcsUpdate extends AbstractActionDeferred implements iCanBeCalledFromCLI, iModifyData
{
    private $targetIds = null;
    
    protected function performImmediately(TaskInterface $task, DataTransactionInterface $transaction, ResultMessageStreamInterface $result): array
    {
        return [$this->getTargetIds($task), $transaction];
    }

    protected function performDeferred(array $ids = [], DataTransactionInterface $transaction = null): \Generator
    {
        foreach ($ids as $id) {
            yield from $this->processGitPush($id, $transaction);
        }
        yield PHP_EOL . "Done.";
    }
    
    public function processGitPush(int $webhookLogId, DataTransactionInterface $transaction = null) : \Generator
    {
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
            'processed'
        ]);
        $webhookLogSheet->getFilters()->addConditionFromString('id', $webhookLogId, EXF_COMPARATOR_EQUALS);
        $webhookLogSheet->dataRead();
        if ($webhookLogSheet->isEmpty()) {
            yield 'Webhook log item with id "' . $webhookLogId . '" not found!' . PHP_EOL;
            return;
        }
        
        if (BooleanDataType::cast($webhookLogSheet->getCellValue('processed', 0)) === true) {
            yield 'Skipping log item with id "' . $webhookLogId . '" as it was processed already!' . PHP_EOL;
            return;
        }
        
        $json = JsonDataType::decodeJson($webhookLogSheet->getCellValue('message', 0));
        
        $repoUrl = $webhookLogSheet->getCellValue('repo_url', 0) ?? $json['repository']['html_url'];
        $applicationId = $this->getApplicationId($repoUrl);
        if (! $applicationId) {
            throw new ActionRuntimeError($this, 'No application found for repository URL "' . $repoUrl . '"!');
        }
        
        if (! $json['commits'] || empty($json['commits'])) {
            yield 'Skipping log item with id "' . $webhookLogId . '" as it does not contain any commits!' . PHP_EOL;
            return;
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
            
            yield 'Processing Git commit ' . $commit['id'] . ': ' . $commit['message'] . PHP_EOL;
            
            yield from $this->processFiles(array_merge($commit['modified'], $commit['added']), $commit['removed'], $applicationId, $vcsUpdateId, $transaction);
        }
        
        $logUpdateSheet = $webhookLogSheet->copy();
        $logUpdateSheet->getColumns()->removeByKey('message')->removeByKey('repo_url');
        $logUpdateSheet->setCellValue('processed', 0, 1);
        $logUpdateSheet->dataUpdate(false, $transaction);
        
        if ($autoCommit) {
            $transaction->commit();
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
        }
        
        $newFiles = array_diff($allFiles, $updatedFiles);
        $newFilesSheet = DataSheetFactory::createFromObjectIdOrAlias($this->getWorkbench(), 'axenox.DevMan.application_file');
        $newFilesSheet->getColumns()->addFromUidAttribute();
        foreach ($newFiles as $filepath) {
            $newFilesSheet->addRow([
                'application' => $applicationId,
                'filepath' => $filepath
            ]);
        }
        if (! $newFilesSheet->isEmpty()) {
            $newFilesSheet->dataCreate(false, $transaction);
            yield '  Found ' . $newFilesSheet->countRows() . ' new files' . PHP_EOL;
        }
        
        foreach ($newFilesSheet->getUidColumn()->getValues() as $newFileId) {
            $vcsUpdateFilesSheet->addRow([
                'vcs_update' => $vcsUpdateId,
                'application_file' => $newFileId
            ]);
        }
        if (! $vcsUpdateFilesSheet->isEmpty()) {
            $vcsUpdateFilesSheet->dataCreate(false, $transaction);
            yield '  Registered updates on ' . $vcsUpdateFilesSheet->countRows() . ' files' . PHP_EOL;
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
            yield '  ' . 'Marked ' . count($deletedFiles) . ' as deleted.' . PHP_EOL;
        }
    }
    
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