<?php
namespace axenox\DevMan\Facades;

use exface\Core\Facades\AbstractHttpFacade\AbstractHttpFacade;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use exface\Core\Factories\DataSheetFactory;
use exface\Core\DataTypes\StringDataType;
use GuzzleHttp\Psr7\Response;
use exface\Core\Factories\ActionFactory;
use axenox\DevMan\Actions\ProcessWebhookMessage;
use exface\Core\DataTypes\DateTimeDataType;

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
        $ds = DataSheetFactory::createFromObjectIdOrAlias($exface, 'axenox.DevMan.webhook_log');
        $ds->getColumns()->addMultiple([
            'id',
            'message',
            'receive_datetime'
        ]);
        $ds->addRow([
            'message' => $msg,
            'receive_datetime' => DateTimeDataType::now()
        ]);
        $ds->dataCreate();
        $id = $ds->getRow(0)['id'];
        
        /*
        $action = ActionFactory::createFromString($exface, ProcessWebhookMessage::class);
        $action->process($id);
        */
        return new Response(200);
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