-- DROP TABLE postaddrsec.street_addresses;

CREATE TABLE postaddrsec.street_addresses
(
  token          UUID PRIMARY KEY       NOT NULL DEFAULT uuid_generate_v4(),
  street_address CHARACTER VARYING(255) NOT NULL
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddrsec.street_addresses.token IS
'uniquely identifies the street address';
COMMENT ON COLUMN postaddrsec.street_addresses.street_address IS
'is the street address';
COMMENT ON TABLE postaddrsec.street_addresses IS
'contains street addresses';

-- DROP TABLE postaddrsec.street_addresses_locations;

CREATE TABLE postaddrsec.street_addresses_locations
(
  street_address        UUID PRIMARY KEY NOT NULL
  REFERENCES  postaddrsec.street_addresses(token)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  location geography NOT NULL,
  location_provider CHARACTER VARYING(64)
  REFERENCES gis.gis_providers(code)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddrsec.street_addresses_locations.street_address IS
'identifies the street address';
COMMENT ON COLUMN postaddrsec.street_addresses_locations.location IS
'is the physical location';
COMMENT ON COLUMN postaddrsec.street_addresses_locations.location_provider IS
'identifies the provider of the location information';
COMMENT ON TABLE postaddrsec.street_addresses_locations IS
  'relates physical locations to the addresses that have them.';


-- DROP TABLE postaddrsec.street_addresses_internal_addresses;

CREATE TABLE postaddrsec.street_addresses_internal_addresses
(
  street_address        UUID PRIMARY KEY NOT NULL
  REFERENCES  postaddrsec.street_addresses(token)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  internal_address CHARACTER VARYING(255) NOT NULL
) INHERITS(db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddrsec.street_addresses_internal_addresses.street_address IS
'identifies the street address';
COMMENT ON COLUMN postaddrsec.street_addresses_internal_addresses.internal_address IS
'is the internal address';
COMMENT ON TABLE postaddrsec.street_addresses_internal_addresses IS
  'contains cities';
