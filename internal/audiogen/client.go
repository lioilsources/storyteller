// Package audiogen is a client for AiStack's audio service on Spark
// (services/audio: ACE-Step music, MOSS-SoundEffect SFX) — same submit →
// poll → download shape as internal/nimqueue: POST returns 202 {job_id},
// GET /v1/audio/jobs/{id} until done/error, then fetch outputs[0].url.
package audiogen

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"
)

type Client struct {
	BaseURL string // e.g. http://192.168.88.66:8093 (LAN, no auth)
	HTTP    *http.Client
	Poll    time.Duration
}

func NewClient(base string) *Client {
	return &Client{BaseURL: strings.TrimRight(base, "/"), HTTP: &http.Client{Timeout: 60 * time.Second}, Poll: 2 * time.Second}
}

// MusicRequest is services/audio's MusicRequest (app/schemas.py).
type MusicRequest struct {
	Prompt       string  `json:"prompt"`
	DurationS    float64 `json:"duration_s"`
	Seed         int64   `json:"seed"`
	Instrumental bool    `json:"instrumental"`
	Loop         bool    `json:"loop"`
	Format       string  `json:"format"`
	Variations   int     `json:"variations"`
}

// SfxRequest is services/audio's SfxRequest.
type SfxRequest struct {
	Prompt     string  `json:"prompt"`
	DurationS  float64 `json:"duration_s"`
	Seed       int64   `json:"seed"`
	Mono       bool    `json:"mono"`
	Format     string  `json:"format"`
	Variations int     `json:"variations"`
}

type output struct {
	URL      string `json:"url"`
	Filename string `json:"filename"`
}

type job struct {
	JobID   string   `json:"job_id"`
	Status  string   `json:"status"` // queued | running | done | error
	Error   string   `json:"error"`
	Outputs []output `json:"outputs"`
}

// Music renders one track and returns the first output's bytes.
func (c *Client) Music(ctx context.Context, r MusicRequest) ([]byte, error) {
	return c.run(ctx, "/v1/audio/music", r)
}

// Sfx renders one sound effect and returns the first output's bytes.
func (c *Client) Sfx(ctx context.Context, r SfxRequest) ([]byte, error) {
	return c.run(ctx, "/v1/audio/sfx", r)
}

func (c *Client) run(ctx context.Context, path string, body any) ([]byte, error) {
	raw, _ := json.Marshal(body)
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.BaseURL+path, bytes.NewReader(raw))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	var j job
	if err := c.do(req, http.StatusAccepted, &j); err != nil {
		return nil, fmt.Errorf("submit: %w", err)
	}
	for {
		select {
		case <-ctx.Done():
			return nil, ctx.Err()
		case <-time.After(c.Poll):
		}
		req, _ := http.NewRequestWithContext(ctx, http.MethodGet, c.BaseURL+"/v1/audio/jobs/"+j.JobID, nil)
		var s job
		if err := c.do(req, http.StatusOK, &s); err != nil {
			return nil, fmt.Errorf("poll %s: %w", j.JobID, err)
		}
		switch s.Status {
		case "done":
			if len(s.Outputs) == 0 {
				return nil, fmt.Errorf("job %s done without outputs", j.JobID)
			}
			return c.download(ctx, s.Outputs[0].URL)
		case "error":
			return nil, fmt.Errorf("job %s: %s", j.JobID, s.Error)
		}
	}
}

func (c *Client) download(ctx context.Context, url string) ([]byte, error) {
	if !strings.HasPrefix(url, "http") {
		url = c.BaseURL + url // the service returns paths relative to itself
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, err
	}
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("download %s: HTTP %d", url, resp.StatusCode)
	}
	return io.ReadAll(resp.Body)
}

func (c *Client) do(req *http.Request, want int, into any) error {
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	b, _ := io.ReadAll(resp.Body)
	if resp.StatusCode != want {
		return fmt.Errorf("HTTP %d: %s", resp.StatusCode, strings.TrimSpace(string(b)))
	}
	return json.Unmarshal(b, into)
}
