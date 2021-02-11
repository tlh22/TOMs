To run v2.18 qgis within docker ...

Use the kartoza image - https://hub.docker.com/r/kartoza/qgis-desktop

Command is:
docker run --rm --name="qgis-desktop-master" -i -t -v ${HOME}:/home/${USER} -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -w /home/QGIS -v /home/QGIS/2_18/plugins:/home/QGIS/plugins -v /home/QGIS/2_18/projects:/home/QGIS/projects -e QGIS_PLUGINPATH=/home/QGIS/plugins kartoza/qgis-desktop:2.18 

Plugin and project files are included as volumes. The container is able to access the test database. 

