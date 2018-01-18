-- Schema: gis

-- DROP SCHEMA gis;

CREATE SCHEMA gis
  AUTHORIZATION postgres;

COMMENT ON SCHEMA gis
  IS 'This schema contains objects and functions pertaining to Geographic Information Systems (GIS) data.';

-- DROP TABLE gis.gis_providers;

CREATE TABLE gis.gis_providers
(
  code CHARACTER VARYING(64) PRIMARY KEY NOT NULL,
  name CHARACTER VARYING(255) UNIQUE NOT NULL
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN gis.gis_providers.code IS
'identifies the GIS data provider';
COMMENT ON COLUMN gis.gis_providers.name IS
'is the name of the GIS data provider';
COMMENT ON TABLE gis.gis_providers IS
  'contains the known GIS data providers';
-- SEED DATA:
INSERT INTO gis.gis_providers (code, name)
VALUES
  ('INTERNAL', 'internal collection'),
  ('TIGER', 'US Census Bureau Topologically Integrated Geographic Encoding and Referencing (TIGER)');
