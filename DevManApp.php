<?php

namespace axenox\DevMan;

use exface\Core\Interfaces\InstallerInterface;
use exface\Core\CommonLogic\AppInstallers\SqlSchemaInstaller;
use exface\Core\CommonLogic\Model\App;
use exface\Core\Exceptions\Model\MetaObjectNotFoundError;

class DevManApp extends App
{

    public function getInstaller(InstallerInterface $injected_installer = null)
    {
        $installer = parent::getInstaller($injected_installer);
        
        $schema_installer = new SqlSchemaInstaller($this->getSelector());
        $schema_installer->setLastUpdateIdConfigOption('LAST_PERFORMED_MODEL_SOURCE_UPDATE_ID');
        try {
            $schema_installer->setDataConnection($this->getWorkbench()->model()->getObject('axenox.DevMan.topic')->getDataConnection());
            $installer->addInstaller($schema_installer);
        } catch (MetaObjectNotFoundError $e) {
            $this->getWorkbench()->getLogger()->warning('Cannot init SqlSchemInstaller for app ' . $this->getAliasWithNamespace . ': no model there yet!');
        }
        
        return $installer;
    }
}	