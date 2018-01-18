-- DROP TABLE postaddr.cities;

CREATE TABLE postaddr.cities
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