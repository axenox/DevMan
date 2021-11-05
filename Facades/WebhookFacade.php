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

class WebhookFacade extends AbstractHttpFacade
{
    /**
     * 
     * {@inheritDoc}
     * @see \Psr\Http\Server\RequestHandlerInterface::handle()
     */
    public function handle(ServerRequestInterface $request): ResponseInterface
    {
        $exface = $this->getWorkbench();        
        
        $msg = $request->getBody()->__toString();
        try {
            $json = json_decode($msg, true);
            if ($json['repository']) {
                $repo = $json['repository']['html_url'] ?? $json['repository']['name'];
            }
        } catch (\Throwable $e) {
            $repo = '';
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
            'repo_url' => $repo
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