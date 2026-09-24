// Package offer builds the deterministic "Dnešní pohádka" 3x4 grid
// (STORYTELLER_PLAN.md §1.1): same family + same date => same offer on
// every device, picked without repeats from a motif source.
package offer

import (
	"context"
	"fmt"
	"hash/fnv"
	"math/rand"

	"github.com/lioilsources/storyteller/internal/models"
)

// Source supplies the motif pool to pick from. Implemented today by an
// embedded seed list (seed.go); once corpus/cmd/extract has populated
// corpus_motifs, swap in a Postgres-backed Source without touching this
// file.
type Source interface {
	ByType(ctx context.Context, t models.MotifType) ([]models.CorpusMotif, error)
}

// Generate deterministically picks 3 motifs of each type for familyID+date.
func Generate(ctx context.Context, src Source, familyID, date string) (*models.DailyOffer, error) {
	seed := seedFor(familyID, date)
	rng := rand.New(rand.NewSource(seed))

	chars, err := pick3(ctx, src, models.MotifCharacter, rng)
	if err != nil {
		return nil, err
	}
	tasks, err := pick3(ctx, src, models.MotifTask, rng)
	if err != nil {
		return nil, err
	}
	problems, err := pick3(ctx, src, models.MotifProblem, rng)
	if err != nil {
		return nil, err
	}
	endings, err := pick3(ctx, src, models.MotifEnding, rng)
	if err != nil {
		return nil, err
	}

	return &models.DailyOffer{
		FamilyID:   familyID,
		Date:       date,
		Seed:       seed,
		Characters: chars,
		Tasks:      tasks,
		Problems:   problems,
		Endings:    endings,
	}, nil
}

func pick3(ctx context.Context, src Source, t models.MotifType, rng *rand.Rand) ([]models.CorpusMotif, error) {
	pool, err := src.ByType(ctx, t)
	if err != nil {
		return nil, fmt.Errorf("offer: load %s motifs: %w", t, err)
	}
	if len(pool) == 0 {
		return nil, fmt.Errorf("offer: no %s motifs available", t)
	}
	n := 3
	if len(pool) < n {
		n = len(pool)
	}
	idx := rng.Perm(len(pool))[:n]
	out := make([]models.CorpusMotif, n)
	for i, p := range idx {
		out[i] = pool[p]
	}
	return out, nil
}

// seedFor turns family+date into a stable int64 seed, independent of Go
// version or map iteration order (fnv-1a is deterministic across runs).
func seedFor(familyID, date string) int64 {
	h := fnv.New64a()
	_, _ = h.Write([]byte(familyID))
	_, _ = h.Write([]byte{'|'})
	_, _ = h.Write([]byte(date))
	return int64(h.Sum64())
}
