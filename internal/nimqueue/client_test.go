package nimqueue

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"
)

// mockGenQueue reproduces gen-queue's real contract (verified live
// 2026-09-24): 202+id on submit, poll states, 404 on an unknown job id
// (eviction), raw bytes on result regardless of declared content-type.
type mockGenQueue struct {
	pollsBeforeDone int
	polls           int
	failWithError   string // non-empty: job ends in status "error"
	lastSubmitBody  map[string]any
	lastAuthID      string
	lastAuthSecret  string
	resultBytes     []byte
}

func newMockGenQueue() *mockGenQueue {
	return &mockGenQueue{pollsBeforeDone: 1, resultBytes: []byte("JPEGBYTES")}
}

func (m *mockGenQueue) server() *httptest.Server {
	mux := http.NewServeMux()
	mux.HandleFunc("POST /nim/flux-schnell/v1/infer", func(w http.ResponseWriter, r *http.Request) {
		m.lastAuthID = r.Header.Get("CF-Access-Client-Id")
		m.lastAuthSecret = r.Header.Get("CF-Access-Client-Secret")
		json.NewDecoder(r.Body).Decode(&m.lastSubmitBody)
		w.WriteHeader(http.StatusAccepted)
		json.NewEncoder(w).Encode(map[string]any{"id": "job-1", "queue_position": 0})
	})
	mux.HandleFunc("GET /nim/flux-schnell/jobs/job-1", func(w http.ResponseWriter, r *http.Request) {
		m.polls++
		if m.failWithError != "" {
			json.NewEncoder(w).Encode(JobStatus{Status: "error", Error: m.failWithError})
			return
		}
		if m.polls < m.pollsBeforeDone {
			json.NewEncoder(w).Encode(JobStatus{Status: "queued"})
			return
		}
		json.NewEncoder(w).Encode(JobStatus{Status: "done"})
	})
	mux.HandleFunc("GET /nim/flux-schnell/jobs/job-1/result", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "image/png") // real gen-queue lies here — bytes are JPEG
		w.Write(m.resultBytes)
	})
	mux.HandleFunc("GET /nim/flux-schnell/jobs/gone", func(w http.ResponseWriter, r *http.Request) {
		http.NotFound(w, r)
	})
	mux.HandleFunc("GET /nim/flux-schnell/jobs/gone/result", func(w http.ResponseWriter, r *http.Request) {
		http.NotFound(w, r)
	})
	mux.HandleFunc("POST /nim/flux-kontext/v1/infer", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusAccepted)
		json.NewEncoder(w).Encode(map[string]any{"id": "job-kontext"})
	})
	return httptest.NewServer(mux)
}

func TestSubmitSchnellSendsExactRequestShape(t *testing.T) {
	m := newMockGenQueue()
	srv := m.server()
	defer srv.Close()

	id, err := NewClient(srv.URL).SubmitSchnell(context.Background(), SchnellRequest{
		Prompt: "a fox in a forest", Width: 1024, Height: 1024, Steps: 4, Seed: 42,
	})
	if err != nil {
		t.Fatal(err)
	}
	if id != "job-1" {
		t.Fatalf("got id %q", id)
	}
	if m.lastSubmitBody["prompt"] != "a fox in a forest" || m.lastSubmitBody["steps"] != float64(4) {
		t.Fatalf("server received %+v", m.lastSubmitBody)
	}
}

func TestSubmitKontext(t *testing.T) {
	m := newMockGenQueue()
	srv := m.server()
	defer srv.Close()

	id, err := NewClient(srv.URL).SubmitKontext(context.Background(), KontextRequest{
		Prompt: "make the sky purple", Image: "data:image/png;base64,abc", AspectRatio: "match_input_image", CFGScale: 3.5, Steps: 30, Seed: 1,
	})
	if err != nil {
		t.Fatal(err)
	}
	if id != "job-kontext" {
		t.Fatalf("got id %q", id)
	}
}

func TestNoAuthHeadersOnLAN(t *testing.T) {
	m := newMockGenQueue()
	srv := m.server()
	defer srv.Close()

	c := NewClient(srv.URL) // no CF credentials — the verified LAN path
	if _, err := c.SubmitSchnell(context.Background(), SchnellRequest{}); err != nil {
		t.Fatal(err)
	}
	if m.lastAuthID != "" || m.lastAuthSecret != "" {
		t.Fatalf("expected no CF-Access headers on the LAN path, got id=%q secret-set=%v", m.lastAuthID, m.lastAuthSecret != "")
	}
}

func TestAuthHeadersSentWhenConfigured(t *testing.T) {
	m := newMockGenQueue()
	srv := m.server()
	defer srv.Close()

	c := NewClient(srv.URL)
	c.CFAccessClientID = "cid"
	c.CFAccessClientSecret = "csecret"
	if _, err := c.SubmitSchnell(context.Background(), SchnellRequest{}); err != nil {
		t.Fatal(err)
	}
	if m.lastAuthID != "cid" || m.lastAuthSecret != "csecret" {
		t.Fatalf("headers not forwarded: id=%q secret=%q", m.lastAuthID, m.lastAuthSecret)
	}
}

func TestSubmitRejectsNon202(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"error":"bad request"}`))
	}))
	defer srv.Close()

	_, err := NewClient(srv.URL).SubmitSchnell(context.Background(), SchnellRequest{})
	if err == nil {
		t.Fatal("expected an error")
	}
}

func TestStatusPollsUntilDone(t *testing.T) {
	m := newMockGenQueue()
	m.pollsBeforeDone = 3
	srv := m.server()
	defer srv.Close()

	c := NewClient(srv.URL)
	st, err := c.Wait(context.Background(), ModelFluxSchnell, "job-1", 5*time.Millisecond, time.Second)
	if err != nil {
		t.Fatal(err)
	}
	if !st.Done() {
		t.Fatalf("got %+v", st)
	}
	if m.polls < 3 {
		t.Fatalf("expected at least 3 polls, got %d", m.polls)
	}
}

func TestWaitSurfacesJobError(t *testing.T) {
	m := newMockGenQueue()
	m.failWithError = "NIM container unavailable"
	srv := m.server()
	defer srv.Close()

	_, err := NewClient(srv.URL).Wait(context.Background(), ModelFluxSchnell, "job-1", 5*time.Millisecond, time.Second)
	if err == nil {
		t.Fatal("expected an error")
	}
}

func TestWaitTimesOut(t *testing.T) {
	m := newMockGenQueue()
	m.pollsBeforeDone = 1000
	srv := m.server()
	defer srv.Close()

	_, err := NewClient(srv.URL).Wait(context.Background(), ModelFluxSchnell, "job-1", 2*time.Millisecond, 20*time.Millisecond)
	if err == nil {
		t.Fatal("expected a timeout error")
	}
}

func TestStatusEvicted(t *testing.T) {
	m := newMockGenQueue()
	srv := m.server()
	defer srv.Close()

	_, err := NewClient(srv.URL).Status(context.Background(), ModelFluxSchnell, "gone")
	if err != ErrJobEvicted {
		t.Fatalf("got %v, want ErrJobEvicted", err)
	}
}

func TestResultEvicted(t *testing.T) {
	m := newMockGenQueue()
	srv := m.server()
	defer srv.Close()

	_, err := NewClient(srv.URL).Result(context.Background(), ModelFluxSchnell, "gone")
	if err != ErrJobEvicted {
		t.Fatalf("got %v, want ErrJobEvicted", err)
	}
}

func TestResultReturnsRawBytesRegardlessOfDeclaredContentType(t *testing.T) {
	m := newMockGenQueue()
	m.resultBytes = []byte("\xff\xd8\xffJPEGSTARTMARKERBYTES") // real JPEG magic, "image/png" header
	srv := m.server()
	defer srv.Close()

	data, err := NewClient(srv.URL).Result(context.Background(), ModelFluxSchnell, "job-1")
	if err != nil {
		t.Fatal(err)
	}
	if string(data) != string(m.resultBytes) {
		t.Fatalf("got %q", data)
	}
}

func TestGenerateSchnellEndToEnd(t *testing.T) {
	m := newMockGenQueue()
	m.pollsBeforeDone = 2
	srv := m.server()
	defer srv.Close()

	data, err := NewClient(srv.URL).GenerateSchnell(context.Background(), SchnellRequest{
		Prompt: "a fox in a forest", Width: 1024, Height: 1024, Steps: 4, Seed: 42,
	})
	if err != nil {
		t.Fatal(err)
	}
	if string(data) != "JPEGBYTES" {
		t.Fatalf("got %q", data)
	}
}
