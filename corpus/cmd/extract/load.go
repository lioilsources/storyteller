package main

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"

	"github.com/lioilsources/storyteller/internal/db"
	"github.com/lioilsources/storyteller/internal/models"
)

// loadIntoPostgres inserts extracted motifs into corpus_motifs (schema:
// infra/migrations/0001_init.up.sql). Untested against a live database
// as of 2026-09-24 — no Postgres instance has been stood up for this
// project yet; run `docker compose -f infra/docker-compose.yml up -d`
// and the migration first.
func loadIntoPostgres(ctx context.Context, rows []models.CorpusMotif) error {
	if len(rows) == 0 {
		fmt.Println("load: nothing to insert")
		return nil
	}
	pool, err := db.Open(ctx)
	if err != nil {
		return err
	}
	defer pool.Close()

	batch := &pgx.Batch{}
	const stmt = `INSERT INTO corpus_motifs
		(atu_code, type, text_en, tags, source_ref, country_code, region_code, age_min, soft)
		VALUES ($1, $2, $3, $4, $5, NULLIF($6, ''), NULLIF($7, ''), $8, $9)`
	for _, m := range rows {
		batch.Queue(stmt, m.ATUCode, string(m.Type), m.TextEN, m.Tags, m.SourceRef, m.CountryCode, m.RegionCode, m.AgeMin, m.Soft)
	}

	br := pool.SendBatch(ctx, batch)
	defer br.Close()
	for range rows {
		if _, err := br.Exec(); err != nil {
			return fmt.Errorf("load: insert: %w", err)
		}
	}
	fmt.Printf("load: inserted %d motifs into corpus_motifs\n", len(rows))
	return nil
}
