// Command server runs the story-gateway HTTP API described in
// STORYTELLER_PLAN.md §2. First cut: GET /v1/daily backed by an
// in-memory seed corpus — swap to Postgres once corpus/cmd/extract has
// populated corpus_motifs.
package main

import (
	"context"
	"errors"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/lioilsources/storyteller/gateway/internal/api"
	"github.com/lioilsources/storyteller/gateway/internal/config"
	"github.com/lioilsources/storyteller/gateway/internal/offer"
)

func main() {
	cfg := config.Load()

	var motifs offer.Source = offer.SeedSource{}
	if cfg.DatabaseURL == "" {
		slog.Warn("DATABASE_URL not set — serving GET /v1/daily from the hand-written seed corpus, not corpus_motifs")
	} else {
		// TODO(M1): swap in a Postgres-backed offer.Source once
		// corpus/cmd/extract has populated corpus_motifs. Keeping the
		// seed source wired for both branches for now so the server
		// never fails to start just because the DB isn't ready.
		slog.Warn("DATABASE_URL is set but Postgres-backed offer.Source isn't wired up yet — still serving the seed corpus")
	}

	srv := api.NewServer(motifs)

	httpServer := &http.Server{
		Addr:              ":" + cfg.Port,
		Handler:           srv.Routes(),
		ReadHeaderTimeout: 5 * time.Second,
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	go func() {
		slog.Info("story-gateway listening", "port", cfg.Port)
		if err := httpServer.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			slog.Error("server error", "err", err)
			os.Exit(1)
		}
	}()

	<-ctx.Done()
	slog.Info("shutting down")

	shutdownCtx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := httpServer.Shutdown(shutdownCtx); err != nil {
		slog.Error("shutdown error", "err", err)
	}
}
