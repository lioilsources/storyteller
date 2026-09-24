# infra

Local dev: `docker-compose.yml` (Postgres 16 + Redis 7). Production runs
on JODA (gateway + Postgres + Redis, behind Caddy + Cloudflare Tunnel)
with Spark handling vLLM/STT/TTS/ComfyUI — see `STORYTELLER_PLAN.md` §2.

```sh
docker compose -f infra/docker-compose.yml up -d
```

## Migrations

`migrations/0001_init.up.sql` / `.down.sql` — hand-written, laid out for
[golang-migrate](https://github.com/golang-migrate/migrate) naming
(`<version>_<name>.up.sql`). Not wired into a Makefile/CI yet; run by
hand for now:

```sh
psql "$DATABASE_URL" -f infra/migrations/0001_init.up.sql
```

`Caddyfile` is a stub — production routing (JODA, Cloudflare Tunnel)
still needs to be written.
