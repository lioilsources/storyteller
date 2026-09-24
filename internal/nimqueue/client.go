// Package nimqueue talks to AiStack's gen-queue: the async job-queue
// front for NVIDIA NIM image models (flux-schnell, flux-kontext) that
// the Ol1nLLM Flutter app already uses in production. Protocol reverse
// engineered from Ol1nLLM's client code and AiStack's gen-queue source
// (see internal/nimqueue/README.md), then verified against the real
// service on 2026-09-24.
//
// This is a different backend than internal/comfy: gen-queue fronts a
// synchronous NIM container call with a submit/poll/download job queue
// (to dodge Cloudflare's 100s edge timeout and survive app suspension),
// not ComfyUI's node-graph API. models.backend = 'nim' rows
// (MODELS_PLAN §3) go through this package; 'comfy' rows go through
// internal/comfy.
//
// Reachability (verified live): on Spark's LAN, gen-queue is published
// unauthenticated at 0.0.0.0:8091 — CFAccessClientID/Secret are only
// needed when calling through the public https://llm.ol1n.com/nim/...
// Cloudflare Access-gated route. Leave them empty for the LAN path.
package nimqueue

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"
)

// Model is one of the two gen-queue actually routes (flux-dev is NOT
// wired into gen-queue as of 2026-09-24 — see README — so it isn't a
// valid value here on purpose).
type Model string

const (
	ModelFluxSchnell Model = "flux-schnell"
	ModelFluxKontext Model = "flux-kontext"
)

type Client struct {
	BaseURL              string // e.g. http://192.168.88.66:8091 (LAN) or https://llm.ol1n.com (public)
	CFAccessClientID     string // only needed for the public route
	CFAccessClientSecret string
	HTTP                 *http.Client
}

func NewClient(baseURL string) *Client {
	return &Client{BaseURL: strings.TrimRight(baseURL, "/"), HTTP: &http.Client{Timeout: 30 * time.Second}}
}

// SchnellRequest is flux-schnell's exact request body. No negative
// prompt field — Schnell has no negative conditioning (Ol1nLLM drops it
// client-side; there's nothing to drop here because there's no field
// to hold it). Width/height/steps are not free — Schnell is a
// distilled 4-step model; the app always sends steps:4, 1024x1024.
type SchnellRequest struct {
	Prompt string `json:"prompt"`
	Width  int    `json:"width"`
	Height int    `json:"height"`
	Steps  int    `json:"steps"`
	Seed   int64  `json:"seed"`
}

// KontextRequest is flux-kontext's exact request body (image editing,
// not txt2img). Image must be a data: URL; width/height aren't free —
// the TRT engine only accepts a fixed set of buffer dimensions (the
// Flutter client snaps to the nearest one before sending; this package
// does not replicate that snapping, callers must pre-size the image).
type KontextRequest struct {
	Prompt      string  `json:"prompt"`
	Image       string  `json:"image"` // "data:image/png;base64,...."
	AspectRatio string  `json:"aspect_ratio"`
	CFGScale    float64 `json:"cfg_scale"`
	Steps       int     `json:"steps"`
	Seed        int64   `json:"seed"`
}

type submitResponse struct {
	ID            string `json:"id"`
	QueuePosition int    `json:"queue_position"`
}

// JobStatus mirrors gen-queue's polling response. Step/Total are only
// ever populated for flux-kontext; flux-schnell's "running" carries
// neither (it's a 4-step job, not worth the granularity).
type JobStatus struct {
	Status        string `json:"status"` // queued | running | done | error
	QueuePosition *int   `json:"queue_position,omitempty"`
	Step          *int   `json:"step,omitempty"`
	Total         *int   `json:"total,omitempty"`
	Error         string `json:"error,omitempty"`
}

func (s JobStatus) Done() bool   { return s.Status == "done" }
func (s JobStatus) Failed() bool { return s.Status == "error" }

// ErrJobEvicted is returned by Status/Wait when gen-queue answers 404:
// the job's result TTL (default 1h) expired, or gen-queue itself
// restarted and lost its in-memory job table. There is nothing to
// resume — the caller must submit again.
var ErrJobEvicted = fmt.Errorf("nimqueue: job evicted (TTL expired or queue restarted) — submit again")

func (c *Client) authHeaders(req *http.Request) {
	if c.CFAccessClientID != "" && c.CFAccessClientSecret != "" {
		req.Header.Set("CF-Access-Client-Id", c.CFAccessClientID)
		req.Header.Set("CF-Access-Client-Secret", c.CFAccessClientSecret)
	}
}

func (c *Client) submit(ctx context.Context, model Model, body any) (string, error) {
	buf, err := json.Marshal(body)
	if err != nil {
		return "", fmt.Errorf("nimqueue: encode request: %w", err)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, fmt.Sprintf("%s/nim/%s/v1/infer", c.BaseURL, model), strings.NewReader(string(buf)))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")
	c.authHeaders(req)

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return "", fmt.Errorf("nimqueue: submit: %w", err)
	}
	defer resp.Body.Close()

	raw, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("nimqueue: read submit response: %w", err)
	}
	if resp.StatusCode != http.StatusAccepted {
		return "", fmt.Errorf("nimqueue: submit rejected: status %s: %s", resp.Status, truncate(raw, 300))
	}
	var sr submitResponse
	if err := json.Unmarshal(raw, &sr); err != nil {
		return "", fmt.Errorf("nimqueue: decode submit response: %w (body: %s)", err, truncate(raw, 300))
	}
	if sr.ID == "" {
		return "", fmt.Errorf("nimqueue: submit response had no job id")
	}
	return sr.ID, nil
}

// SubmitSchnell posts a flux-schnell job (POST /nim/flux-schnell/v1/infer, 202 + job id).
func (c *Client) SubmitSchnell(ctx context.Context, req SchnellRequest) (string, error) {
	return c.submit(ctx, ModelFluxSchnell, req)
}

// SubmitKontext posts a flux-kontext job (POST /nim/flux-kontext/v1/infer, 202 + job id).
func (c *Client) SubmitKontext(ctx context.Context, req KontextRequest) (string, error) {
	return c.submit(ctx, ModelFluxKontext, req)
}

// Status polls one job (GET /nim/{model}/jobs/{id}). Returns ErrJobEvicted on a 404.
func (c *Client) Status(ctx context.Context, model Model, jobID string) (JobStatus, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, fmt.Sprintf("%s/nim/%s/jobs/%s", c.BaseURL, model, url.PathEscape(jobID)), nil)
	if err != nil {
		return JobStatus{}, err
	}
	c.authHeaders(req)

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return JobStatus{}, fmt.Errorf("nimqueue: status: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound {
		return JobStatus{}, ErrJobEvicted
	}
	if resp.StatusCode != http.StatusOK {
		raw, _ := io.ReadAll(resp.Body)
		return JobStatus{}, fmt.Errorf("nimqueue: status: status %s: %s", resp.Status, truncate(raw, 300))
	}
	var js JobStatus
	if err := json.NewDecoder(resp.Body).Decode(&js); err != nil {
		return JobStatus{}, fmt.Errorf("nimqueue: decode status: %w", err)
	}
	return js, nil
}

// Result downloads the finished job's image (GET /nim/{model}/jobs/{id}/result).
// The Content-Type header says image/png but the bytes are JPEG —
// verified live 2026-09-24, matches Ol1nLLM's own CLAUDE.md note.
// Callers must not trust the header; sniff or just always treat it as
// opaque image bytes (contentkey/asset storage doesn't care).
func (c *Client) Result(ctx context.Context, model Model, jobID string) ([]byte, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, fmt.Sprintf("%s/nim/%s/jobs/%s/result", c.BaseURL, model, url.PathEscape(jobID)), nil)
	if err != nil {
		return nil, err
	}
	c.authHeaders(req)

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, fmt.Errorf("nimqueue: result: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound {
		return nil, ErrJobEvicted
	}
	if resp.StatusCode != http.StatusOK {
		raw, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("nimqueue: result: status %s: %s", resp.Status, truncate(raw, 300))
	}
	buf, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("nimqueue: read result: %w", err)
	}
	return buf, nil
}

// Wait polls Status until done, error, evicted, or timeout. Verified
// live: a flux-schnell job typically completes within 1-2 polls at a
// 2s interval (~2-4s total) — MODELS_PLAN's tier-0 budget, unlike
// internal/comfy's flux-dev workflow (~45s).
func (c *Client) Wait(ctx context.Context, model Model, jobID string, poll, timeout time.Duration) (JobStatus, error) {
	deadline := time.Now().Add(timeout)
	for {
		st, err := c.Status(ctx, model, jobID)
		if err != nil {
			return JobStatus{}, err
		}
		if st.Done() {
			return st, nil
		}
		if st.Failed() {
			return st, fmt.Errorf("nimqueue: job %s failed: %s", jobID, st.Error)
		}
		if time.Now().After(deadline) {
			return JobStatus{}, fmt.Errorf("nimqueue: timed out waiting for job %s (last status: %s)", jobID, st.Status)
		}
		select {
		case <-ctx.Done():
			return JobStatus{}, ctx.Err()
		case <-time.After(poll):
		}
	}
}

// GenerateSchnell is the whole client-side path for one tier-0 asset:
// submit, wait, download. Defaults poll to 500ms and timeout to 15s —
// generous for an observed ~2-4s job, tight enough to fail fast if
// gen-queue or the container is down.
func (c *Client) GenerateSchnell(ctx context.Context, req SchnellRequest) ([]byte, error) {
	id, err := c.SubmitSchnell(ctx, req)
	if err != nil {
		return nil, err
	}
	if _, err := c.Wait(ctx, ModelFluxSchnell, id, 500*time.Millisecond, 15*time.Second); err != nil {
		return nil, err
	}
	return c.Result(ctx, ModelFluxSchnell, id)
}

func truncate(b []byte, n int) string {
	if len(b) <= n {
		return string(b)
	}
	return string(b[:n]) + "…"
}
