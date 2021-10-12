<?php


namespace axenox\DevMan\Facades;

use exface\Core\Facades\AbstractHttpFacade\AbstractHttpFacade;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use exface\Core\Factories\DataSheetFactory;
use exface\Core\DataTypes\StringDataType;
use GuzzleHttp\Psr7\Response;
use exface\Core\Factories\ActionFactory;

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
        $row = [
            'message' => addslashes(StringDataType::encodeUTF8($msg))
        ];
        $ds->addRow($row);
        $ds->dataCreate();
        $id = $ds->getRow(0)['id'];
        $action = ActionFactory::createFromString($exface, 'axenox.DevMan.ProcessWebhookMessage');
        $action->process($id);
        return new Response(200);
    }
    
    /**
     * 
     * {@inheritDoc}
     * @see \exface\Core\Facades\AbstractHttpFacade\AbstractHttpFacade::getUrlRouteDefault()
     */
    public function getUrlRouteDefault(): string
    {
        return 'api/webhook';
    }

    
}