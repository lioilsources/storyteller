# STORYTELLER_RAG_PLAN.md — RAG pipeline, která připraví offline setup bez LLM callu za běhu

> Doplněk k STORYTELLER_PLAN / OFFLINE_PLAN / MODELS_PLAN. Cíl: **LLM běží jen offline v pipeline** (na Sparku, v noci). Za běhu appka dělá pouze **retrieval + skládání** nad předpřipravenými daty: embedding malým on-device modelem, vektorové hledání v SQLite, šablony. Žádný dotaz na vLLM není potřeba pro denní nabídku, glóbus, osnovu, nápovědy, fázi příběhu ani prompty pro obrázky.

## 0. Principy

1. **Generuj offline, hledej online.** Vše, co má LLM říct, je vygenerované dopředu ve všech jazycích a uložené jako krátké, adresovatelné texty. Za běhu se jen vybírá.
2. **Pre-verbalizace místo generace.** Motiv není jedna věta, ale **balíček variant** (věk, tón, délka, jazyk). Nápověda není generovaná z transkriptu, ale **vyhledaná** podle transkriptu.
3. **Skládání = gramatika, ne LLM.** Osnova, přechody mezi motivy a prompty pro obrázky vznikají ze šablon a předem spočítaných kompatibilit.
4. **Bezpečnost je zapečená při generování.** Filtry (věk, žádný spoiler konce, žádné násilí) běží v pipeline; runtime nemůže vyrobit nic, co neprošlo.
5. **Kvalita se zlepšuje smyčkou.** Nízká podobnost při retrievalu nebo odmítnutá nápověda = miss → noční pipeline dogeneruje varianty pro to místo (viz OFFLINE_PLAN §2.4).
6. **Tři runtime úrovně:** T0 čistý retrieval (default, vše offline) → T1 volitelný on-device malý LLM jen na přeformulování → T2 online vLLM (premium / live nápovědy s personalizací).

## 1. Co runtime potřebuje a jak se to řeší bez LLM

| Potřeba | Bez LLM (T0) | Zdroj dat z pipeline |
|---|---|---|
| Denní nabídka 3×4 | deterministický výběr z motivů (seed=date+family) + ranker (OFFLINE §4) | `motifs`, `verbalizations` |
| Glóbus → 3 motivy ze země | filtr country/region + fáze + věk + diverzita tagů | `motifs` |
| Osnova ze 4 vybraných motivů | šablona osnovy + `transitions` (přechodové věty) + `compat` (skóre dvojic) | `outline_templates`, `transitions`, `compat` |
| Vizitka země, jména tvorů, prostředí | statické texty | `countries`, `creatures`, `environments` (`*_i18n`) |
| Nápověda při vyprávění | embedding posledních ~60 s transkriptu → ANN v `hint_bank` filtrovaném na (motivy osnovy, fáze, jazyk) → top-k, rotace | `hint_bank`, `embeddings` |
| Fáze příběhu | on-device klasifikátor nad embeddingem transkriptu (trénovaný offline na LLM labelech) | `phase_model` |
| Prompt pro obrázek scény | šablona per (styl) + sloty z motivů/prostředí/postav; volný text z transkriptu → nearest `scene_prompts` | `scene_prompts`, `styles` |
| "Co dítě právě řeklo" (chce draka) | embedding → nearest motiv/tvor → nabídnout | `embeddings` |
| Překlady dynamických textů | neexistují dynamické texty — vše je předpřeložené | `*_i18n` |

## 2. Offline pipeline (Spark, `/rag`)

```
corpus (PD pohádky) 
  → chunk (per pohádka, per scéna)
  → extract  (motivy, prostředí, tvorové, ATU, země)            [LLM]   (už v PLAN §3.2)
  → verbalize (varianty textů per motiv × jazyk × věk × tón)    [LLM]
  → hint_bank (nápovědy per (motiv, fáze, prostředí) × jazyk)   [LLM]
  → transitions (přechodové věty per (typ_A → typ_B, tag))      [LLM]
  → compat (skóre dvojic motivů + důvod)                        [LLM, jen top páry; zbytek heuristika]
  → scene_prompts (prompty per (motiv, prostředí, fáze), styl-neutrální) [LLM]
  → phase_labels (transkripty syntetické + reálné anonymizované → label fáze) [LLM]
  → filter (věk, spoiler, násilí, kulturní citlivost)           [LLM klasifikátor + pravidla]
  → embed (multilingual embedding model, stejný jako na zařízení) 
  → train phase_model (logistická regrese / malý MLP nad embeddingy)
  → build index (sqlite-vec / usearch, int8) + packs + manifest
```

### 2.0 Originál napřed (zásada 2026-10-04)
**Pokud existuje originál, nic nepřekládej a ber text z originálu.** Texty v jazyce X (`verbalize`, `hint_bank`, karty `rag.cards`) se pro pohádku, jejíž text máme v jazyce X, generují z úryvku toho textu (jména, oslovení, obraty), ne z anglického `text_en`. Ostatní pohádky z `text_en` — jeden krok od zdroje, nikdy řetězově přes třetí jazyk. „Originál“ = text, který v korpusu leží: cs.wikisource → `cs` (150 pohádek, 1 956 motivů), Gutenberg → `en` (2 433 pohádek, 28 138 motivů; Grimm je tedy originál pro EN, ne pro DE). Index `rag/data/tale_sources.jsonl` (`python -m rag.sources`), řádky nesou `source: original | text_en`, `build_pack` preferuje `original`, staré CZ řádky se přegenerují `--regen-from-original` bez mazání. Detail: `rag/README.md` → „Originál napřed“. `transitions` a generické nápovědy k žádné pohádce nepatří, originál nemají.

### 2.1 `verbalize`
Per motiv (character/task/problem/ending): pro každý jazyk Tier 1+2 vygenerovat
- 3 formulace × 3 věková pásma (0–3 / 3–6 / 6–10) × 2 délky (název 2–5 slov, popis 1 věta)
- + 2 "hlasy" (neutrální, hravý)
Uložit jako `verbalizations(motif_id, lang, age_band, tone, length, text, hash)`. Odhad: 20k motivů × 16 jazyků × 18 variant ≈ 5,8 M krátkých řetězců, ~600 MB text globálně; per jazyk ~35 MB, per (země, jazyk) jednotky MB → packy.

### 2.2 `hint_bank`
Per (motif_id, phase ∈ {intro, task, problem, climax, ending}, environment_id | null, lang):
- 6–10 **otevřených** vět ("…a v tu chvíli se z houští ozvalo…", "…co myslíš, že liška udělala?") — nikdy nedokončují děj, nikdy neprozrazují konec, max 1 věta, max 15 slov.
- Každá nápověda má `trigger_embedding`: embedding **popisu situace, ve které se hodí** (ne nápovědy samotné) — retrieval pak porovnává transkript s popisem situace, což funguje mnohem líp než porovnání s textem nápovědy.
- Navíc **generické nápovědy** per (fáze, prostředí) bez motivu, jako záloha.
- Filtr spoilerů: klasifikátor dostane nápovědu + zvolený konec → "prozrazuje?" → zahodit.

### 2.3 `transitions` a `compat`
- `transitions(from_type, to_type, tag_set, lang, text)`: "Ale dřív, než se vydal na cestu, …", "Jenže v tu chvíli…" — ~200 per jazyk, tagované (les/moře/král…), vybírají se podle tagů sousedních motivů.
- `compat(motif_a, motif_b, score, note)`: LLM oskóruje dvojice pro top-2000 nejpoužívanějších motivů (4 M párů je moc → jen páry sdílející tag nebo ATU sousedství, ~200k); zbytek `score = jaccard(tags) + atu_distance`. Ranker z OFFLINE §4 přičítá `compat` při nabídce dalšího slotu, aby "indický úkol" seděl k "ukrajinské lišce".
- `outline_templates(lang, age_band, text)`: 5–8 šablon typu "{character_intro}. {transition} {task}. {transition} {problem}. {transition} {ending}." — sloty se plní verbalizacemi.

### 2.4 `scene_prompts`
Per (motif, environment, phase): styl-neutrální popis scény v en (image prompty jsou en), + sloty `{character_refs}`, `{style_prefix}`, `{style_suffix}`. Runtime jen doplní. Volný text rodiče ("liška spadla do studny") → embedding → nearest `scene_prompts` (cos ≥ 0,75) → použít, jinak generický prompt fáze + prostředí.

### 2.5 `phase_model`
- Trénovací data: LLM vygeneruje 20k syntetických útržků transkriptu (60 s okno) per jazyk s labelem fáze + volitelně reálné anonymizované transkripty (opt-in) labelované LLM.
- Model: logistická regrese / 2-vrstvý MLP nad embeddingem (384-d) → 5 tříd, < 1 MB, inference < 1 ms. Exportovat jako ONNX nebo prostě váhy v JSON (Dart matmul stačí).
- Vstup navíc: pozice v čase (%) a které motivy už byly zmíněny (keyword match na verbalizace) → prior.

### 2.6 Embeddings a index
- Model: **multilingual-e5-small** (384-d, ~118 MB fp32 → ~30 MB int8) nebo **bge-m3** dist. varianta; **stejný model na Sparku i na zařízení** (jinak nesedí prostory). Na zařízení přes `onnxruntime` / `sherpa-onnx` / `flutter_onnxruntime`, ~20–40 ms per query na telefonu.
- Index: `sqlite-vec` (vec0 virtual table, int8) v tomtéž SQLite jako zbytek packů → jeden soubor per pack, ANN + SQL filtry (lang, phase, motif ∈ osnova) v jednom dotazu. Alternativa `usearch` HNSW pro > 500k vektorů.
- Velikost: hint_bank ~20k motivů × 5 fází × 8 = 800k vektorů globálně na jazyk — **per country pack** jen motivy té země (~150–500) → ~20k vektorů, < 10 MB int8. Generické nápovědy per jazyk ~5k vektorů v `core`.

## 3. Runtime (klient, T0)

```
onTranscript(window60s):
  e = embed(window60s)                                  // 30 ms
  phase = phase_model(e, t_ratio, mentioned_motifs)     // 1 ms
  hints = SELECT text FROM hint_bank
          WHERE lang=? AND phase=? AND (motif_id IN (osnova) OR motif_id IS NULL)
          ORDER BY vec_distance(trigger_embedding, e) LIMIT 8   // 5–20 ms
  hint  = pick(hints, exclude=recently_shown, prefer=motif-specific)
  precompute: udržovat vždy 1 připravenou nápovědu → latence při tichu ≈ 0
```
- Osnova: `compose(outline_template, verbalizations[selected], transitions by tags)`.
- Prompt scény: `scene_prompts` + `styles` → MODELS_PLAN resolver.
- Vše nad **jedním SQLite souborem per pack** (`core.{lang}.db` + `country.{code}.{lang}.db`), ATTACH při startu.
- STT on-device (Apple Speech / Android / whisper tiny) — viz OFFLINE §5.

## 4. Smyčka kvality (napojení na OFFLINE §2.4)

Runtime loguje (lokálně, sync při Wi-Fi, opt-in):
- `hint_events(key_base_osnova, phase, hint_id, similarity, shown, accepted|dismissed|ignored)`
- `retrieval_misses(kind, query_embedding_hash, best_similarity)` když `best_similarity < práh` (nápověda 0,65; scene_prompt 0,75)
Noční pipeline:
- nízká podobnost → LLM vygeneruje nové nápovědy/scene_prompts pro sousedství (situace popsané nejbližšími existujícími položkami + anonymizovaný shrnutý kontext, ne surový transkript) → embed → pack update
- nízká acceptance u nápovědy → snížit váhu / nahradit
- phase_model přetrénovat měsíčně

## 5. Runtime úrovně

| | T0 retrieval | T1 on-device malý LLM | T2 online |
|---|---|---|---|
| Co | vše výše | Gemma 3n / Qwen3-0.6B (llama.cpp) přeformuluje vybranou nápovědu/osnovu do kontextu (jména, které rodič použil) | vLLM na Sparku, plná personalizace |
| Latence | < 50 ms | 0,5–2 s (jen pozadí, nikdy blokující) | 0,5–1,5 s |
| Kdy | default, free | volitelně na silnějších telefonech | premium / když je síť a kapacita |
| Riziko | monotónnost → řešeno velikostí banku + rotací | halucinace → omezit na parafrázi s vstupem z T0 | kapacita Sparku |

T0 musí být **plnohodnotný zážitek**, ne nouzovka. T1/T2 jen leští.

## 6. Datový model (pack SQLite)

```sql
motifs(id, type, atu, country_code, region_code, tags, age_min, age_max)
verbalizations(motif_id, lang, age_band, tone, length, text)
hint_bank(id, motif_id nullable, phase, environment_id nullable, lang, text, weight)
hint_vec  (vec0: id, trigger_embedding int8[384])
transitions(from_type, to_type, tags, lang, text)
compat(motif_a, motif_b, score)
outline_templates(id, lang, age_band, text)
scene_prompts(id, motif_id, environment_id, phase, text_en)
scene_vec (vec0: id, embedding int8[384])
countries / environments / creatures (…_i18n)
phase_model(version, weights_json)
meta(pack_id, version, embed_model, embed_ver, built_at)
```
`embed_model`/`embed_ver` v `meta` — při změně embedding modelu je nutný rebuild všech vektorů (index je vázaný na model); text zůstává.

## 7. Odhady (Spark, jednorázově + přírůstky)

- verbalize: ~6 M krátkých výstupů → s 7B modelem na vLLM batch ~2–4 dny; Tier 1 jazyky napřed (1 den).
- hint_bank: ~800k × 16 jazyků → dělat **jen pro motivy s pokrytím země** a Tier 1 jazyky napřed (~1 den), zbytek přírůstkově z missů.
- embed: 10 M vektorů e5-small na GB10 ~hodiny.
- Startovní stav pro MVP: cs + en, ~500 motivů (Grimm/Erben/Němcová/Lang), plný hint_bank → hotové za noc.

## 8. Kroky pro Opuse

1. Vybrat embedding model, ověřit identický výstup Spark (Python) vs. zařízení (ONNX int8) — tolerance cos > 0,99 na 100 vzorcích. Bez toho nic dalšího.
2. `/rag/verbalize.py`, `/rag/hints.py`, `/rag/transitions.py`, `/rag/scene_prompts.py` přes LiteLLM batch, JSON-schema výstupy, filtry (věk, spoiler, násilí).
3. `/rag/build_pack.py` → SQLite + sqlite-vec, `meta`, manifest; `core.cs.db`, `country.CZ.cs.db` jako první.
4. Flutter: `RagStore` (ATTACH packů, dotazy), `Embedder` (onnxruntime), `PhaseModel`, `HintPicker` s předpočítanou nápovědou, `OutlineComposer`.
5. Logování `hint_events` / `retrieval_misses` → noční doplňování.
6. Benchmark: latence hint retrievalu na středním Androidu < 100 ms end-to-end od konce STT okna.
7. Až poté T1 (volitelný on-device LLM) — jen pokud T0 působí monotónně po testu s 5 rodinami.

---

**Stav 2026-09-24:** nic z §8 nezačato. Otevřené před krokem 1: (a) §8.2–3 předpokládají Python (`/rag/*.py`), ale rozhodnutí z této session je "backend v Go" — rozhodnout, zda ML pipeline na Sparku (embedding, ONNX export, sqlite-vec build) smí být Python, nebo jde do `/corpus`-style Go CLI; (b) §8.1 vyžaduje přístup na Spark a výběr embedding modelu.
