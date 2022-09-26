# Deploy

## Installation

1. On a EC2 server, add a share folder (to a directory `/home/ubuntu/appstream`) and user to the samba server:

   ```ini
   [appstream]
   comment = Appstream data
   path = /home/ubuntu/appstream
   guest ok = yes
   browseable = yes
   read only = yes
   ```

   and add user with `smbpasswd -a ubuntu`

1. inside `/home/ubuntu/appstream` create these directories :

   ```raw
   \- DEPLOY_LEVEL1/
   |  \- USER_ELEVATION1/
   |  |  |- .pg_service.conf
   |  |  |- CEC.qgs
   |  |  |- QGISCUSTOMIZATION3.ini
   |  |  |- TOMs.conf
   |  \- USER_ELEVATION2/
   |  |  |- .pg_service.conf
   |  |  |- CEC.qgs
   |  |  |- QGISCUSTOMIZATION3.ini
   |  |  |- TOMs.conf
   |  \- qgis_plugin/
   |  |  |- ...
   |  |- aws_deploy.conf
   \- DEPLOY_LEVEL2/
   |  \- USER_ELEVATION1/
   |  |  |- .pg_service.conf
   |  |  |- CEC.qgs
   |  |  |- QGISCUSTOMIZATION3.ini
   |  |  |- TOMs.conf
   |  \- USER_ELEVATION2/
   |  |  |- .pg_service.conf
   |  |  |- CEC.qgs
   |  |  |- QGISCUSTOMIZATION3.ini
   |  |  |- TOMs.conf
   |  \- qgis_plugin/
   |  |  |- ...
   |  |- aws_deploy.conf
   ```

   * `DEPLOY_LEVEL` are the different deploiment kind: prod, test, staging...
   * `USER_ELEVATION` are the different possible user elevation: admin, operator, guest...
   * The `.pg_service.conf` will contain valid information to connect to the databases used in the `CEC.qgs` QGis project file. Its format is like:

     ```ini
     [toms_db]
     host=toms-db.private-projectcenter.com
     dbname=toms
     port=5432
     user=toms_operator
     password=2022t4o8
     ```

   * The `QGISCUSTOMIZATION3.ini` contains QGis customizations like:

     ```ini
     Docks\ProcessingToolbox=false
     Toolbars\mAnnotationsToolBar=false
     Toolbars\mAttributesToolBar\ActionFeatureAction=false
     Toolbars\mAttributesToolBar\mActionMapTips=false
     Toolbars\mAttributesToolBar\mActionStatisticalSummary=false
     Toolbars\mAttributesToolBar\toolboxAction=false
     Toolbars\mDataSourceManagerToolBar=false
     Toolbars\mDigitizeToolBar\AllEditsMenu=false
     Toolbars\mDigitizeToolBar\mActionAddFeature=false
     Toolbars\mDigitizeToolBar\mActionCopyFeatures=false
     Toolbars\mDigitizeToolBar\mActionCutFeatures=false
     Toolbars\mDigitizeToolBar\mActionDeleteSelected=false
     Toolbars\mDigitizeToolBar\mActionMultiEditAttributes=false
     Toolbars\mDigitizeToolBar\mActionToggleEditing=false
     Toolbars\mFileToolBar=false
     Toolbars\mHelpToolBar=false
     Toolbars\mLabelToolBar\mActionDiagramProperties=false
     Toolbars\mLabelToolBar\mActionPinLabels=false
     Toolbars\mLayerToolBar=false
     Toolbars\mMapNavToolBar\mActionNew3DMapCanvas=false
     Toolbars\mMapNavToolBar\mActionTemporalController=false
     Toolbars\mMapNavToolBar\mActionZoomToLayers=false
     Toolbars\mMapNavToolBar\mActionZoomToSelected=false
     Toolbars\mMeshToolBar=false
     Toolbars\mPluginToolBar=false
     Toolbars\mRasterToolBar=false
     Toolbars\mSelectionToolBar=false
     Toolbars\mShapeDigitizeToolBar=false
     Toolbars\mShapeDigitizeToolBar\ActionAddCircle=false
     Toolbars\mShapeDigitizeToolBar\ActionAddCircularString=false
     Toolbars\mShapeDigitizeToolBar\ActionAddEllipse=false
     Toolbars\mShapeDigitizeToolBar\ActionAddRectangle=false
     Toolbars\mShapeDigitizeToolBar\ActionAddRegularPolygon=false
     Toolbars\mSnappingToolBar=false
     Toolbars\mVectorToolBar=false
     Toolbars\mWebToolBar=false
     Widgets\QgsAbout=false
     ```

   * The `TOMs.conf` contains the TOMs plugin configuration and must reference the plugin forms with this path:

     ```ini
     [TOMsLayers]
     form_path = %%USERPROFILE%%/AppData/Roaming/QGIS/QGIS3/profiles/default/python/plugins/TOMsPlugin/ui
     ```

  * The `qgis_plugin` directory is a clone of the [TOMs plugin](https://github.com/ProjectCentreLimited/TOMs.git)
  * The `aws_deploy.conf` describes the deployment configuration read by the `aws_deploy.py` script (on Windows)

    ```ini
    [users]
    benoit.de.mezzo@oslandia.com = admin

    ; Vars %%DEPLOY_ROOT_DIR%% and %%DEPLOY_USER_ELEVATION%% are generated at runtime
    [qgis]
    ini_file_path = %%DEPLOY_ROOT_DIR%%/%%DEPLOY_USER_ELEVATION%%/QGISCUSTOMIZATION3.ini
    plugin_dir_path = %%DEPLOY_ROOT_DIR%%/qgis_plugin/TOMsPlugin

    [toms]
    qgis_project_file_path = %%DEPLOY_ROOT_DIR%%/%%DEPLOY_USER_ELEVATION%%/CEC.qgs
    config_file_path = %%DEPLOY_ROOT_DIR%%/%%DEPLOY_USER_ELEVATION%%/TOMs.conf

    [pg_service]
    conf_file_path = %%DEPLOY_ROOT_DIR%%/%%DEPLOY_USER_ELEVATION%%/.pg_service.conf
    ```

1. On the `c:\script` directory of aws image builder, add a file `aws_startup.bat` with this content:

   ```bat
   @echo off
   net use S: /delete
   net use S: \\samba.private-projectcenter.com\appstream 2022u6 /user:ubuntu

   set DEPLOY_ROOT_DIR=\\samba.private-projectcenter.com\appstream\live
   set DEPLOY_CONFIG_FILE=%DEPLOY_ROOT_DIR%\aws_deploy.conf

   "C:\Program Files\QGIS 3.22.10\bin\python-qgis-ltr.bat" %DEPLOY_ROOT_DIR%\qgis_plugin\script\aws_deploy.py

   net use S: /delete
   ```

   * `\\samba.private-projectcenter.com\appstream` reference the share previouly created
   * `ubuntu` reference the user (smb) previously created
   * `DEPLOY_ROOT_DIR` references a deploy level directory inside `/home/ubuntu/appstream` (f.e. `live`)

1. Follow instructions [To link Amazon FSx file shares with AppStream 2.0](https://aws.amazon.com/fr/blogs/desktop-and-application-streaming/using-amazon-fsx-with-amazon-appstream-2-0/)
   to use the script `c:\script\aws_startup.bat`

## Updates

To update a deployment just update the files in a `DEPLOY_LEVEL` and for a `USER_ELEVATION` (from the EC2 servcer) and restart the AppStream session.
