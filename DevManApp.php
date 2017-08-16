<?php

namespace axenox\DevMan;

use exface\Core\Interfaces\InstallerInterface;
use exface\SqlDataConnector\SqlSchemaInstaller;
use exface\Core\CommonLogic\Model\App;

class DevManApp extends App
{

    public function getInstaller(InstallerInterface $injected_installer = null)
    {
        $installer = parent::getInstaller($injected_installer);
        
        $schema_installer = new SqlSchemaInstaller($this->getNameResolver());
        $schema_installer->setDataConnection($this->getWorkbench()->model()->getObject('axenox.DevMan.topic')->getDataConnection());
        $schema_installer->setLastUpdateIdConfigOption('LAST_PERFORMED_MODEL_SOURCE_UPDATE_ID');
        $installer->addInstaller($schema_installer);
        
        return $installer;
    }
}	