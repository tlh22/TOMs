# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ---------------------------------------------------------------------
# Tim Hancock/Matthias Kuhn 2017
# Oslandia 2022

from .tomsPlugin import TOMs


def classFactory(iface):  # pylint: disable=invalid-name
    """Load TOMs class from file TOMsPlugin.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """

    return TOMs()
