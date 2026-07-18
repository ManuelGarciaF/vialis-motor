\set ON_ERROR_STOP on

-- Las tablas raw son descartables y se recrean en cada importación completa.
-- Se mantienen sin constraints ni índices durante COPY para acelerar la carga.
BEGIN;

DROP TABLE IF EXISTS vialis.gtfs_calendar_dates_raw;
DROP TABLE IF EXISTS vialis.gtfs_stop_times_raw;
DROP TABLE IF EXISTS vialis.gtfs_shapes_raw;
DROP TABLE IF EXISTS vialis.gtfs_stops_raw;
DROP TABLE IF EXISTS vialis.gtfs_trips_raw;
DROP TABLE IF EXISTS vialis.gtfs_routes_raw;
DROP TABLE IF EXISTS vialis.gtfs_agency_raw;

CREATE UNLOGGED TABLE vialis.gtfs_agency_raw (
    agency_id          TEXT,
    agency_name        TEXT,
    agency_url         TEXT,
    agency_timezone    TEXT,
    agency_lang        TEXT,
    agency_phone       TEXT
);

CREATE UNLOGGED TABLE vialis.gtfs_routes_raw (
    route_id           TEXT,
    agency_id          TEXT,
    route_short_name   TEXT,
    route_long_name    TEXT,
    route_desc         TEXT,
    route_type         INTEGER
);

CREATE UNLOGGED TABLE vialis.gtfs_trips_raw (
    route_id           TEXT,
    service_id         TEXT,
    trip_id            TEXT,
    trip_headsign      TEXT,
    trip_short_name    TEXT,
    direction_id       SMALLINT,
    block_id           TEXT,
    shape_id           TEXT,
    exceptional        SMALLINT
);

CREATE UNLOGGED TABLE vialis.gtfs_stops_raw (
    stop_id            TEXT,
    stop_code          TEXT,
    stop_name          TEXT,
    stop_lat           DOUBLE PRECISION,
    stop_lon           DOUBLE PRECISION
);

CREATE UNLOGGED TABLE vialis.gtfs_stop_times_raw (
    trip_id                TEXT,
    arrival_time           TEXT,
    departure_time         TEXT,
    stop_id                TEXT,
    stop_sequence          INTEGER,
    timepoint              SMALLINT,
    shape_dist_traveled    DOUBLE PRECISION
);

CREATE UNLOGGED TABLE vialis.gtfs_shapes_raw (
    shape_id               TEXT,
    shape_pt_lat           DOUBLE PRECISION,
    shape_pt_lon           DOUBLE PRECISION,
    shape_pt_sequence      INTEGER,
    shape_dist_traveled    DOUBLE PRECISION
);

CREATE UNLOGGED TABLE vialis.gtfs_calendar_dates_raw (
    service_id         TEXT,
    date               CHAR(8),
    exception_type     SMALLINT
);

COMMIT;
