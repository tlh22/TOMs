# This lists all layers TOMS expected to be present
# in the QGIS file

ALL_LAYERS = [
    "Proposals",
    "ProposalStatusTypes",
    "ActionOnProposalAcceptanceTypes",
    "RestrictionLayers",
    "RestrictionsInProposals",
    "Bays",
    "Lines",
    "Signs",
    "RestrictionPolygons",
    "ConstructionLines",
    "MapGrid",
    "CPZs",
    "ParkingTariffAreas",
    "StreetGazetteerRecords",
    "RoadCentreLine",
    "RoadCasement",
    "TilesInAcceptedProposals",
    "RestrictionTypes",
    "BayLineTypes",
    "SignTypes",
    "RestrictionPolygonTypes",
    "Lines.label_pos",
    "Lines.label_loading_pos",
    "Bays.label_pos",
    "RestrictionPolygons.label_pos",
    "ParkingTariffAreas.label_pos",
    "ControlledParkingZones.label_pos",
]

# This lists all restriction layers.
# This list is used mainly to update the filters.
# The ID must match the RestrictionLayers table ID.
# Multiple layers can reference the same restriction in
# case the table is loaded multiple times. In that
# case, always define the main layer before it's labels


RESTRICTION_LAYERS = [
    (2, 'Bays'),
    (2, 'Bays.label_pos'),
    (3, 'Lines'),
    (3, 'Lines.label_pos'),
    (3, 'Lines.label_loading_pos'),
    (5, 'Signs'),
    (4, 'RestrictionPolygons'),
    (4, 'RestrictionPolygons.label_pos'),
    (6, 'CPZs'),
    (6, 'ControlledParkingZones.label_pos'),
    (7, 'ParkingTariffAreas'),
    (7, 'ParkingTariffAreas.label_pos'),
]

LABELS_FOR_RESTRICTIONS = {
    'Bays': [
        'Bays.label_pos',
    ],
    'Lines': [
        'Lines.label_pos',
        'Lines.label_loading_pos',
    ],
    'Signs': [],
    'RestrictionPolygons': [
        'RestrictionPolygons.label_pos',
    ],
    'CPZs': [],
    'ControlledParkingZones.label_pos': [
        'ParkingTariffAreas',
        'ParkingTariffAreas.label_pos',
    ],
}

# This list all layers that are in the same transaction
# (implemented in TOMsTransaction)

TRANSACTION_LIST = [
    "Bays",
    "Lines",
    "Signs",
    "RestrictionPolygons",
    "CPZs",
    "ControlledParkingZones",
    "Proposals",
    "RestrictionsInProposals",
    "MapGrid",
    "TilesInAcceptedProposals",
]
