package audiogen

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"
)

// Mock of services/audio's contract: 202 {job_id} → poll → relative output URL.
func TestSfxSubmitPollDownload(t *testing.T) {
	polls := 0
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch r.URL.Path {
		case "/v1/audio/sfx":
			var req SfxRequest
			if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.Format != "wav" || !req.Mono {
				t.Errorf("bad request %+v %v", req, err)
			}
			w.WriteHeader(http.StatusAccepted)
			w.Write([]byte(`{"job_id":"j1","queue_position":0}`))
		case "/v1/audio/jobs/j1":
			polls++
			if polls < 2 {
				w.Write([]byte(`{"job_id":"j1","status":"running"}`))
				return
			}
			w.Write([]byte(`{"job_id":"j1","status":"done","outputs":[{"url":"/v1/audio/jobs/j1/outputs/a.wav","filename":"a.wav"}]}`))
		case "/v1/audio/jobs/j1/outputs/a.wav":
			w.Write([]byte("RIFFdata"))
		default:
			http.NotFound(w, r)
		}
	}))
	defer srv.Close()
	c := NewClient(srv.URL)
	c.Poll = time.Millisecond
	b, err := c.Sfx(context.Background(), SfxRequest{Prompt: "owl", DurationS: 3, Mono: true, Format: "wav", Variations: 1})
	if err != nil || string(b) != "RIFFdata" {
		t.Fatalf("got %q, %v", b, err)
	}
}

func TestJobErrorSurfaces(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPost {
			w.WriteHeader(http.StatusAccepted)
			w.Write([]byte(`{"job_id":"j2"}`))
			return
		}
		w.Write([]byte(`{"job_id":"j2","status":"error","error":"CUDA out of memory"}`))
	}))
	defer srv.Close()
	c := NewClient(srv.URL)
	c.Poll = time.Millisecond
	if _, err := c.Music(context.Background(), MusicRequest{Prompt: "x"}); err == nil {
		t.Fatal("want error")
	}
}
