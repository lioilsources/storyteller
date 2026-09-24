package comfy

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"
)

// mockComfy is a tiny in-memory stand-in for ComfyUI's HTTP API, just
// enough surface for Client. History starts empty for a prompt id and
// "completes" after completeAfter calls to /history for it — that's
// what exercises Wait's polling loop.
type mockComfy struct {
	completeAfter int
	historyHits   map[string]int
	lastSubmitted Workflow
	failStatus    string // if set, /history reports completed:false with this status
	uploaded      map[string][]byte
}

func newMockComfy() *mockComfy {
	return &mockComfy{completeAfter: 1, historyHits: map[string]int{}, uploaded: map[string][]byte{}}
}

func (m *mockComfy) server() *httptest.Server {
	mux := http.NewServeMux()
	mux.HandleFunc("/prompt", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			Prompt Workflow `json:"prompt"`
		}
		if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
			http.Error(w, err.Error(), 400)
			return
		}
		m.lastSubmitted = body.Prompt
		json.NewEncoder(w).Encode(map[string]string{"prompt_id": "p1"})
	})
	mux.HandleFunc("/history/p1", func(w http.ResponseWriter, r *http.Request) {
		m.historyHits["p1"]++
		if m.historyHits["p1"] < m.completeAfter {
			json.NewEncoder(w).Encode(map[string]any{}) // not in history yet
			return
		}
		status := map[string]any{"completed": true, "status_str": "success"}
		if m.failStatus != "" {
			status = map[string]any{"completed": false, "status_str": m.failStatus}
		}
		resp := map[string]any{
			"p1": map[string]any{
				"outputs": map[string]any{
					"9": map[string]any{"images": []ImageRef{{Filename: "out.png", Subfolder: "", Type: "output"}}},
				},
				"status": status,
			},
		}
		json.NewEncoder(w).Encode(resp)
	})
	mux.HandleFunc("/view", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Query().Get("filename") != "out.png" {
			http.Error(w, "not found", 404)
			return
		}
		w.Write([]byte("PNGDATA"))
	})
	mux.HandleFunc("/upload/image", func(w http.ResponseWriter, r *http.Request) {
		if err := r.ParseMultipartForm(10 << 20); err != nil {
			http.Error(w, err.Error(), 400)
			return
		}
		file, header, err := r.FormFile("image")
		if err != nil {
			http.Error(w, err.Error(), 400)
			return
		}
		defer file.Close()
		data, _ := io.ReadAll(file)
		m.uploaded[header.Filename] = data
		json.NewEncoder(w).Encode(map[string]string{"name": header.Filename})
	})
	return httptest.NewServer(mux)
}

func TestSubmitSendsWorkflowAndReturnsPromptID(t *testing.T) {
	m := newMockComfy()
	srv := m.server()
	defer srv.Close()

	wf, im := fixtureWF()
	if err := Inject(wf, im, map[string]any{"prompt": "a fox", "seed": int64(7)}); err != nil {
		t.Fatal(err)
	}
	id, err := NewClient(srv.URL).Submit(context.Background(), wf, "test")
	if err != nil {
		t.Fatal(err)
	}
	if id != "p1" {
		t.Fatalf("got id %q", id)
	}
	if m.lastSubmitted["6"].Inputs["text"] != "a fox" {
		t.Fatalf("server did not receive the injected prompt: %+v", m.lastSubmitted["6"])
	}
}

func TestSubmitSurfacesServerError(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(400)
		json.NewEncoder(w).Encode(map[string]any{"error": "invalid prompt", "node_errors": map[string]any{"3": "bad seed"}})
	}))
	defer srv.Close()

	wf, _ := fixtureWF()
	_, err := NewClient(srv.URL).Submit(context.Background(), wf, "test")
	if err == nil {
		t.Fatal("expected an error")
	}
}

func TestWaitPollsUntilComplete(t *testing.T) {
	m := newMockComfy()
	m.completeAfter = 3 // not-found, not-found, then complete
	srv := m.server()
	defer srv.Close()

	imgs, err := NewClient(srv.URL).Wait(context.Background(), "p1", 5*time.Millisecond, time.Second)
	if err != nil {
		t.Fatal(err)
	}
	if len(imgs) != 1 || imgs[0].Filename != "out.png" {
		t.Fatalf("got %+v", imgs)
	}
	if m.historyHits["p1"] < 3 {
		t.Fatalf("expected at least 3 polls, got %d", m.historyHits["p1"])
	}
}

func TestWaitSurfacesFailedJob(t *testing.T) {
	m := newMockComfy()
	m.failStatus = "error: OOM"
	srv := m.server()
	defer srv.Close()

	_, err := NewClient(srv.URL).Wait(context.Background(), "p1", 5*time.Millisecond, time.Second)
	if err == nil {
		t.Fatal("expected an error")
	}
}

func TestWaitTimesOut(t *testing.T) {
	m := newMockComfy()
	m.completeAfter = 1000 // never completes within the test's budget
	srv := m.server()
	defer srv.Close()

	_, err := NewClient(srv.URL).Wait(context.Background(), "p1", 2*time.Millisecond, 20*time.Millisecond)
	if err == nil {
		t.Fatal("expected a timeout error")
	}
}

func TestViewDownloadsImage(t *testing.T) {
	m := newMockComfy()
	srv := m.server()
	defer srv.Close()

	data, err := NewClient(srv.URL).View(context.Background(), ImageRef{Filename: "out.png", Type: "output"})
	if err != nil {
		t.Fatal(err)
	}
	if string(data) != "PNGDATA" {
		t.Fatalf("got %q", data)
	}
}

func TestUploadImageRoundTrips(t *testing.T) {
	m := newMockComfy()
	srv := m.server()
	defer srv.Close()

	name, err := NewClient(srv.URL).UploadImage(context.Background(), "fox-ref.png", []byte("REFBYTES"))
	if err != nil {
		t.Fatal(err)
	}
	if name != "fox-ref.png" {
		t.Fatalf("got %q", name)
	}
	if string(m.uploaded["fox-ref.png"]) != "REFBYTES" {
		t.Fatalf("server received %q", m.uploaded["fox-ref.png"])
	}
}

func TestRenderEndToEnd(t *testing.T) {
	m := newMockComfy()
	m.completeAfter = 2
	srv := m.server()
	defer srv.Close()

	dir := writeFixtureModel(t, "txt2img")
	wf, im, err := LoadStage(dir, "txt2img")
	if err != nil {
		t.Fatal(err)
	}

	data, err := Render(context.Background(), NewClient(srv.URL), wf, im,
		map[string]any{"prompt": "a fox in a forest", "negative": "text, watermark", "seed": int64(123)},
		RenderOpts{Poll: 5 * time.Millisecond, Timeout: time.Second})
	if err != nil {
		t.Fatal(err)
	}
	if string(data) != "PNGDATA" {
		t.Fatalf("got %q", data)
	}
	if m.lastSubmitted["6"].Inputs["text"] != "a fox in a forest" || m.lastSubmitted["3"].Inputs["seed"] != float64(123) {
		t.Fatalf("submitted workflow missing injected values: %+v", m.lastSubmitted)
	}
	// The original loaded workflow must be untouched — Render clones.
	if wf["6"].Inputs["text"] != "" {
		t.Fatalf("Render mutated the shared workflow: %+v", wf["6"].Inputs)
	}
}

func TestRenderPropagatesInjectError(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		t.Fatal("server should not be contacted when Inject fails")
	}))
	defer srv.Close()

	wf, im := fixtureWF()
	_, err := Render(context.Background(), NewClient(srv.URL), wf, im, map[string]any{"nonexistent": "x"}, RenderOpts{})
	if err == nil {
		t.Fatal("expected an error")
	}
}
