-- Database: "nertz-core"

-- DROP DATABASE "nertz-core";

CREATE DATABASE "nertz-core"
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'en_US.UTF-8'
       LC_CTYPE = 'en_US.UTF-8'
       CONNECTION LIMIT = -1;

COMMENT ON DATABASE "nertz-core"
  IS 'This is the core Nertz database.';
