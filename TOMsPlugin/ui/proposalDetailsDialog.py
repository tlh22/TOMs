# -----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# -----------------------------------------------------------
# Tim Hancock/Matthias Kuhn 2017
# Oslandia 2022

import os

from qgis.PyQt import QtWidgets, uic

FORM_CLASS, _ = uic.loadUiType(
    os.path.join(os.path.dirname(__file__), "proposal_details_dialog_base_qt5.ui")
)


class ProposalDetailsDialog(QtWidgets.QDialog, FORM_CLASS):
    def __init__(self, parent=None):
        """Constructor."""
        super().__init__(parent)
