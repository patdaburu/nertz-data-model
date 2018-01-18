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
    ON UPDATE CASCADE,
  -- A person may not have the same address for the same purpose registered multiple times.
  CONSTRAINT people_postal_addresses_person_postal_address_postal_address_application
    UNIQUE(person, postal_address, postal_address_application)
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.people_postal_addresses.id IS
'uniquely identifies the entry';
COMMENT ON COLUMN postaddr.people_postal_addresses.person IS
'identifies the person';
COMMENT ON COLUMN postaddr.people_postal_addresses.postal_address IS
'identifies the postal address';
COMMENT ON COLUMN postaddr.people_postal_addresses.postal_address_application IS
'indicates the postal address application';
COMMENT ON TABLE postaddr.people_postal_addresses IS
  'relates people to postal addresses';

-- DROP TABLE postaddr.people_postal_addresses_preferences;

CREATE TABLE postaddr.people_postal_addresses_preferences
(
   person_postal_address UUID UNIQUE NOT NULL
     REFERENCES postaddr.people_postal_addresses(id)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   preferred_as_of TIMESTAMP WITH TIME ZONE DEFAULT now()
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN postaddr.people_postal_addresses_preferences.person_postal_address IS
'is the identifier of the person address relationship';
COMMENT ON COLUMN postaddr.people_postal_addresses_preferences.preferred_as_of IS
  'is the timestamp marking when the entry was preferred';
COMMENT ON TABLE postaddr.people_postal_addresses_preferences
  IS 'establishes the preferences of postal addresses for people';


-- DROP TABLE postaddr.people_postal_addresses_seasons;

CREATE TABLE postaddr.people_postal_addresses_seasons
(
  person_postal_address UUID UNIQUE NOT NULL
    REFERENCES postaddr.people_postal_addresses (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  from_month            INTEGER     NOT NULL CHECK (from_month BETWEEN 1 AND 12)
    REFERENCES db.months (ordinal)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  from_day              INTEGER     NOT NULL CHECK (from_day BETWEEN 1 and 31),
  to_month              INTEGER     NOT NULL CHECK (from_month BETWEEN 1 AND 12)
    REFERENCES db.months (ordinal)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  to_day                INTEGER     NOT NULL CHECK (from_day BETWEEN 1 and 31)
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.people_postal_addresses_seasons.person_postal_address IS
'is the identifier of the person address relationship';
COMMENT ON COLUMN postaddr.people_postal_addresses_seasons.from_month IS
'is the ordinal of the month at the beginning of the season (a whole number between 1 and 12)';
COMMENT ON COLUMN postaddr.people_postal_addresses_seasons.from_day IS
'is the day of the month at the beginning of the season (a whole number between 1 and 31)';
COMMENT ON COLUMN postaddr.people_postal_addresses_seasons.to_month IS
'is the ordinal of the month at the end of the season (a whole number between 1 and 12)';
COMMENT ON COLUMN postaddr.people_postal_addresses_seasons.to_day IS
'is the day of the month at the end of the season (a whole number between 1 and 31)';
COMMENT ON TABLE postaddr.people_postal_addresses_seasons
IS 'specifies a period of the year in which an address may be used';








