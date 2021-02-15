Notes for qgis-server

Soem useful notes:
https://docs.qgis.org/3.16/en/docs/server_manual/containerized_deployment.html
http://www.itopen.it/bulk/FOSS4G-IT-2020/#/presentation-title

Using openQuake docker image. Good setup notes here - https://github.com/gem/oq-qgis-server

Image includes nginx server - with option not to use. Have choosen to use separate server/external reverse proxy - and can link in with production server

to check - http://localhost:8011/ogc/test1?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities

To register server plugins

https://gis.stackexchange.com/questions/355319/register-custom-python-function-in-qgis-server-3-10



docker run --rm -ti -e DISPLAY=unix${DISPLAY} 
-v /tmp/.X11-unix:/tmp/.X11-unix 
-v ${HOME}:${HOME} openquake/qgis-server:ltr /usr/local/bin/start-client