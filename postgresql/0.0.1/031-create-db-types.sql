
-- DROP TABLE db.months;

CREATE TABLE db.months
(
  ordinal INTEGER PRIMARY KEY NOT NULL,
  name CHARACTER VARYING(16) UNIQUE NOT NULL,
  abbreviation CHARACTER VARYING(3)
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN db.months.ordinal IS
'is the month ordinal';
COMMENT ON COLUMN db.months.name IS
'is the full English name of the month';
COMMENT ON COLUMN db.months.abbreviation IS
'is the standard abbreviation of the English name of the month';
COMMENT ON TABLE db.months IS
  'is a canonical list of calendar months identified in their prper order, starting with January in the first position';
-- TODO: Add seed data.
INSERT INTO db.months (ordinal, name, abbreviation)
VALUES
  (1, 'January', 'Jan'),
  (2, 'February', 'Feb'),
  (3, 'March', 'Mar'),
  (4, 'April', 'Apr'),
  (5, 'May', 'May'),
  (6, 'June', 'Jun'),
  (7, 'July', 'Jul'),
  (8, 'August', 'Aug'),
  (9, 'September', 'Sep'),
  (10, 'October', 'Oct'),
  (11, 'November', 'Nov'),
  (12, 'December', 'Dec');
;