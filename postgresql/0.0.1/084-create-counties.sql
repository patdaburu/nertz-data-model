-- DROP TABLE postaddr.counties;

CREATE TABLE postaddr.counties
(
  id        UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
  state CHARACTER VARYING(8) NOT NULL
  REFERENCES postaddr.states(code)
  ON DELETE RESTRICT
  ON UPDATE CASCADE ,
  name CHARACTER VARYING(255) UNIQUE NOT NULL,
  CONSTRAINT postaddr_counties__state_and_name__unique UNIQUE(state, name)
) INHERITS(db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.counties.id IS
'uniquely identifies the county';
COMMENT ON COLUMN postaddr.counties.state IS
'is the state code for the state in which the county resides';
COMMENT ON COLUMN postaddr.counties.name IS
'is the name of the the county';
COMMENT ON TABLE postaddr.counties IS
  'contains counties';
-- TODO: Add seed data.


-- DROP TABLE postaddr.cities_counties;

CREATE TABLE postaddr.cities_counties
(
  city uuid NOT NULL UNIQUE -- A City may reside in only one (1) County.
     REFERENCES postaddr.cities(id)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   county uuid NOT NULL
     REFERENCES postaddr.counties(id)
       ON DELETE CASCADE
       ON UPDATE CASCADE
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN postaddr.cities_counties.city IS 'is the identifier of the city';
COMMENT ON COLUMN postaddr.cities_counties.county IS 'is the identifier of the county';
COMMENT ON TABLE postaddr.cities_counties
  IS 'contains the relationships between cities and counties';
