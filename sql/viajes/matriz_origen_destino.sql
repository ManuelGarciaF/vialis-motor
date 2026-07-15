-- 1. Insertar datos en la tabla de matriz de viajes --
INSERT INTO vialis.matriz_origen_destino (
    h3_origen,
    h3_destino,
    cantidad_viajes
)
SELECT
    h3_origen,
    h3_destino,
    SUM(factor_expansion_viaje) AS cantidad_viajes
FROM vialis.viajes
WHERE h3_origen IS NOT NULL
  AND h3_destino IS NOT NULL
GROUP BY
    h3_origen,
    h3_destino;

-- TODO: ver si es necesario crear índices --