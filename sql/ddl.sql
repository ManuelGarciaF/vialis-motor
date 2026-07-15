CREATE TABLE vialis.viajes
(
    id_tarjeta                 BIGINT,
    id_viaje                   SMALLINT,
    cantidad_etapas            SMALLINT,
    rango_horario              SMALLINT,

    etapas_subte               SMALLINT,
    etapas_tren                SMALLINT,
    etapas_colectivo           SMALLINT,

    geom_origen                GEOMETRY(Point, 4326),

    geom_destino               GEOMETRY(Point, 4326),

    h3_origen                  CHAR(15),
    h3_destino                 CHAR(15),

    departamento_origen_viaje  CHAR(5),
    departamento_destino_viaje CHAR(5),

    factor_expansion_viaje     REAL,

    etapas_incompletas         CHAR(1),
    genero                     CHAR(1),
    grupo_edad                 SMALLINT
);

-- Hexagono H3 --
CREATE TABLE vialis.hexagonos_viajes (
    indice_h3 CHAR(15) PRIMARY KEY,
    punto_maxima_concurrencia GEOMETRY(Point, 4326),
    concurrencia DOUBLE PRECISION NOT NULL
);

-- Matriz origen-destino --
CREATE TABLE vialis.matriz_origen_destino (
    h3_origen CHAR(15) NOT NULL
        REFERENCES vialis.hexagonos_viajes(indice_h3),
    h3_destino CHAR(15) NOT NULL
        REFERENCES vialis.hexagonos_viajes(indice_h3),
    cantidad_viajes DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (h3_origen, h3_destino)
);
