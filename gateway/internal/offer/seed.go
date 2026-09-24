package offer

import (
	"context"

	"github.com/lioilsources/storyteller/internal/models"
)

// SeedSource is a small, hand-written, in-memory Source used until
// corpus/cmd/extract has populated corpus_motifs in Postgres (see
// STORYTELLER_PLAN.md §8, step 1 — still TODO for Erben/Němcová).
// It exists so GET /v1/daily returns something real end-to-end today,
// clearly not the launch corpus.
type SeedSource struct{}

func (SeedSource) ByType(_ context.Context, t models.MotifType) ([]models.CorpusMotif, error) {
	switch t {
	case models.MotifCharacter:
		return seedCharacters, nil
	case models.MotifTask:
		return seedTasks, nil
	case models.MotifProblem:
		return seedProblems, nil
	case models.MotifEnding:
		return seedEndings, nil
	default:
		return nil, nil
	}
}

func motif(id string, t models.MotifType, text string, tags ...string) models.CorpusMotif {
	return models.CorpusMotif{ID: id, Type: t, TextEN: text, Tags: tags, SourceRef: "seed:hand-written"}
}

var seedCharacters = []models.CorpusMotif{
	motif("seed-char-1", models.MotifCharacter, "a clever fox who talks its way out of trouble", "fox", "forest"),
	motif("seed-char-2", models.MotifCharacter, "a blacksmith's youngest son, small but stubborn", "human", "village"),
	motif("seed-char-3", models.MotifCharacter, "a talking mill that grumbles about everything", "object", "magic"),
	motif("seed-char-4", models.MotifCharacter, "a goose girl who understands the language of birds", "human", "animal-friend"),
	motif("seed-char-5", models.MotifCharacter, "three brothers, the youngest always underestimated", "human", "siblings"),
	motif("seed-char-6", models.MotifCharacter, "a princess who would rather fix clocks than dance", "human", "royalty"),
}

var seedTasks = []models.CorpusMotif{
	motif("seed-task-1", models.MotifTask, "cross the whispering forest before the moon rises", "forest", "journey"),
	motif("seed-task-2", models.MotifTask, "find the one seed that grows a golden apple", "quest", "magic"),
	motif("seed-task-3", models.MotifTask, "trade three impossible things at the market", "market", "trickery"),
	motif("seed-task-4", models.MotifTask, "learn the true name of the wind", "magic", "wisdom"),
	motif("seed-task-5", models.MotifTask, "carry a jug of water without spilling a single drop", "trial", "patience"),
	motif("seed-task-6", models.MotifTask, "build a bridge out of what the forest offers for free", "craft", "cooperation"),
}

var seedProblems = []models.CorpusMotif{
	motif("seed-problem-1", models.MotifProblem, "a grumpy giant blocks the only path home", "giant", "obstacle"),
	motif("seed-problem-2", models.MotifProblem, "the river has frozen solid, and something is trapped beneath", "nature", "mystery"),
	motif("seed-problem-3", models.MotifProblem, "a jealous cousin steals the map at the worst moment", "rival", "betrayal"),
	motif("seed-problem-4", models.MotifProblem, "the promised gift turns out to be cursed", "magic", "dilemma"),
	motif("seed-problem-5", models.MotifProblem, "night falls and every lantern refuses to stay lit", "night", "fear"),
	motif("seed-problem-6", models.MotifProblem, "the king's riddle has three answers, and only one is safe", "riddle", "royalty"),
}

var seedEndings = []models.CorpusMotif{
	motif("seed-ending-1", models.MotifEnding, "the whole village shares the harvest under one long table", "feast", "community"),
	motif("seed-ending-2", models.MotifEnding, "the trickster and the tricked become unlikely friends", "friendship", "twist"),
	motif("seed-ending-3", models.MotifEnding, "the youngest sibling is finally seen for who they are", "recognition", "family"),
	motif("seed-ending-4", models.MotifEnding, "the curse breaks the moment someone asks for nothing in return", "kindness", "magic"),
	motif("seed-ending-5", models.MotifEnding, "the lost thing was carried home all along, in a pocket", "homecoming", "warmth"),
	motif("seed-ending-6", models.MotifEnding, "everyone gets exactly what they needed, not what they asked for", "wisdom", "twist"),
}
