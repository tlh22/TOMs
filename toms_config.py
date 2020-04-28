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
# case the table is loaded multiple times.

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
