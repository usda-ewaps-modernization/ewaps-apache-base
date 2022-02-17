LAP (LAMP without MySQL) on Docker
===

This is a docker container used on the USDA Enterprise Web Application Platform Service (EWAPS). It is designed to integrated with a Rancher-based orchestration system for the deployment and maintenance of web sites.  

This container can be used by contractors to develop and test web sites using the versions of PHP, Apache and their respective add-in components used by USDA's Office of Communication to ensure a smooth deployment from development to pre-production to production.  

Note: Versions of this container are limited to currently supported versions of PHP which, as of this README are PHP 7.3 and PHP 7.4. PHP 8.0 is not yet included.  

Drush is not included as a global install on these containers. Drush must be installed as part of your deployed project. Please make sure the DOCROOT of your application falls within `/var/application` in order to be accessible globally.  

Environment Variables
---

DOCROOT  
_The document root where Apache will be pointed. Should correlate roughly to the same as `GIT_DIR` however `DOCROOT` includes the directory inside GIT_DIR that has the site files in it._  

GIT_DIR  
_This is the path where the git repository will be placed._  

GIT_URL  
_The URL of the git repository that will be downloaded. Should include any and all credentials for authenticating into the repository._  

GIT_BRANCH  
_The branch in the git repository to be deployed._  

GIT_TAG  
_The tag in the git repository to be deployed._  

GRAV  
_Is this web site powered by Grav? Set to 1 if yes, leave undefined if no._  

HTACCESS_DESCRIPTION  
_Enable server-side .htaccess authentication. This is basic authentication only. This must be set in order for the username and password properties to be configured._  

HTACCESS_USERNAME  
_The username to be used with basic authentication .htaccess._  

HTACCESS_PASSWORD  
_The password associated with the username of basic authentication._  
