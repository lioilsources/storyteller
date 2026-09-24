package api

import (
	"net/http"
	"time"

	"github.com/lioilsources/storyteller/gateway/internal/offer"
)

// handleDaily implements GET /v1/daily?family=&date= from
// STORYTELLER_PLAN.md §8, step 2: a deterministic 3x4 offer for one
// family+date. `date` defaults to today (UTC); `family` defaults to
// "demo" so the endpoint is curl-able with zero setup.
func (s *Server) handleDaily(w http.ResponseWriter, r *http.Request) {
	family := r.URL.Query().Get("family")
	if family == "" {
		family = "demo"
	}
	date := r.URL.Query().Get("date")
	if date == "" {
		date = time.Now().UTC().Format("2006-01-02")
	} else if _, err := time.Parse("2006-01-02", date); err != nil {
		writeError(w, http.StatusBadRequest, "date must be YYYY-MM-DD")
		return
	}

	result, err := offer.Generate(r.Context(), s.motifs, family, date)
	if err != nil {
		writeError(w, http.StatusInternalServerError, err.Error())
		return
	}
	writeJSON(w, http.StatusOK, result)
}
