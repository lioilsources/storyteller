# Postavy StoryTelleru v jiných modelech a LoRA — plán měření v labu (handoff pro Sonnet)

Otázka uživatele: postavy světových pohádek jsou už vygenerované přes
flux-schnell (tier 0). Když chci vidět, jak by vypadaly z jiných modelů a LoRA
(nově 3D/Pixar LoRA na FLUX dev), mám je brát jako **obrázkovou referenci**,
nebo **promptovat znovu** — nebo obojí? Odpověď z plánů projektu je jasná
(MODELS_PLAN §0.2: vyšší tiery se generují **z tier 0 jako reference**, aby
přepnutí modelu nezměnilo *co* je na obrázku), ale nikdy se to neměřilo:
`ref2img` je v MODELS_PLAN §9 krok 3 a je TODO. Tenhle plán to měří — **obojí
vedle sebe, stejný prompt, stejný seed** — a výstupem jsou podklady pro
rozhodnutí, s čím ve StoryTelleru pokračovat (který model/LoRA pro který styl,
a jestli tier 1 potřebuje referenci, nebo stačí prompt+seed).

Měří se v labu Ol1nLLM (`Ol1nLLM/tools/lab`, viz jeho README), protože umí
matici modely × prompty × styly × LoRA s jednou referencí a třemi flow
(`txt2img`, `img2img`, `repose`) v jednom běhu, resumovatelně, s archy.
Kód se mění jen v Ol1nLLM (registrace LoRA, drobnosti CLI); v tomhle repu
vznikne jen dokument s výsledky a případně `comfy/workflows/*/ref2img.json`
pro vítěze — až po verdiktu, ne v rámci plánu.

Sepsáno 29. 9. 2026 po průzkumu obou rep a SPARKu. Ověřené věci jsou
psané jako fakta, domněnky jsou označené.

---

## 0. Co je změřeno o dnešním stavu

- **Postavy**: `rag/data/world_cards.json` (1400 × `{id, text_en}`) a
  `cz_cards.json` (107). Obrázky `rag/data/motif_images/<id>.jpg` (1747
  souborů, 1024², JPEG, flux-schnell přes gen-queue). Prompt postavy
  (`internal/nimqueue/cmd/render-motifs/main.go`):

  ```
  Watercolor character portrait: <text_en>. One figure, full body, standing on a plain soft cream background, soft warm colors, gentle storybook painting.
  ```

  4 kroky, 1024×1024, seed = `contentkey.Seed(sha256("character\x1f"+id))`
  oříznutý na dolních 32 bitů (NIM odmítá víc). V Pythonu:

  ```python
  h = hashlib.sha256(("character\x1f" + id).encode()).hexdigest()
  seed = (int(h[:16], 16) & 0x7fffffffffffffff) & 0xffffffff
  # fc5ee8dd1600bb0e → 1499655865 (ověřeno proti Go implementaci)
  ```

- **Styly** (`infra/seed/models_styles.sql`): 7 stylů, jen `watercolor`
  active; `papercut`, `crayon`, `anime-lite`, `woodcut`, `clay`, `folk` shadow
  a nikdy nezhodnocené (§5.5 „top-100 review“ neproběhl). **3D/Pixar styl
  v registru není** — Pixar LoRA je kandidát na nový řádek, ne úprava.
- **Modely**: `flux-schnell` (tier 0, jen NIM), `flux-dev` (tier 1, ComfyUI,
  `comfy/workflows/flux-dev/txt2img.json`, guidance 3.5, 20 kroků, 1024²),
  `sdxl-lora` (tier 1s, workflow neexistuje). `ref2img` nikde.
- **LoRA na SPARKu** (`~/Code/ComfyUI/models/loras/`): nová složka
  `3D_Pixar_Flux/` (25. 9.) s pěti FLUX-dev LoRA a `TRIGGERS.tsv`; hlavičky
  ověřené (`ss_base_model_version: flux1`, `flux-1-dev/lora`):

  | soubor | trénink | trigger |
  |---|---|---|
  | `Canopus-Pixar-3D-FluxDev-LoRA` | dim 64, 75 obr., portréty panenek | `pixar` |
  | `3D_Portrait` | dim 64, 54 obr., portréty | `3d portrait` |
  | `Cute-3d-Kawaii` | dim 64, 72 obr. | `cute 3d kawaii` |
  | `Toy_Box_Flux_v1_renderartist` | dim 32, 71 obr., celé hračkové scény | `t0yb0x style` |
  | `Toy_Box_Flux_v2_renderartist` | dim 32, 101 obr. | `t0yb0x` |

  Dál pro srovnání SDXL: `Juggernaut_XL_Lightning/All_Disney_Princess_XL_LoRA_…`
  (hlavičku ověřit), `NoobAI/MeMaXL_Flat_Anime_Style_…`. **Ostatní složky
  jsou převážně NSFW — do dětské appky nic z nich, jen tenhle whitelist.**
- **Co lab pod čím rozumí** (důležité pro čtení výsledků):
  - `flux-manga` v labu = `flux1-dev.safetensors` (fp8, t5 fp16, cfg 1,
    20 kroků) — tedy **tier 1 flux-dev** StoryTelleru, jen jiný štítek.
    FLUX-dev LoRA na něj sednou nativně (`loraFamily: flux`).
  - `flux-manga` **img2img = FLUX Kontext** (`flux1-dev-kontext` +
    `ReferenceLatent`, denoise 1.0, 28 kroků), ne klasický img2img. Je to
    jedna z kandidátních `ref2img` cest. FLUX-dev LoRA na Kontextu
    *obvykle* něco dělají, slaběji — **domněnka, měří se**.
  - `repose` = ControlNet (hloubka) z reference; u SDXL i flux-dev.
  - SDXL `img2img` = pravý img2img s `param.editDenoise` (preset ~0.72).
  - Redux (MODELS_PLAN §2 pro flux-dev) lab **nemá**. Pokud vyjde, že
    Kontext identitu nedrží a SDXL img2img styl nebere, Redux je další krok
    mimo lab.
  - `flux-schnell` v labu jede přes gen-queue: jen txt2img, 1024², bez
    LoRA, bez `--latent`. Hodí se jako sloupec „tier 0 znovu pod tímtéž
    seedem“ (kontrola, že lab reprodukuje dnešní obrázek).

## 1. Pravidla provozu

- Před každým GPU během: `ssh spark 'pgrep -af "chain.py|story.py"; docker ps --format "{{.Names}}"'`.
  Když běží render video-stacku, **nespouštět** (lab jde do téže fronty
  ComfyUI přes `comfyui.ol1n.com`, CF creds v `Ol1nLLM/.env.local`).
  gen-queue (`ai-gen-queue`) musí běžet kvůli `flux-schnell` sloupci.
- Před každou vlnou napsat uživateli počet buněk a odhad času a **počkat
  na souhlas**. Příprava (§2) je bez GPU.
- Ol1nLLM: větev `feat/lab-storyteller-characters` (worktree; hlavní
  checkout je čistý na `main`). storyteller: větev `feat/content-packs` má
  necommitnutá data v `rag/data/` — **nesahat**, jen číst; dokument
  s výsledky přidat jako nový soubor.
- Strop labu 400 buněk/běh. Obrázky postav do gitu Ol1nLLM nepatří
  (`build/lab/refs/`), do dokumentu jdou přes zapečené archy (`sheets.py`).

## 2. Příprava bez GPU

### 2.1 Vzorek postav (20)

1400 je moc; vyber 20 tak, aby pokryly typy, na kterých se modely lámou,
a zapiš výběr do `Ol1nLLM/tools/lab/candidates/storyteller-cast.json`
(`{key, id, text_en, cs_name?, category, country}`):

- 6 lidí (dítě, mladík/nejmladší syn, princezna, stařena, kovář, sluha),
- 6 zvířat (liška, zlatý pták, medvěd, ryba, kůň, had),
- 5 nadpřirozených (drak, vodník, čarodějnice, obr, skřítek),
- 3 věci/abstraktní (mluvící mlýn, kouzelný předmět, strom).

Přednost mají id, která jsou vidět v appce (`app/assets/cast/*.jpg`,
`app/lib/cast/cast_member.dart`: fox, dragon, owl, water-sprite, mill,
goose-girl, blacksmith…) — u nich existuje obrázek i české jméno; id dohledej
podle `text_en` ve `world_cards.json`/`cz_cards.json` nebo v packu
(`rag/data/packs/country.WORLD.cs.db`). Reference =
`rag/data/motif_images/<id>.jpg` → `Ol1nLLM/build/lab/refs/storyteller/<key>.jpg`.
Seed každé postavy spočítej vzorcem z §0 a ulož do téhož JSON.

### 2.2 Prompty pro tři rodiny (`candidates/storyteller-cast.yaml`)

Generátor `tools/lab/candidates/storyteller_cast.py` z JSON výš. Tělo bez
stylu (styl je v labu vlastní osa):

- `flux`: `A character portrait of <text_en>. One figure, full body, standing on a plain soft cream background.`
  — tj. dnešní prompt bez slova „Watercolor“ a bez stylové věty; tak jde
  styl měnit, aniž se mění námět.
- `juggernaut`: `a full body character portrait of <text_en>, one figure standing on a plain soft cream background`
- `danbooru`: `solo, full body, standing, simple background, <text_en>` —
  fráze uvnitř tagů; anime SDXL to snese, ale zapiš do dokumentu, že
  Pony/Illustrious tu měří i překlad fráze, ne jen model.

Doplň do CLI labu `--prompt-ids key1,key2` (výběr položek z YAML; malá
změna v `promptbodies.go` + test) — běhy s referencí jsou po postavě
a bez toho by každý násobil všech 20 promptů.

### 2.3 Styly StoryTelleru jako kandidáti (`candidates/storyteller-styles.json`)

Sedm stylů z `infra/seed/models_styles.sql` převeď 1:1 do formátu
`--styles-file` (`block = prompt_prefix + prompt_suffix`, `negative` ať
generátor vypíše k ručnímu použití přes `--negative`), plus **osmý
`pixar-3d`** (`block`: „3D animated film still, Pixar-style character
render, smooth subsurface skin, big expressive eyes, soft global
illumination, rounded stylized proportions“; `booru`: „3d, pixar style, cgi,
smooth shading, big eyes“ — návrh k měření). Generátor ať styly čte ze SQL
(regex nad `INSERT INTO styles`), ne z kopie — registr se bude měnit.

### 2.4 Registrace LoRA v `Ol1nLLM/lib/models/lora_family.dart`

Doplň do `_knownLoras` pět Pixar LoRA jako `flux` a Disney/MeMaXL podle
hlavičky (důkaz do komentáře, jako zbytek tabulky). Hádání z názvu by
`3D_Portrait`, `Cute-3d-Kawaii` a Disney dalo `unknown`. **Kolize klíče**:
`Velvets_Mythic_Fantasy_Styles…` leží ve `Flux_Dev/` (FLUX) i
`Illustrious_WAI/` (SDXL) — `familyOfLora` složku zahazuje; doplň klíč se
složkou s předností před holým názvem + test. Hlavička z Macu:

```bash
ssh spark 'python3 - <<EOF
import json,struct
f="/home/ol1n/Code/ComfyUI/models/loras/Juggernaut_XL_Lightning/All_Disney_Princess_XL_LoRA_Model_from_Ralph_Breaks_the_Internet.safetensors"
h=open(f,"rb"); n=struct.unpack("<Q",h.read(8))[0]; md=json.loads(h.read(n)).get("__metadata__",{})
print({k:md.get(k) for k in ("ss_base_model_version","ss_sd_model_name","modelspec.architecture")})
EOF'
```

### 2.5 Metrika konzistence (doporučeno, ne blokující)

MODELS_PLAN §2 gate je `DINOv2 cos(ref, variant) ≥ 0.80`. Lab má jen
`refSim` (korelace šedotónu) a ArcFace (na kreslených postavách k ničemu).
Přidej `tools/lab/dino.py` po vzoru `arcface.py` (torch hub `dinov2_vits14`,
CPU, ~0.3 s/buňka, výsledky do `identity.json` vedle ArcFace, sloupec
v `lab score`). Pak dokument měří **tou metrikou, která bude v produkci
rozhodovat o `degraded`**. Když to nestihneš, verdikt okem + refSim, ale
napiš to.

Sanity: `make lab-dry` s YAML, styly a `--ref` projde na všech modelech
z vlny A bez „nemá text pro rodinu“.

## 3. Vlny měření (GPU, každá po souhlasu)

Vždy `--latent 1024x1024` (tier 0 je 1024²; `flux-schnell` `--latent`
odmítá, ale 1024² je jeho default, takže projde), `--negative` z watercolor
řádku registru (společný dětský negativ). Po běhu `lab score`, arch přes
`sheets.py` (přidat do `WAVES`), archy poslat uživateli hned.

### Vlna A — modely × styly, txt2img, 8 postav (~360 buněk)

```bash
lab run --prompts-yaml candidates/storyteller-cast.yaml --prompt-ids <8 klíčů> \
        --models flux-schnell,flux-manga,juggernaut-xl,illustrious-xl,noobai-xl \
        --flows txt2img --latent 1024x1024 \
        --styles-file candidates/storyteller-styles.json \
        --styles watercolor,papercut,crayon,anime-lite,woodcut,clay,folk,pixar-3d
```

Seed 777 pro všechny (tady jde o styl, ne o shodu s tier 0). Odpovídá na
**`preferred_model` pro každý styl** (dnes odhad v SQL: watercolor →
sdxl-lora, ostatní → flux-dev) a jestli Pixar look jde z promptu bez LoRA.
Zároveň první skutečný §5.5 review šesti shadow stylů. 5 modelů × 8 postav
× 9 (8 stylů + baseline) = 360.

### Vlna B — reference vs. prompt, po postavě (20 běhů × ~30 buněk)

Tohle je odpověď na otázku uživatele. Jeden běh na postavu, **její seed**:

```bash
lab run --ref build/lab/refs/storyteller/$K.jpg --seed $SEED \
        --prompts-yaml candidates/storyteller-cast.yaml --prompt-ids $K \
        --models flux-schnell,flux-manga,juggernaut-xl,illustrious-xl \
        --flows txt2img,img2img,repose --latent 1024x1024 \
        --styles-file candidates/storyteller-styles.json --styles watercolor,pixar-3d
```

Řádky: flow × {baseline, watercolor, pixar-3d}; sloupce: modely.
`flux-schnell txt2img watercolor` pod stejným seedem by měl dát **dnešní
obrázek** (kontrola reprodukce; pokud ne, prompt se liší — porovnej
s `render-motifs`). Čte se:

1. **txt2img flux-manga (= flux-dev) se stejným promptem a seedem vs.
   reference** — kolik kompozice a postavy zůstane bez reference. Čekám,
   že málo (jiný model, jiná trajektorie šumu), a to je argument pro `ref2img`.
   Když by DINO vyšlo ≥ 0.80 i tak, tier 1 může být pouhý txt2img a
   `ref2img` odpadá — levné a důležité zjištění.
2. **img2img flux-manga = Kontext** — drží postavu a bere styl? To je
   kandidát na `comfy/workflows/flux-dev/ref2img.json` místo Reduxu.
3. **repose** (ControlNet hloubka) — drží pózu/kompozici, mění všechno
   ostatní; pro „přepnutí stylu“ může být lepší než img2img.
4. **SDXL img2img** (juggernaut/illustrious) při presetovém denoise — pro
   tier 1s (`sdxl-lora`) cesta z MODELS_PLAN (IP-Adapter tam není, jen denoise).

### Vlna C — Pixar LoRA na flux-dev, txt2img (5 běhů × 20 postav)

Trigger na začátek promptu: lab násobí řádky textového pole jako prefix
k položkám YAML, jeden běh na LoRA:

```bash
for L in "Canopus-Pixar-3D-FluxDev-LoRA:pixar" "3D_Portrait:3d portrait" \
         "Cute-3d-Kawaii:cute 3d kawaii" "Toy_Box_Flux_v2_renderartist:t0yb0x" \
         "Toy_Box_Flux_v1_renderartist:t0yb0x style"; do
  lab run --prompts-yaml candidates/storyteller-cast.yaml --models flux-manga \
          --flows txt2img --latent 1024x1024 --no-styles \
          --subject "${L#*:}," --lora "3D_Pixar_Flux/${L%%:*}.safetensors"
done
```

(Nanečisto ověř, že se prefix skládá před tělo z YAML — `prompt`
v manifestu je čtený zpátky z grafu.) Baseline = flux-manga bez LoRA
z vlny A/B. Vybere **2 finalisty**. Sleduj typy postav: portrétní LoRA
(Canopus, 3D_Portrait, Kawaii) můžou u celé postavy zvířete/věci selhat,
Toy Box je z celých scén.

### Vlna D — finalisté z reference (20 postav × 2 LoRA × 3 flow = 120 buněk)

```bash
lab run --ref build/lab/refs/storyteller/$K.jpg --seed $SEED \
        --prompts-yaml candidates/storyteller-cast.yaml --prompt-ids $K \
        --models flux-manga --flows txt2img,img2img,repose --latent 1024x1024 \
        --no-styles --subject "<trigger>," --lora "3D_Pixar_Flux/<finalista>.safetensors"
```

Přímé srovnání pro nový styl: prompt+LoRA vs. Kontext+LoRA vs.
ControlNet+LoRA, stejná postava, stejný seed.

### Vlna E — knoby vítěze (~120 buněk)

```bash
--sweep 'param.loraStrength=0.5|0.8|1.0|1.3'          # 4 postavy, txt2img+img2img
--sweep 'param.seed=<seed>|777|778'                    # styl, nebo šum?
--models juggernaut-xl,illustrious-xl --flows img2img --sweep 'param.editDenoise=0.5|0.6|0.7|0.8'
```

Poslední řádek je přímo MODELS_PLAN §2 „denoise 0.55–0.7“ pro SDXL —
dnes odhad, tady se změří.

## 4. Hodnocení a dokument

Do `STORYTELLER_CHARACTER_MODELS.md` (tady v repu; archy zůstávají
v `Ol1nLLM/docs/sheets/`, odkazuj cestou i id běhu). Za každou buňku
`csv` s 0/1/2:

| sloupec | 0 | 2 |
|---|---|---|
| `same` | jiná postava / kompozice než tier 0 | táž postava, dítě by ji poznalo |
| `style` | styl modelu beze změny | styl jasně převzatý |
| `frame` | pozadí/ořez nepoužitelné jako karta | celá postava, klidné pozadí |
| `kid` | artefakty, děsivé, text v obraze | čistá dětská ilustrace |

plus DINO cos k referenci, když §2.5 vznikne.

Dokument musí výslovně vyplnit tuhle tabulku — to jsou ta „rozhodnutí,
s čím pokračovat“:

| otázka | odpověď z vlny | důsledek v repu |
|---|---|---|
| Stačí tier 1 jako txt2img se stejným promptem a seedem? | B (řádek 1) | ano → `ref2img` nepotřebujeme, jen `preferred_model`; ne → `ref2img` je krok 3 MODELS_PLAN a musí se napsat |
| Která `ref2img` cesta drží postavu a bere styl: Kontext, ControlNet, SDXL img2img? | B, D | `comfy/workflows/<model>/ref2img.json` pro vítěze; hodnota `ref_strength`/denoise ve `styles` z vlny E |
| Který model pro který styl (`preferred_model`)? | A | update `infra/seed/models_styles.sql`; shadow styly → active/retired |
| Má Pixar/3D být nový styl a s jakou LoRA a silou? | C, D, E | nový řádek `styles` (`lora_path`, `lora_strength`), `sdxl-lora`/`flux-dev-lora` model row; trigger do `prompt_prefix` |
| Kolik postav by při přepnutí stylu propadlo gate DINO ≥ 0.80? | B, D (DINO) | odhad % `degraded` per (model, styl) pro MODELS_PLAN §8 |

## 5. Mimo tento plán

- Redux `ref2img` pro flux-dev (MODELS_PLAN §2) — lab ho nemá; jen pokud
  Kontext i ControlNet propadnou.
- IP-Adapter + ControlNet pro `sdxl-lora` — v labu jde jen `repose`
  (ControlNet) a img2img zvlášť, ne kombinace.
- Scény (`scene_cards.json`, 165) a motivy úkol/problém/konec — jiný
  prompt, jiná otázka (kompozice víc postav); až po postavách.
- Přepis `render-motifs` na jiný model/tier a noční `upgrade` joby — až po
  verdiktu.

## 6. Odhad rozsahu

| vlna | buněk | čas (schnell ~3 s, SDXL ~6 s, flux-dev ~20 s, Kontext ~30 s) |
|---|---|---|
| A | 360 | ~60 min |
| B | 20 × ~30 = 600 | ~2 h (dá se začít na 8 postavách z A) |
| C | 100 | ~35 min |
| D | 120 | ~50 min |
| E | ~120 | ~40 min |

Celkem ~5 h GPU po částech. Příprava (§2) jde commitnout v Ol1nLLM
samostatně, než se cokoli spustí.

## 7. Kontrolní seznam před předáním

- [ ] Ol1nLLM: `flutter analyze`, `go test ./tools/lab/...` čisté
- [ ] `_knownLoras` doplněné s důkazem, test klíče se složkou
- [ ] `storyteller-cast.json` (20 postav, id, seed, kategorie) + reference v `build/lab/refs/storyteller/`
- [ ] generátory YAML promptů a JSON stylů (ze SQL), `--prompt-ids`, `lab-dry` projde
- [ ] `dino.py` nebo výslovná poznámka, že se hodnotilo okem
- [ ] po každé vlně `lab score`, arch, řádek ve `WAVES`, archy uživateli
- [ ] `STORYTELLER_CHARACTER_MODELS.md` s vyplněnou rozhodovací tabulkou z §4
