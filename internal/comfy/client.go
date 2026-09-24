package comfy

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"net/url"
	"strings"
	"time"
)

// Client is a minimal ComfyUI HTTP API client: submit a workflow, poll
// for completion, download the resulting image. No websocket progress
// stream — polling /history is enough for batch rendering.
type Client struct {
	BaseURL string
	HTTP    *http.Client
}

func NewClient(baseURL string) *Client {
	return &Client{BaseURL: strings.TrimRight(baseURL, "/"), HTTP: &http.Client{Timeout: 30 * time.Second}}
}

type ImageRef struct {
	Filename  string `json:"filename"`
	Subfolder string `json:"subfolder"`
	Type      string `json:"type"`
}

type submitResponse struct {
	PromptID   string          `json:"prompt_id"`
	Error      json.RawMessage `json:"error"`
	NodeErrors json.RawMessage `json:"node_errors"`
}

// Submit posts a workflow (POST /prompt) and returns its prompt id.
// clientID identifies this caller to ComfyUI's queue; any stable
// non-empty string works when not also listening on its websocket.
func (c *Client) Submit(ctx context.Context, wf Workflow, clientID string) (string, error) {
	body, err := json.Marshal(map[string]any{"prompt": wf, "client_id": clientID})
	if err != nil {
		return "", fmt.Errorf("comfy: encode prompt: %w", err)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.BaseURL+"/prompt", bytes.NewReader(body))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return "", fmt.Errorf("comfy: submit: %w", err)
	}
	defer resp.Body.Close()

	raw, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("comfy: read submit response: %w", err)
	}
	var sr submitResponse
	if err := json.Unmarshal(raw, &sr); err != nil {
		return "", fmt.Errorf("comfy: decode submit response (status %s): %w (body: %s)", resp.Status, err, truncate(raw, 400))
	}
	if resp.StatusCode != http.StatusOK || sr.PromptID == "" {
		msg := fmt.Sprintf("status %s", resp.Status)
		if len(sr.Error) > 0 {
			msg += fmt.Sprintf(", error: %s", sr.Error)
		}
		if len(sr.NodeErrors) > 0 && string(sr.NodeErrors) != "{}" {
			msg += fmt.Sprintf(", node_errors: %s", sr.NodeErrors)
		}
		return "", fmt.Errorf("comfy: submit rejected: %s", msg)
	}
	return sr.PromptID, nil
}

type historyEntry struct {
	Outputs map[string]struct {
		Images []ImageRef `json:"images"`
	} `json:"outputs"`
	Status struct {
		Completed bool   `json:"completed"`
		StatusStr string `json:"status_str"`
	} `json:"status"`
}

// history returns (entry, found, error) for one prompt id.
func (c *Client) history(ctx context.Context, promptID string) (historyEntry, bool, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, c.BaseURL+"/history/"+url.PathEscape(promptID), nil)
	if err != nil {
		return historyEntry{}, false, err
	}
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return historyEntry{}, false, fmt.Errorf("comfy: history: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return historyEntry{}, false, fmt.Errorf("comfy: history: status %s", resp.Status)
	}
	var m map[string]historyEntry
	if err := json.NewDecoder(resp.Body).Decode(&m); err != nil {
		return historyEntry{}, false, fmt.Errorf("comfy: decode history: %w", err)
	}
	entry, ok := m[promptID]
	return entry, ok, nil
}

// Wait polls history until the job completes, fails, or timeout elapses.
// Returns every image any output node produced.
func (c *Client) Wait(ctx context.Context, promptID string, poll, timeout time.Duration) ([]ImageRef, error) {
	deadline := time.Now().Add(timeout)
	for {
		entry, found, err := c.history(ctx, promptID)
		if err != nil {
			return nil, err
		}
		if found {
			if !entry.Status.Completed {
				return nil, fmt.Errorf("comfy: job %s did not complete: %s", promptID, entry.Status.StatusStr)
			}
			var imgs []ImageRef
			for _, o := range entry.Outputs {
				imgs = append(imgs, o.Images...)
			}
			if len(imgs) == 0 {
				return nil, fmt.Errorf("comfy: job %s completed with no image outputs", promptID)
			}
			return imgs, nil
		}
		if time.Now().After(deadline) {
			return nil, fmt.Errorf("comfy: timed out waiting for job %s", promptID)
		}
		select {
		case <-ctx.Done():
			return nil, ctx.Err()
		case <-time.After(poll):
		}
	}
}

// View downloads one output image (GET /view).
func (c *Client) View(ctx context.Context, img ImageRef) ([]byte, error) {
	u := fmt.Sprintf("%s/view?%s", c.BaseURL, url.Values{
		"filename":  {img.Filename},
		"subfolder": {img.Subfolder},
		"type":      {img.Type},
	}.Encode())
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, u, nil)
	if err != nil {
		return nil, err
	}
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, fmt.Errorf("comfy: view: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("comfy: view: status %s", resp.Status)
	}
	buf, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("comfy: read view response: %w", err)
	}
	return buf, nil
}

type uploadResponse struct {
	Name string `json:"name"`
}

// UploadImage sends a reference image (POST /upload/image) so a
// workflow's LoadImage node can address it by server-side filename —
// needed for ref2img (MODELS_PLAN §2: tier-0 reference, character
// portraits) since ComfyUI's LoadImage takes a filename, not raw bytes.
// Returns that filename, which goes straight into values["ref_image"]
// (or a char_ref_N slot) for Render/Inject.
func (c *Client) UploadImage(ctx context.Context, filename string, data []byte) (string, error) {
	var body bytes.Buffer
	w := multipart.NewWriter(&body)
	part, err := w.CreateFormFile("image", filename)
	if err != nil {
		return "", err
	}
	if _, err := part.Write(data); err != nil {
		return "", err
	}
	if err := w.WriteField("overwrite", "true"); err != nil {
		return "", err
	}
	if err := w.Close(); err != nil {
		return "", err
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.BaseURL+"/upload/image", &body)
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", w.FormDataContentType())

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return "", fmt.Errorf("comfy: upload: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		raw, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("comfy: upload: status %s: %s", resp.Status, truncate(raw, 300))
	}
	var ur uploadResponse
	if err := json.NewDecoder(resp.Body).Decode(&ur); err != nil {
		return "", fmt.Errorf("comfy: decode upload response: %w", err)
	}
	if ur.Name == "" {
		return "", fmt.Errorf("comfy: upload response had no filename")
	}
	return ur.Name, nil
}

func truncate(b []byte, n int) string {
	if len(b) <= n {
		return string(b)
	}
	return string(b[:n]) + "…"
}
