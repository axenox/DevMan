<?php
namespace axenox\DevMan\Facades;

use exface\Core\Facades\AbstractHttpFacade\AbstractHttpFacade;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use exface\Core\Factories\DataSheetFactory;
use exface\Core\DataTypes\StringDataType;
use GuzzleHttp\Psr7\Response;
use exface\Core\Factories\ActionFactory;
use exface\Core\DataTypes\DateTimeDataType;
use axenox\DevMan\Actions\ProcessVcsUpdate;
use exface\Core\Exceptions\RuntimeException;

/**
 * Web service to receive webhooks from version control systems (e.g. Git)
 * 
 * See https://docs.github.com/en/developers/webhooks-and-events/webhooks/webhook-events-and-payloads#push
 * 
 * @author Ralf Mulansky
 *
 */
class WebhookFacade extends AbstractHttpFacade
{
    /**
     * 
     * @param ServerRequestInterface $request
     * @throws RuntimeException
     * @return ResponseInterface
     */
    protected function createResponse(ServerRequestInterface $request) : ResponseInterface
    {
        $exface = $this->getWorkbench();        
        
        $msg = $request->getBody()->__toString();
        try {
            $json = json_decode($msg, true);
            if ($json['repository']) {
                $repoUrl = ProcessVcsUpdate::findRepoUrlInGitWebhook($json);
            }
            if (! $repoUrl) {
                throw new RuntimeException('No repo URL found in webhook data!');
            }
        } catch (\Throwable $e) {
            $repoUrl = '';
            $this->getWorkbench()->getLogger()->logException($e);
        }
        
        $ds = DataSheetFactory::createFromObjectIdOrAlias($exface, 'axenox.DevMan.webhook_log');
        $ds->getColumns()->addMultiple([
            'id',
            'message',
            'received_on',
            'repo_url'
        ]);
        $ds->addRow([
            'message' => $msg,
            'received_on' => DateTimeDataType::now(),
            'repo_url' => $repoUrl
        ]);
        $ds->dataCreate();
        $id = $ds->getRow(0)['id'];
        
        $action = ActionFactory::createFromString($exface, ProcessVcsUpdate::class);
        $output = '';
        foreach ($action->processWebhook($id) as $msg) {
            // Ignore ouput
            // $output .= $msg;   
        }
        return new Response(200, [], $output);
    }
    
    /**
     * 
     * {@inheritDoc}
     * @see \exface\Core\Facades\AbstractHttpFacade\AbstractHttpFacade::getUrlRouteDefault()
     */
    public function getUrlRouteDefault(): string
    {
        return 'api/devman/webhook';
    }
}