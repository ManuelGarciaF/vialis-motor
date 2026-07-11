-- 1. Create table viajes_raw --
CREATE TABLE vialis.viajes_raw (

    id_tarjeta BIGINT,
    id_viaje SMALLINT,
    cantidad_etapas SMALLINT,
    rango_horario SMALLINT,

    etapas_subte SMALLINT,
    etapas_tren SMALLINT,
    etapas_colectivo SMALLINT,

    longitud_origen_viaje DOUBLE PRECISION,
    latitud_origen_viaje DOUBLE PRECISION,

    longitud_destino_viaje DOUBLE PRECISION,
    latitud_destino_viaje DOUBLE PRECISION,

    departamento_origen_viaje CHAR(5),
    departamento_destino_viaje CHAR(5),

    factor_expansion_viaje REAL,

    etapas_incompletas CHAR(1),
    genero CHAR(1),
    grupo_edad SMALLINT
);

-- 2. Importar el CSV de viajes en la tabla viajes_raw --

-- 3. Actualizar estadísticas de la tabla viajes_raw --
VACUUM ANALYZE vialis.viajes_raw;

-- 4. Insertar datos en la tabla viajes desde viajes_raw (para guardar puntos en vez de longitud y latitud) --
INSERT INTO vialis.viajes (

    id_tarjeta,
    id_viaje,
    cantidad_etapas,
    rango_horario,

    etapas_subte,
    etapas_tren,
    etapas_colectivo,

    geom_origen,
    geom_destino,

    departamento_origen_viaje,
    departamento_destino_viaje,

    factor_expansion_viaje,

    etapas_incompletas,
    genero,
    grupo_edad

)

SELECT

    id_tarjeta,
    id_viaje,
    cantidad_etapas,
    rango_horario,

    etapas_subte,
    etapas_tren,
    etapas_colectivo,

    ST_SetSRID(
        ST_MakePoint(
            longitud_origen_viaje,
            latitud_origen_viaje
        ),
        4326
    ),

    ST_SetSRID(
        ST_MakePoint(
            longitud_destino_viaje,
            latitud_destino_viaje
        ),
        4326
    ),

    departamento_origen_viaje,
    departamento_destino_viaje,

    factor_expansion_viaje,

    etapas_incompletas,
    genero,
    grupo_edad

FROM vialis.viajes_raw;

-- 6. Crear índice espacial en la tabla viajes para geom_origen y geom_destino --
CREATE INDEX idx_viajes_geom_origen
ON vialis.viajes
USING GIST (geom_origen);

CREATE INDEX idx_viajes_geom_destino
ON vialis.viajes
USING GIST (geom_destino);

-- 7. Actualizar estadísticas de la tabla viajes --
VACUUM ANALYZE vialis.viajes;

-- 8. Agregar numeros de celda h3 a cada viaje
UPDATE vialis.viajes
SET h3_origen = h3_lat_lng_to_cell(geom_origen, 8),
    h3_origen = h3_lat_lng_to_cell(geom_destino, 8);