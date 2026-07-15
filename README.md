# vialis-motor

Servicio REST en Go para el motor de simulación de Vialis.

## Configuración

La aplicación requiere la variable `DATABASE_URL` con la conexión a PostgreSQL:

```text
postgres://<usuario>:<clave>@<host>:<puerto>/<base_de_datos>
```

Opcionalmente, `HTTP_ADDRESS` permite cambiar la dirección de escucha; su valor
predeterminado es `:8080`.

## Ejecutar

```bash
go run ./cmd/api
```

Al iniciar, el proceso crea un pool de conexiones y comprueba que PostgreSQL esté
disponible. Si no puede conectarse, finaliza con error.

## Endpoint

- `GET /health`: responde siempre `200` mientras el servicio esté ejecutándose.

```json
{"status":"ok"}
```
