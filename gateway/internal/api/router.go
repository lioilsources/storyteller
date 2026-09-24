// Package api holds the gateway's HTTP surface. Deliberately stdlib-only
// (Go 1.22+ ServeMux method+pattern routing) for the first cut described
// in STORYTELLER_PLAN.md §8 — swap in chi later if/when the router needs
// middleware chains richer than logging.
package api

import (
	"log/slog"
	"net/http"
	"time"

	"github.com/lioilsources/storyteller/gateway/internal/offer"
)

// Server holds the gateway's dependencies. motifs is an interface so
// production wiring can swap the in-memory seed corpus for a Postgres-
// backed one without changing any handler.
type Server struct {
	motifs offer.Source
}

func NewServer(motifs offer.Source) *Server {
	return &Server{motifs: motifs}
}

func (s *Server) Routes() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthz", handleHealth)
	mux.HandleFunc("GET /v1/daily", s.handleDaily)
	return withLogging(mux)
}

func withLogging(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		next.ServeHTTP(w, r)
		slog.Info("request", "method", r.Method, "path", r.URL.Path, "dur_ms", time.Since(start).Milliseconds())
	})
}
