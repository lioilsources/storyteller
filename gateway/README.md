# gateway

Go HTTP API described in `STORYTELLER_PLAN.md` §2 — `story-gateway`.

## Status

Only `GET /v1/daily` and `GET /healthz` exist. stdlib `net/http` router
(Go 1.22+ method+pattern `ServeMux`) — no framework yet; reach for `chi`
only once middleware chains get more complex than one logging wrapper.

`GET /v1/daily?family=&date=` is deterministic (seeded from
`fnv(family|date)`) but currently reads from a hand-written in-memory
seed corpus (`internal/offer/seed.go`), **not** `corpus_motifs` — swap
in a Postgres-backed `offer.Source` once `corpus/cmd/extract -load` has
actually populated the table.

```sh
go run ./gateway/cmd/server
curl 'localhost:8080/v1/daily?family=demo&date=2026-09-24'
curl 'localhost:8080/healthz'
```

## Not started

Session state, live-hint engine (WS audio → STT → LLM), media-
orchestrator, library/export/auth — see plan §2.3–2.4.
