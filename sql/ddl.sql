CREATE TABLE vialis.viajes
(
    id_tarjeta                 BIGINT,
    id_viaje                   SMALLINT,
    cantidad_etapas            SMALLINT,
    rango_horario              SMALLINT,

    etapas_subte               SMALLINT,
    etapas_tren                SMALLINT,
    etapas_colectivo           SMALLINT,

    geom_origen                geometry(Point, 4326),

    geom_destino               geometry(Point, 4326),

    h3_origen                  CHAR(15),
    h3_destino                 CHAR(15),

    departamento_origen_viaje  CHAR(5),
    departamento_destino_viaje CHAR(5),

    factor_expansion_viaje     REAL,

    etapas_incompletas         CHAR(1),
    genero                     CHAR(1),
    grupo_edad                 SMALLINT
);

