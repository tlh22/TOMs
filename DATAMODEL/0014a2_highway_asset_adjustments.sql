-- adhoc local authority assets

ALTER TABLE highway_assets."CommunicationCabinets"
    ALTER COLUMN "CommunicationCabinetTypeID" DROP NOT NULL;

ALTER TABLE highway_assets."VehicleBarriers"
    ALTER COLUMN "VehicleBarrierTypeID" DROP NOT NULL;

ALTER TABLE highway_assets."UnidentifiedStaticObjects"
    ADD PRIMARY KEY ("RestrictionID");


