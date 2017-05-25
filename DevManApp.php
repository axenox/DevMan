<?php

namespace axenox\DevMan;

use exface\Core\Interfaces\InstallerInterface;
use exface\SqlDataConnector\SqlSchemaInstaller;

class DevManApp extends \exface\Core\CommonLogic\AbstractApp
{

    public function getInstaller(InstallerInterface $injected_installer = null)
    {
        $installer = parent::getInstaller($injected_installer);
        
        $schema_installer = new SqlSchemaInstaller($this->getNameResolver());
        $schema_installer->setDataConnection($this->getWorkbench()
            ->model()
            ->getObject('axenox.DevMan.topic')
            ->getDataConnection());
        $installer->addInstaller($schema_installer);
        
        return $installer;
    }
}	