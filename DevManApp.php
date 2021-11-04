<?php
namespace axenox\DevMan;

use exface\Core\Interfaces\InstallerInterface;
use exface\Core\CommonLogic\Model\App;
use exface\Core\CommonLogic\AppInstallers\MySqlDatabaseInstaller;
use exface\Core\Facades\AbstractHttpFacade\HttpFacadeInstaller;
use exface\Core\Factories\FacadeFactory;
use axenox\DevMan\Facades\WebhookFacade;

class DevManApp extends App
{
    /**
     * 
     * {@inheritDoc}
     * @see \exface\Core\CommonLogic\Model\App::getInstaller()
     */
    public function getInstaller(InstallerInterface $injected_installer = null)
    {
        $installer = parent::getInstaller($injected_installer);
        
        $sqlInstaller = new MySqlDatabaseInstaller($this->getSelector());
        $sqlInstaller
        ->setFoldersWithMigrations(['InitDB','Migrations'])
        ->setFoldersWithStaticSql(['Views'])
        ->setDataSourceSelector('0x39000000000000000000000000000000');
        $installer->addInstaller($sqlInstaller);
        
        // Proxy facade
        $tplInstaller = new HttpFacadeInstaller($this->getSelector());
        $tplInstaller->setFacade(FacadeFactory::createFromString(WebhookFacade::class, $this->getWorkbench()));
        $installer->addInstaller($tplInstaller);
        
        return $installer;
    }
}	