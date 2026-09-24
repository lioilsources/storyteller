// Package comfy talks to a ComfyUI instance: loads the workflow JSON +
// input-map convention documented in comfy/README.md, injects generic
// values by node title, submits the job, waits for it, and downloads
// the result. This is the "generic injector" MODELS_PLAN §6 and
// comfy/README.md describe and mark as not written yet — it is now.
package comfy

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

// Node is one entry of a ComfyUI API-format workflow export: a numbered
// node id maps to its class, its input values (literals or [nodeID,
// outputIndex] links to other nodes), and an optional title.
type Node struct {
	ClassType string         `json:"class_type"`
	Inputs    map[string]any `json:"inputs"`
	Meta      *NodeMeta      `json:"_meta,omitempty"`
}

type NodeMeta struct {
	Title string `json:"title"`
}

// Workflow is a full API-format graph: node id -> Node.
type Workflow map[string]*Node

// InputRef names which node (by title, per comfy/README.md's IN_*
// convention) and which of its input fields one logical input fills.
type InputRef struct {
	Node  string `json:"node"`
	Field string `json:"field"`
}

// InputMap is the sidecar inputs.json: logical name -> InputRef.
type InputMap map[string]InputRef

// LoadWorkflow reads one stage's API-format export, e.g.
// comfy/workflows/flux-schnell/txt2img.json.
func LoadWorkflow(path string) (Workflow, error) {
	buf, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("comfy: read workflow %s: %w", path, err)
	}
	var wf Workflow
	if err := json.Unmarshal(buf, &wf); err != nil {
		return nil, fmt.Errorf("comfy: parse workflow %s: %w", path, err)
	}
	if len(wf) == 0 {
		return nil, fmt.Errorf("comfy: workflow %s has no nodes", path)
	}
	return wf, nil
}

// LoadInputMap reads the model's inputs.json sidecar, shared across all
// of its workflow stages (comfy/README.md).
func LoadInputMap(path string) (InputMap, error) {
	buf, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("comfy: read input map %s: %w", path, err)
	}
	var im InputMap
	if err := json.Unmarshal(buf, &im); err != nil {
		return nil, fmt.Errorf("comfy: parse input map %s: %w", path, err)
	}
	return im, nil
}

// LoadStage is the common case: <modelDir>/<stage>.json +
// <modelDir>/inputs.json, e.g. LoadStage("comfy/workflows/flux-schnell", "txt2img").
func LoadStage(modelDir, stage string) (Workflow, InputMap, error) {
	wf, err := LoadWorkflow(filepath.Join(modelDir, stage+".json"))
	if err != nil {
		return nil, nil, err
	}
	im, err := LoadInputMap(filepath.Join(modelDir, "inputs.json"))
	if err != nil {
		return nil, nil, err
	}
	return wf, im, nil
}

// Clone deep-copies a workflow so injecting values for one render never
// mutates a workflow shared across concurrent renders.
func (wf Workflow) Clone() Workflow {
	out := make(Workflow, len(wf))
	for id, n := range wf {
		inputs := make(map[string]any, len(n.Inputs))
		for k, v := range n.Inputs {
			inputs[k] = v
		}
		var meta *NodeMeta
		if n.Meta != nil {
			m := *n.Meta
			meta = &m
		}
		out[id] = &Node{ClassType: n.ClassType, Inputs: inputs, Meta: meta}
	}
	return out
}
