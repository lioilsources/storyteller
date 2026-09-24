package comfy

import (
	"os"
	"path/filepath"
	"testing"
)

// fixtureWorkflow mirrors the shape comfy/README.md documents: a
// CLIPTextEncode positive/negative pair, a KSampler carrying the seed,
// and a SaveImage output — titled per the IN_* convention.
const fixtureWorkflow = `{
  "3": {"class_type": "KSampler", "inputs": {"seed": 0, "steps": 4}, "_meta": {"title": "IN_SEED"}},
  "6": {"class_type": "CLIPTextEncode", "inputs": {"text": ""}, "_meta": {"title": "IN_PROMPT"}},
  "7": {"class_type": "CLIPTextEncode", "inputs": {"text": ""}, "_meta": {"title": "IN_NEGATIVE"}},
  "9": {"class_type": "SaveImage", "inputs": {"images": ["8", 0]}}
}`

const fixtureInputMap = `{
  "prompt":   {"node": "IN_PROMPT",   "field": "text"},
  "negative": {"node": "IN_NEGATIVE", "field": "text"},
  "seed":     {"node": "IN_SEED",     "field": "seed"}
}`

func writeFixtureModel(t *testing.T, stage string) string {
	t.Helper()
	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, stage+".json"), []byte(fixtureWorkflow), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "inputs.json"), []byte(fixtureInputMap), 0o644); err != nil {
		t.Fatal(err)
	}
	return dir
}

func TestLoadStage(t *testing.T) {
	dir := writeFixtureModel(t, "txt2img")
	wf, im, err := LoadStage(dir, "txt2img")
	if err != nil {
		t.Fatal(err)
	}
	if len(wf) != 4 {
		t.Fatalf("got %d nodes, want 4", len(wf))
	}
	if wf["3"].ClassType != "KSampler" || wf["3"].Meta.Title != "IN_SEED" {
		t.Fatalf("node 3 not as expected: %+v", wf["3"])
	}
	if im["seed"].Node != "IN_SEED" || im["seed"].Field != "seed" {
		t.Fatalf("input map seed entry wrong: %+v", im["seed"])
	}
}

func TestLoadWorkflowRejectsEmpty(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "empty.json")
	os.WriteFile(path, []byte(`{}`), 0o644)
	if _, err := LoadWorkflow(path); err == nil {
		t.Fatal("expected an error for a workflow with no nodes")
	}
}

func TestLoadWorkflowMissingFile(t *testing.T) {
	if _, err := LoadWorkflow(filepath.Join(t.TempDir(), "nope.json")); err == nil {
		t.Fatal("expected an error for a missing file")
	}
}

func TestCloneIsDeep(t *testing.T) {
	dir := writeFixtureModel(t, "txt2img")
	wf, _, err := LoadStage(dir, "txt2img")
	if err != nil {
		t.Fatal(err)
	}
	clone := wf.Clone()
	clone["3"].Inputs["seed"] = int64(999)
	clone["3"].Meta.Title = "MUTATED"

	if wf["3"].Inputs["seed"] != float64(0) {
		t.Fatalf("mutating the clone's node changed the original: %v", wf["3"].Inputs["seed"])
	}
	if wf["3"].Meta.Title != "IN_SEED" {
		t.Fatalf("mutating the clone's meta changed the original: %v", wf["3"].Meta.Title)
	}
}
