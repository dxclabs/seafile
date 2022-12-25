# seafile-ce-server

Seafile Community Edition Server built on Redhat UBI9

This server has nginx built in, but no memcache or mysql.

set the seafile version number in the docker file
retrieves seafile-ce-server package from AWS S3

uses external memcache (if configured), mysql

config files are provided by the container orchestrator - in our case Nomad
seahub-data, seafile-data and logs are provided by CSI volumes

To upgrade the seafile version, we rebuild the container and run upgrade command
