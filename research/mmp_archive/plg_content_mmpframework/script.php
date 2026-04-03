<?php
defined('_JEXEC') or die;

use Joomla\CMS\Factory;
use Joomla\CMS\Installer\InstallerScript;

class PlgContentMmpframeworkInstallerScript extends InstallerScript
{
    protected $minimumJoomla = '5.0.0';
    protected $minimumPhp = '8.1.0';
    protected $extension = 'plg_content_mmpframework';

    public function install($parent)
    {
        $this->enablePlugin();
        return true;
    }

    public function postflight($type, $parent)
    {
        if ($type === 'install') {
            $this->displayInstallationMessage();
        }
        return true;
    }

    private function enablePlugin()
    {
        $db = Factory::getDbo();
        $query = $db->getQuery(true)
            ->update('#__extensions')
            ->set('enabled = 1')
            ->where('element = ' . $db->quote('mmpframework'))
            ->where('folder = ' . $db->quote('content'))
            ->where('type = ' . $db->quote('plugin'));

        $db->setQuery($query);
        $db->execute();
    }

    private function displayInstallationMessage()
    {
        $app = Factory::getApplication();
        
        $message = '
        <div style="background: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 20px; border-radius: 5px;">
            <h3>🎉 MMP Framework Plugin Installed!</h3>
            <p><strong>Next Steps:</strong></p>
            <ol>
                <li>Create a new article and add <code>{mmpframework}</code> to trigger framework creation</li>
                <li>Go to Extensions → Plugins to configure settings</li>
                <li>Go to Menus → Manage to assign the MMP Framework menu</li>
            </ol>
        </div>';
        
        $app->enqueueMessage($message, 'message');
    }
}