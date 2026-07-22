-- Puebla los hexagonos H3 y calcula el punto mas concurrido de cada uno.
-- Puede volver a ejecutarse para actualizar los puntos ya existentes.
--
-- La concurrencia suma el factor de expansion de cada viaje. Los factores no
-- informados aportan cero. Los origenes y destinos se consideran eventos
-- independientes en un mismo conjunto.
WITH puntos AS (
    SELECT
        h3_origen AS h3,
        geom_origen AS geom,
        COALESCE(factor_expansion_viaje::DOUBLE PRECISION, 0.0) AS peso
    FROM vialis.viajes
    WHERE h3_origen IS NOT NULL
      AND geom_origen IS NOT NULL

    UNION ALL

    SELECT
        h3_destino AS h3,
        geom_destino AS geom,
        COALESCE(factor_expansion_viaje::DOUBLE PRECISION, 0.0) AS peso
    FROM vialis.viajes
    WHERE h3_destino IS NOT NULL
      AND geom_destino IS NOT NULL
),
concurrencia_por_punto AS (
    SELECT
        h3,
        geom,
        COUNT(*) AS cantidad_registros,
        SUM(peso) AS concurrencia_estimada
    FROM puntos
    GROUP BY h3, geom
),
puntos_ordenados AS (
    SELECT
        h3,
        geom,
        cantidad_registros,
        concurrencia_estimada,
        ROW_NUMBER() OVER (
            PARTITION BY h3
            ORDER BY
                concurrencia_estimada DESC,
                cantidad_registros DESC,
                ST_Y(geom),
                ST_X(geom)
        ) AS posicion
    FROM concurrencia_por_punto
)
INSERT INTO vialis.hexagonos_viajes (
    indice_h3,
    punto_maxima_concurrencia,
    concurrencia
)
SELECT
    h3,
    geom,
    concurrencia_estimada
FROM puntos_ordenados
WHERE posicion = 1
ON CONFLICT (indice_h3) DO UPDATE
SET punto_maxima_concurrencia = EXCLUDED.punto_maxima_concurrencia,
    concurrencia = EXCLUDED.concurrencia;
