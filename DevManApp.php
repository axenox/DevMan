<?php

namespace axenox\DevMan;

use exface\Core\Interfaces\InstallerInterface;
use exface\Core\CommonLogic\Model\App;
use exface\Core\CommonLogic\AppInstallers\MySqlDatabaseInstaller;

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
        ->setDataSourceSelector('0x11eab5facf6370bab5fa0205857feb80');
        $installer->addInstaller($sqlInstaller);
        
        return $installer;
    }
}	