import configparser
import logging
import os
import shutil
import sys
from pathlib import Path

_here = Path(__file__).absolute().parent

FORMAT = "%(asctime)-15s %(levelname)s %(filename)s:%(lineno)04d: %(message)s"
logging.basicConfig(
    level=logging._nameToLevel.get(  # pylint: disable=protected-access
        os.environ.get("LOGGING_LEVEL", "DEBUG").upper()
    ),
    format=FORMAT,
    stream=sys.stdout,
)
logger = logging.getLogger("aws_deploy")

config = configparser.ConfigParser()


def configProp(section, prop):
    try:
        return config[section][prop]
    except KeyError:
        sys.exit("Error reading property '{}' from section '{}'!".format(section, prop))


def copyFile(label: str, srcPath: str, destPath: str):
    finalSrcPath = Path(os.path.expandvars(srcPath))
    if not finalSrcPath.exists():
        sys.exit("'{}' file '{}' does not exist.".format(label, finalSrcPath))
    if not finalSrcPath.is_file():
        sys.exit("'{}' path '{}' is not a file.".format(label, finalSrcPath))

    finalDestPath = Path(os.path.expandvars(destPath))
    if not finalDestPath.exists():
        finalDestPath.mkdir(parents=True)

    finalDestPath = finalDestPath / finalSrcPath.name
    shutil.copyfile(finalSrcPath, finalDestPath)
    logger.info(
        "'{}' file '{}' copied to '{}'".format(label, finalSrcPath, finalDestPath)
    )


def copyDirectory(label: str, srcPath: str, destPath: str, purge=False):
    finalSrcPath = Path(os.path.expandvars(srcPath))
    if not finalSrcPath.exists():
        sys.exit("'{}' directory '{}' does not exist.".format(label, finalSrcPath))
    if not finalSrcPath.is_dir():
        sys.exit("'{}' path '{}' is not a directory.".format(label, finalSrcPath))

    finalDestPath = Path(os.path.expandvars(destPath))
    if not finalDestPath.exists():
        finalDestPath.mkdir(parents=True)

    finalDestPath = finalDestPath / finalSrcPath.parts[-1]

    if finalDestPath.exists() and purge:
        shutil.rmtree(finalDestPath)

    shutil.copytree(finalSrcPath, finalDestPath)
    logger.info(
        "'{}' directory '{}' copied to '{}'".format(label, finalSrcPath, finalDestPath)
    )


if __name__ == "__main__":
    # root path is the root directory of all plugin files, qgis projects, etc.
    rootPath = os.environ.get("DEPLOY_ROOT_DIR")
    if not rootPath:
        sys.exit("No root path defined! Use env var DEPLOY_ROOT_DIR!")
    if not os.path.exists(rootPath):
        sys.exit("Root directory '{}' does not exist.".format(rootPath))
    if not os.path.isdir(rootPath):
        sys.exit("Root directory '{}' is not a directory.".format(rootPath))

    os.environ["DEPLOY_ROOT_DIR"] = rootPath

    configFile = Path(
        os.environ.get("DEPLOY_CONFIG_FILE", str(_here / "aws_deploy.conf"))
    )
    if not configFile.exists():
        sys.exit("Config file '{}' does not exist!".format(configFile))
    try:
        config.read(configFile)
    except Exception as e:
        sys.exit("Error parsing config file '{}'! Error: {}".format(configFile), e)

    # ================ ELEVATION
    user = os.environ.get("AppStream_UserName")
    if not user:
        logger.warning("Unable to obtain appstream username, using guest mode.")
        mode = "guest"
    else:
        try:
            mode = config["users"][user]
            if mode not in ["operator", "admin"]:
                logger.warning(
                    "Unknown elevation ('{}'), using guest mode.".format(mode)
                )
                mode = "guest"

        except KeyError:
            logger.info(
                "Unable to find elevated permission for user '{}', using guest mode.".format(
                    user
                )
            )
            mode = "guest"

    os.environ["DEPLOY_USER_ELEVATION"] = mode

    # ================ QGIS
    copyFile(
        "Ini",
        configProp("qgis", "ini_file_path"),
        "%USERPROFILE%/AppData/Roaming/QGIS/QGIS3/profiles/default/QGIS/",
    )
    copyDirectory(
        "Plugin",
        configProp("qgis", "plugin_dir_path"),
        "%USERPROFILE%/AppData/Roaming/QGIS/QGIS3/profiles/default/python/plugins/",
        True,
    )

    # ================ PROJECT
    copyFile(
        "TOMs qgis project",
        configProp("toms", "qgis_project_file_path"),
        "c:/qgis_projects/",
    )
    copyFile("TOMs config", configProp("toms", "config_file_path"), "c:/qgis_projects/")

    # ================ PG_SERVICE
    copyFile(
        "PG service",
        configProp("pg_service", "conf_file_path"),
        "%APPDATA%/postgresql/",
    )

    imagePath = Path("c:/qgis_photo_path")
    if not imagePath.exists():
        imagePath.mkdir(parents=True)
