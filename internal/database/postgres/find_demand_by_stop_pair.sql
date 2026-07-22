WITH assigned_cells AS (
    SELECT
        assigned.stop_order,
        assigned.stop_id,
        assigned.cell_id::h3index AS cell_id,
        assigned.accessibility
    FROM unnest(
        $1::INTEGER[],
        $2::TEXT[],
        $3::TEXT[],
        $4::DOUBLE PRECISION[]
    ) AS assigned(stop_order, stop_id, cell_id, accessibility)
)
SELECT
    origin.stop_order AS origin_stop_order,
    origin.stop_id AS origin_stop_id,
    destination.stop_order AS destination_stop_order,
    destination.stop_id AS destination_stop_id,
    SUM(matrix.cantidad_viajes)::DOUBLE PRECISION AS gross_demand,
    SUM(
        matrix.cantidad_viajes
        * origin.accessibility
        * destination.accessibility
    )::DOUBLE PRECISION AS potential_demand
FROM assigned_cells origin
JOIN assigned_cells destination
    ON origin.stop_order < destination.stop_order
JOIN vialis.matriz_origen_destino matrix
    ON matrix.h3_origen = origin.cell_id
    AND matrix.h3_destino = destination.cell_id
GROUP BY
    origin.stop_order,
    origin.stop_id,
    destination.stop_order,
    destination.stop_id
ORDER BY
    origin.stop_order,
    destination.stop_order,
    origin.stop_id,
    destination.stop_id;
