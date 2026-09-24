# rag — offline LLM + RAG pipeline (Python)

Implements `STORYTELLER_RAG_PLAN.md`: everything an LLM ever says is
generated here, on Spark, in batch, and shipped to the app as SQLite
packs. The app never calls a model — it embeds the transcript on-device
and does retrieval (RAG_PLAN §0.1, §3).

**Language split (decided 2026-09-24):** this directory is the one place
Python is allowed in the repo — LLM calls, embeddings, ONNX, sqlite-vec.
Gateway and corpus *fetching* stay Go. The former Go `corpus/cmd/extract`
was removed in favour of `rag.extract`.

## Stages

| module | RAG_PLAN | in → out | LLM |
|---|---|---|---|
| `rag.extract` | PLAN §3.2 (+ §1.1c environments/creatures) | `corpus/data/raw` (Go fetcher) → `data/tales.jsonl` | yes |
| `rag.verbalize` | §2.1 | tales → `data/verbalizations.<lang>.jsonl` (12 variants/motif) | yes |
| `rag.hints` | §2.2 | tales → `data/hints.<lang>.jsonl` (8/(motif,phase) + generic per (phase,env)) | yes |
| `rag.transitions` | §2.3 | → `data/transitions.<lang>.jsonl` (~100/lang) | yes |
| `rag.scene_prompts` | §2.4 | tales → `data/scene_prompts.jsonl` (English, style-neutral) | yes |
| `rag.embed` | §2.6 | e5-small wrapper + **int8 contract** | no |
| `rag.build_pack` | §6 | JSONL → `data/packs/core.<lang>.db`, `country.<CC>.<lang>.db` (sqlite-vec) | no |
| `rag.parity_check` | §8.1 | fp32 sentence-transformers vs ONNX int8, cos > 0.99 | no |

Not written yet: `compat` LLM scoring (heuristic jaccard+ATU is in
`build_pack`), `phase_labels` + `phase_model` training, the LLM spoiler
classifier (rule-based `reveals_ending` is in `filters`), `country_art`
/ `country_audio` prompt generation.

Every LLM stage is **resumable**: it skips keys already present in its
output JSONL, so a killed run continues. Every id is deterministic
(`rag.io.stable_id`) — re-extracting the same tale yields the same
motif ids.

## Setup

```sh
cd rag
python3 -m venv .venv && .venv/bin/pip install -e '.[dev]'
.venv/bin/python -m pytest            # 21 tests, no network, no models
# on Spark, additionally:
.venv/bin/pip install -e '.[embed,pg]'
```

Config: `LITELLM_BASE_URL` (OpenAI-compatible base, e.g.
`http://<spark>:4000/v1`), `LITELLM_MODEL`, optional `LITELLM_API_KEY`.

## Status (2026-09-24)

**`rag.extract` and `rag.verbalize` have now run for real**, against
Spark's `translate` model (Qwen3-32B-AWQ via TensorRT-LLM,
`AiStack/deploy/docker-compose.translate.yaml`) reached at
`http://192.168.88.66:8080/v1` — `ai-gateway`, published `0.0.0.0:8080`
on the LAN, proxies to litellm with **no auth needed** (unlike
`llm.ol1n.com`, which is Cloudflare Access-gated). 5 Grimm tales
extracted, 3 motifs verbalized into Czech.

Two real bugs found and fixed in `rag.extract` from that first run —
see `KNOWN_COUNTRY`/`clean_atu` and their tests:
- `country_code` wrong for 2/5 tales (Die Bremer Stadtmusikanten, Der
  alte Sultan — both unambiguously Grimm/German — came back `FR`).
  Fixed by overriding with ground truth for single-country collections
  (grimm/andersen/perrault/aesop) instead of trusting a per-tale LLM
  guess; Lang's Fairy Books is genuinely multi-country and still left
  to the model.
- `atu_code` came back as `"554 The Golden Bird"` — the model tacked
  the tale's own title onto the number. `clean_atu()` keeps only the
  leading ATU-shaped token.

One **unfixed** quality issue, flagged not patched (it's model
output quality, not a code bug): `rag.verbalize` translated "a clever
fox" as "**Lis**" in one Czech title — not a real Czech word for fox
(should be liška/lišák). The other 11/12 variants in that same run read
as natural, correct Czech. Whether `translate` is good enough for
production verbalization, or needs a stronger model / few-shot
examples for animal vocabulary, is an open call — not made here.

**What has not run yet:** `rag.hints`, `rag.transitions`,
`rag.scene_prompts` (same endpoint, just not exercised); the embedder
(`sentence-transformers` not installed here, and the HF cache on this
Mac has `multilingual-e5-large`, not `-small` — large is 1024-d and too
big for phones, so the small model must still be pulled); `parity_check`
(needs an ONNX export — see RAG_PLAN §8.1, this is the gate before
building real packs).

Always smoke-test a stage with `--limit 5` against a fresh endpoint
first; small local models don't always honour `response_format`, and
the fallback path is only as good as their JSON — and even when the
JSON is well-formed, spot-check the *content* (see the two bugs above).

## Contracts the app side depends on

- **Pack schema** — `build_pack.SCHEMA` + the two `vec0` tables. The Dart
  `RagStore` ATTACHes `core.<lang>.db` and `country.<CC>.<lang>.db` and
  queries one shape. Bump `PACK_VERSION` on any schema change.
- **int8 quantization** — `embed.quantize_int8`: L2-normalised vector,
  `round(x*127)`, clamp to ±127, signed bytes. The Dart embedder must
  produce identical bytes for identical floats; sqlite-vec compares with
  `vec_int8(?)` and `distance_metric=cosine` (distance = 1 − cos).
- **e5 prefixes** — stored texts are embedded as `passage: …`, the
  transcript window as `query: …`. Swapping them degrades retrieval.
- **Retrieval query** — `build_pack.nearest_hints` is the reference SQL
  for RAG_PLAN §3 (phase filter + outline motifs + generic fallback,
  cosine order).
- **`meta.embed_model` / `embed_dim`** — a pack whose `embed_model` is
  empty or whose model differs from the device model must be refused.
