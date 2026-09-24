package comfy

import (
	"context"
	"time"
)

// RenderOpts tunes the default polling behaviour; zero values fall back
// to sane defaults.
type RenderOpts struct {
	ClientID string        // any stable non-empty string; defaults to "storyteller"
	Poll     time.Duration // default 1s
	Timeout  time.Duration // default 60s — raise for tier 1/1s/2, MODELS_PLAN §1 puts tier 0 at 1-2s
}

func (o RenderOpts) withDefaults() RenderOpts {
	if o.ClientID == "" {
		o.ClientID = "storyteller"
	}
	if o.Poll <= 0 {
		o.Poll = time.Second
	}
	if o.Timeout <= 0 {
		o.Timeout = 60 * time.Second
	}
	return o
}

// Render is the whole client-side path for one asset: inject values
// into a cloned workflow, submit it, wait for it, download the first
// image. Callers resolve `values` themselves (prompt with the style's
// prefix/suffix already applied, seed from contentkey.Seed(key_base),
// ref_image as an already-uploaded server filename — see UploadImage —
// for ref2img workflows).
func Render(ctx context.Context, client *Client, wf Workflow, inputMap InputMap, values map[string]any, opts RenderOpts) ([]byte, error) {
	opts = opts.withDefaults()

	work := wf.Clone()
	if err := Inject(work, inputMap, values); err != nil {
		return nil, err
	}
	promptID, err := client.Submit(ctx, work, opts.ClientID)
	if err != nil {
		return nil, err
	}
	images, err := client.Wait(ctx, promptID, opts.Poll, opts.Timeout)
	if err != nil {
		return nil, err
	}
	return client.View(ctx, images[0])
}
