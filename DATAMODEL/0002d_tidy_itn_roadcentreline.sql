ALTER TABLE highways_network.itn_roadcentreline
    ALTER COLUMN toid SET NOT NULL;
ALTER TABLE highways_network.itn_roadcentreline
    ADD UNIQUE (toid);