// Package motif turns one raw tale's text into structured
// corpus_motifs rows via an LLM call (STORYTELLER_PLAN.md §3.2, steps
// "classify" + "extract" folded into one request for this first pass).
package motif

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/lioilsources/storyteller/corpus/internal/llm"
	"github.com/lioilsources/storyteller/internal/models"
)

// Extracted is the strict JSON shape the LLM is asked to return.
type Extracted struct {
	ATUCode     string   `json:"atu_code"`
	CountryCode string   `json:"country_code"` // ISO 3166-1 alpha-2, best guess from the collector/tradition, not the edition's language
	AgeMin      int      `json:"age_min"`      // 0, 3, or 6
	Soft        bool     `json:"soft"`         // true if this variant needed toning down / is borderline for young kids
	Characters  []string `json:"characters"`
	Tasks       []string `json:"tasks"`
	Problems    []string `json:"problems"`
	Endings     []string `json:"endings"`
	Tags        []string `json:"tags"`
}

const systemPrompt = `You extract structured, reusable story motifs for a children's bedtime-story app from one public-domain fairy tale.

Rules:
- Output ONLY a JSON object matching the given shape. No prose, no markdown fences.
- Each entry in characters/tasks/problems/endings is ONE short English sentence (a motif, not a summary) — reusable across different retellings, not tied to this exact tale's names or wording.
- characters: who could play this role (archetype, e.g. "a clever fox who talks its way out of trouble"), 1-4 entries.
- tasks: what the hero must accomplish, 1-3 entries.
- problems: the obstacle/antagonist/dilemma, 1-3 entries.
- endings: how it resolves happily, 1-2 entries.
- tags: 3-8 short lowercase keywords (setting, creatures, themes).
- atu_code: your best guess at the Aarne-Thompson-Uther tale type (e.g. "AT 333"), or "" if unsure.
- country_code: ISO 3166-1 alpha-2 of the tale's country/tradition of origin (e.g. "DE" for Grimm, "DK" for Andersen, "FR" for Perrault) — the folklore's origin, not the translation's language.
- age_min: 0, 3, or 6 — the youngest age this tale's content is fine for as-is.
- soft: true if the tale contains violence, death, or peril that a retelling for young children should soften.
- Never invent motifs not grounded in the text.`

func BuildMessages(taleTitle, taleText string) []llm.Message {
	user := fmt.Sprintf(`Title: %s

Text:
%s

Respond as JSON: {"atu_code":"","country_code":"","age_min":0,"soft":false,"characters":[],"tasks":[],"problems":[],"endings":[],"tags":[]}`,
		taleTitle, truncateRunes(taleText, 8000))
	return []llm.Message{
		{Role: "system", Content: systemPrompt},
		{Role: "user", Content: user},
	}
}

// Extract calls the LLM and converts its answer into corpus_motifs rows,
// tagged with sourceRef (e.g. "gutenberg:grimm:2591:012-the-golden-bird").
func Extract(ctx context.Context, c *llm.Client, taleTitle, taleText, sourceRef string) ([]models.CorpusMotif, *Extracted, error) {
	raw, err := c.ChatJSON(ctx, BuildMessages(taleTitle, taleText))
	if err != nil {
		return nil, nil, fmt.Errorf("motif: llm call for %q: %w", taleTitle, err)
	}

	var ex Extracted
	if err := json.Unmarshal([]byte(raw), &ex); err != nil {
		return nil, nil, fmt.Errorf("motif: parse llm response for %q: %w (raw: %s)", taleTitle, err, truncateRunes(raw, 300))
	}

	rows := make([]models.CorpusMotif, 0, len(ex.Characters)+len(ex.Tasks)+len(ex.Problems)+len(ex.Endings))
	add := func(t models.MotifType, texts []string) {
		for _, txt := range texts {
			txt = strings.TrimSpace(txt)
			if txt == "" {
				continue
			}
			rows = append(rows, models.CorpusMotif{
				Type:        t,
				TextEN:      txt,
				Tags:        ex.Tags,
				ATUCode:     ex.ATUCode,
				CountryCode: ex.CountryCode,
				AgeMin:      ex.AgeMin,
				Soft:        ex.Soft,
				SourceRef:   sourceRef,
			})
		}
	}
	add(models.MotifCharacter, ex.Characters)
	add(models.MotifTask, ex.Tasks)
	add(models.MotifProblem, ex.Problems)
	add(models.MotifEnding, ex.Endings)

	return rows, &ex, nil
}

func truncateRunes(s string, n int) string {
	r := []rune(s)
	if len(r) <= n {
		return s
	}
	return string(r[:n]) + "…"
}
