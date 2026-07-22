\set ON_ERROR_STOP on

BEGIN;

-- Las claves foráneas deben retirarse mientras se cambia el tipo de las
-- columnas referenciadas y referentes.
ALTER TABLE vialis.matriz_origen_destino
DROP CONSTRAINT IF EXISTS matriz_origen_destino_h3_origen_fkey;

ALTER TABLE vialis.matriz_origen_destino
DROP CONSTRAINT IF EXISTS matriz_origen_destino_h3_destino_fkey;

ALTER TABLE vialis.viajes
ALTER COLUMN h3_origen TYPE h3index
USING NULLIF(BTRIM(h3_origen::TEXT), '')::h3index;

ALTER TABLE vialis.viajes
ALTER COLUMN h3_destino TYPE h3index
USING NULLIF(BTRIM(h3_destino::TEXT), '')::h3index;

ALTER TABLE vialis.hexagonos_viajes
ALTER COLUMN indice_h3 TYPE h3index
USING BTRIM(indice_h3::TEXT)::h3index;

ALTER TABLE vialis.matriz_origen_destino
ALTER COLUMN h3_origen TYPE h3index
USING BTRIM(h3_origen::TEXT)::h3index;

ALTER TABLE vialis.matriz_origen_destino
ALTER COLUMN h3_destino TYPE h3index
USING BTRIM(h3_destino::TEXT)::h3index;

ALTER TABLE vialis.matriz_origen_destino
ADD CONSTRAINT matriz_origen_destino_h3_origen_fkey
FOREIGN KEY (h3_origen)
REFERENCES vialis.hexagonos_viajes(indice_h3);

ALTER TABLE vialis.matriz_origen_destino
ADD CONSTRAINT matriz_origen_destino_h3_destino_fkey
FOREIGN KEY (h3_destino)
REFERENCES vialis.hexagonos_viajes(indice_h3);

COMMIT;

ANALYZE vialis.viajes;
ANALYZE vialis.hexagonos_viajes;
ANALYZE vialis.matriz_origen_destino;
