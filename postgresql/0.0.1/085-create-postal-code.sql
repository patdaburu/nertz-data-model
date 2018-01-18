-- DROP TABLE postaddr.postal_zones;

CREATE TABLE postaddr.postal_zones
(
  id          UUID PRIMARY KEY             NOT NULL DEFAULT uuid_generate_v4(),
  city        UUID                         NOT NULL
    REFERENCES postaddr.cities (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  postal_code CHARACTER VARYING(5),
  label       CHARACTER VARYING(48) UNIQUE NOT NULL
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.postal_zones.id IS
'uniquely identifies the postal area';
COMMENT ON COLUMN postaddr.postal_zones.city IS
'identifies the city in which the postal zone resides';
COMMENT ON COLUMN postaddr.postal_zones.label IS
'is a unique friendly label for the postal zone';
COMMENT ON COLUMN postaddr.postal_zones.postal_code IS
'is the postal code assigned to the postal zone';
COMMENT ON TABLE postaddr.postal_zones IS
'contains cities';
-- TODO: Add seed data.


-- DROP TABLE postaddr.postal_zones_suffixes;

CREATE TABLE postaddr.postal_zones_suffixes
(
  postal_code UUID PRIMARY KEY   UNIQUE          NOT NULL
    REFERENCES postaddr.postal_zones (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  suffix      CHARACTER VARYING(4)               NOT NULL
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.postal_zones_suffixes.postal_code IS
'uniquely identifies the postal area to which the suffix is applied';
COMMENT ON COLUMN postaddr.postal_zones_suffixes.suffix IS
'is the postal code suffix';
COMMENT ON TABLE postaddr.postal_zones_suffixes IS
'contains suffixes for postal zones';
-- TODO: Add seed data.