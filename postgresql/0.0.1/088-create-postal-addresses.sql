-- DROP TABLE postaddr.postal_address_applications;

CREATE TABLE postaddr.postal_address_applications
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  short_description CHARACTER VARYING(255) UNIQUE NOT NULL,
  long_description TEXT NOT NULL
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN postaddr.postal_address_applications.code IS
'identifies the postal address application';
COMMENT ON COLUMN postaddr.postal_address_applications.short_description IS
'is the short description of the postal address application';
COMMENT ON COLUMN postaddr.postal_address_applications.long_description IS
'is the long description of the postal address application';
COMMENT ON TABLE postaddr.postal_address_applications IS
  'defines the various ways in which a postal address may be used';

-- DROP TABLE postaddr.address_types;

CREATE TABLE postaddr.address_types
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  iso_2022_code CHARACTER VARYING(8) NOT NULL,
  short_description CHARACTER VARYING(255) UNIQUE NOT NULL,
  long_description TEXT NOT NULL
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN postaddr.address_types.code IS
'identifies the address type';
COMMENT ON COLUMN postaddr.address_types.iso_2022_code IS
'indicates the ISO-20022 code associated with the type';
COMMENT ON COLUMN postaddr.address_types.short_description IS
'is the short description of the address type';
COMMENT ON COLUMN postaddr.address_types.long_description IS
'is the long description of the address type';
COMMENT ON TABLE postaddr.address_types IS
  'defines a superset of ISO-20022 address types';
-- SEED DATA:
INSERT INTO postaddr.address_types (code, iso_2022_code, short_description, long_description)
VALUES
  ('HOME', 'HOME', 'residential', 'a residential address'),
  ('BIZZ', 'BIZZ', 'business', 'a business address'),
  ('ADDR', 'HOME', 'postal address', 'a postal address'),
  ('POBOX', 'POBOX', 'post office box', 'a post office box'),
  ('MLTO', 'MLTO', 'mailing', 'a mailing address'),
  ('DLVY', 'DLVY', 'delivery', 'a delivery address');

-- DROP TABLE postaddr.postal_addresses;

CREATE TABLE postaddr.postal_addresses
(
  id        UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
  postal_area UUID NOT NULL
  REFERENCES postaddr.postal_zones(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  address_type CHARACTER VARYING(8)
  REFERENCES postaddr.address_types(code)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  street_address UUID NOT NULL
  REFERENCES postaddrsec.street_addresses
  ON DELETE RESTRICT
  ON UPDATE CASCADE
) INHERITS(db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.postal_addresses.id IS
'uniquely identifies the postal address';
COMMENT ON COLUMN postaddr.postal_addresses.postal_area IS
'is the postal area in which the address resides';
COMMENT ON COLUMN postaddr.postal_addresses.address_type IS
'indicates the general address type';
COMMENT ON COLUMN postaddr.postal_addresses.street_address IS
'contains the token for the street address';
COMMENT ON TABLE postaddr.postal_addresses IS
  'contains postal addresses';

/**
-- DROP TABLE postaddr.people_postal_addresses;

CREATE TABLE postaddr.people_postal_addresses
(
  id                         UUID PRIMARY KEY     NOT NULL DEFAULT uuid_generate_v4(),
  person                     UUID NOT NULL
    REFERENCES people.people (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  postal_address             UUID                 NOT NULL
    REFERENCES postaddr.postal_addresses (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  postal_address_application CHARACTER VARYING(8) NOT NULL
    REFERENCES postaddr.postal_address_applications (code)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.people_postal_addresses.id IS
'uniquely identifies the entry';
COMMENT ON COLUMN postaddr.people_postal_addresses.person IS
'identifies the person';
COMMENT ON COLUMN postaddr.people_postal_addresses.address_type IS
'indicates the general address type';
COMMENT ON COLUMN postaddr.people_postal_addresses.street_address IS
'contains the token for the street address';
COMMENT ON TABLE postaddr.people_postal_addresses IS
  'relates people to postal addresses';
*/



