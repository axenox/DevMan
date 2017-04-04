<?php namespace axenox\DevMan;
				
use exface\Core\Interfaces\InstallerInterface;
use exface\SqlDataConnector\SqlSchemaInstaller;

class DevManApp extends \exface\Core\CommonLogic\AbstractApp {
	
	public function get_installer(InstallerInterface $injected_installer = null){
		$installer = parent::get_installer($injected_installer);
		
		$schema_installer = new SqlSchemaInstaller($this->get_name_resolver());
		$schema_installer->set_data_connection($this->get_workbench()->model()->get_object('axenox.DevMan.topic')->get_data_connection());
		$installer->add_installer($schema_installer);
		
		return $installer;
	}
}	