package comfy

import "fmt"

// Inject sets each of values (logical input name -> value) into wf by
// looking it up in inputMap, finding the node with that title, and
// setting the named field. It fails loudly (comfy/README.md) rather
// than silently ignoring a value the workflow has no slot for: a
// mistyped logical name, a workflow missing the node it's supposed to
// have, or a value meant for a stage this workflow doesn't implement
// (e.g. passing ref_image to a txt2img workflow) are all bugs, not
// no-ops.
func Inject(wf Workflow, inputMap InputMap, values map[string]any) error {
	byTitle := make(map[string]string, len(wf))
	for id, n := range wf {
		if n.Meta != nil && n.Meta.Title != "" {
			byTitle[n.Meta.Title] = id
		}
	}
	for logical, val := range values {
		ref, ok := inputMap[logical]
		if !ok {
			return fmt.Errorf("comfy: inputs.json does not declare a logical input %q", logical)
		}
		nodeID, ok := byTitle[ref.Node]
		if !ok {
			return fmt.Errorf("comfy: workflow has no node titled %q (needed for input %q)", ref.Node, logical)
		}
		wf[nodeID].Inputs[ref.Field] = val
	}
	return nil
}
