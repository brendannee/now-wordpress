<?php

define('WP_CONTENT_DIR', '/var/www/public/wp-content');
define('DB_CHARSET',  'utf8mb4');

$table_prefix = 'wp_';

$dbkeys = array('DB_HOST', 'DB_NAME', 'DB_USER', 'DB_PASSWORD');
foreach($dbkeys as $dbkey) {
  define($dbkey, getenv($dbkey));
}

if (!defined('ABSPATH'))
    define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
