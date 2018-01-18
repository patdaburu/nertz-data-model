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
  state CHARACTER VARYING(8) NOT NULL
  REFERENCES postaddr.states(code)
  ON DELETE RESTRICT
  ON UPDATE CASCADE ,
  name CHARACTER VARYING(255) UNIQUE NOT NULL,
  CONSTRAINT postaddr_cities__state_and_name__unique UNIQUE(state, name)
) INHERITS(db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.cities.id IS
'uniquely identifies the city';
COMMENT ON COLUMN postaddr.cities.state IS
'is the state code for the state in which the city resides';
COMMENT ON COLUMN postaddr.cities.name IS
'is the name of the the city';
COMMENT ON TABLE postaddr.cities IS
  'contains cities';
-- TODO: Add seed data.