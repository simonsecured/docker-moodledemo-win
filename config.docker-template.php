<?php
unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = getenv('MOODLE_DOCKER_DBTYPE');
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'db';
$CFG->dbname    = getenv('MOODLE_DOCKER_DBNAME');
$CFG->dbuser    = getenv('MOODLE_DOCKER_DBUSER');
$CFG->dbpass    = getenv('MOODLE_DOCKER_DBPASS');
$CFG->prefix    = 'm_';
$CFG->dboptions = ['dbcollation' => 'utf8mb4_bin'];

$hostname = getenv('MOODLE_DOCKER_HOST');
if (!empty($hostname)) {
    $CFG->wwwroot = $hostname;
    if (substr( $hostname, 0, 7 ) !== "http://") {
        $CFG->sslproxy = 1;
    }
} else {
    $CFG->wwwroot   = "http://localhost:8000";
}

$CFG->dataroot  = '/var/www/moodledata';
$CFG->admin     = 'admin';
$CFG->directorypermissions = 0777;
$CFG->smtphosts = 'mailhog:1025';
$CFG->noreplyaddress = 'noreply@example.com';

$CFG->allowthemechangeonurl = 1;
$CFG->passwordpolicy = 0;

require_once(__DIR__ . '/lib/setup.php');
