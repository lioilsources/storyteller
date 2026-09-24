package comfy

import "testing"

func fixtureWF() (Workflow, InputMap) {
	wf := Workflow{
		"3": {ClassType: "KSampler", Inputs: map[string]any{"seed": 0}, Meta: &NodeMeta{Title: "IN_SEED"}},
		"6": {ClassType: "CLIPTextEncode", Inputs: map[string]any{"text": ""}, Meta: &NodeMeta{Title: "IN_PROMPT"}},
	}
	im := InputMap{
		"prompt": {Node: "IN_PROMPT", Field: "text"},
		"seed":   {Node: "IN_SEED", Field: "seed"},
	}
	return wf, im
}

func TestInjectSetsFieldsByTitle(t *testing.T) {
	wf, im := fixtureWF()
	if err := Inject(wf, im, map[string]any{"prompt": "a fox in a forest", "seed": int64(42)}); err != nil {
		t.Fatal(err)
	}
	if wf["6"].Inputs["text"] != "a fox in a forest" {
		t.Fatalf("prompt not set: %+v", wf["6"].Inputs)
	}
	if wf["3"].Inputs["seed"] != int64(42) {
		t.Fatalf("seed not set: %+v", wf["3"].Inputs)
	}
}

func TestInjectRejectsUnknownLogicalName(t *testing.T) {
	wf, im := fixtureWF()
	err := Inject(wf, im, map[string]any{"ref_image": "portrait.png"})
	if err == nil {
		t.Fatal("expected an error: this workflow's inputs.json has no ref_image entry")
	}
}

func TestInjectRejectsMissingNode(t *testing.T) {
	wf, im := fixtureWF()
	im["style_lora"] = InputRef{Node: "IN_LORA", Field: "lora_name"} // declared, but no node has this title
	err := Inject(wf, im, map[string]any{"style_lora": "watercolor.safetensors"})
	if err == nil {
		t.Fatal("expected an error: no node is titled IN_LORA")
	}
}

func TestInjectDoesNotTouchUnrelatedNodes(t *testing.T) {
	wf, im := fixtureWF()
	before := wf["3"].Inputs["seed"]
	if err := Inject(wf, im, map[string]any{"prompt": "x"}); err != nil {
		t.Fatal(err)
	}
	if wf["3"].Inputs["seed"] != before {
		t.Fatalf("seed changed even though only prompt was injected: %v", wf["3"].Inputs["seed"])
	}
}
