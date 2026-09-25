package wikisource

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"
)

// APIBase is the MediaWiki API endpoint for one Wikisource language.
func APIBase(lang string) string {
	return fmt.Sprintf("https://%s.wikisource.org/w/api.php", lang)
}

// UserAgent identifies us to the Wikimedia servers. Their robot policy
// asks for a real contact address and will block generic agents, so this
// is a requirement rather than a courtesy.
const UserAgent = "storyteller-corpus-fetcher/0.1 (+https://github.com/lioilsources/storyteller; contact: oldrich.vorechovsky.jr@gmail.com)"

// Client is a thin MediaWiki API client.
type Client struct {
	HTTP *http.Client
	Lang string
}

func (c *Client) get(params url.Values, out any) error {
	params.Set("format", "json")
	params.Set("formatversion", "2")
	req, err := http.NewRequest(http.MethodGet, APIBase(c.Lang)+"?"+params.Encode(), nil)
	if err != nil {
		return err
	}
	req.Header.Set("User-Agent", UserAgent)

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("api: unexpected status %s", resp.Status)
	}
	return json.NewDecoder(resp.Body).Decode(out)
}

// Subpages lists every article-namespace page under prefix, following
// the API's continuation until exhausted.
//
// Redirects are excluded. cs.wikisource keeps a redirect for every tale
// whose title was modernised — "O princezně se zlatou hvězdou na čele"
// points at "…se zlatou hwězdou na čele" — and both live under the same
// prefix, so including them would fetch a third of Němcová twice.
func (c *Client) Subpages(prefix string) ([]string, error) {
	var titles []string
	cont := ""
	for {
		params := url.Values{
			"action":        {"query"},
			"list":          {"allpages"},
			"apprefix":      {prefix},
			"apnamespace":   {"0"},
			"aplimit":       {"500"},
			"apfilterredir": {"nonredirects"},
		}
		if cont != "" {
			params.Set("apcontinue", cont)
		}
		var out struct {
			Query struct {
				AllPages []struct{ Title string } `json:"allpages"`
			} `json:"query"`
			Continue struct {
				APContinue string `json:"apcontinue"`
			} `json:"continue"`
		}
		if err := c.get(params, &out); err != nil {
			return nil, fmt.Errorf("list subpages of %q: %w", prefix, err)
		}
		for _, p := range out.Query.AllPages {
			titles = append(titles, p.Title)
		}
		cont = out.Continue.APContinue
		if cont == "" {
			return titles, nil
		}
		time.Sleep(300 * time.Millisecond)
	}
}

// Page is one fetched Wikisource page, already reduced to plain text.
// Title is the page actually rendered, which differs from the requested
// one when a redirect was followed.
type Page struct {
	Title string
	Text  string
	URL   string
}

// Page fetches one page and returns its body as plain text.
//
// `redirects=1` matters more than it looks: without it the API happily
// renders the redirect *stub* — a 55-character "Přesměrování na:" page —
// and the caller gets a successful response containing no tale at all.
func (c *Client) Page(title string) (Page, error) {
	params := url.Values{
		"action":    {"parse"},
		"page":      {title},
		"prop":      {"text"},
		"redirects": {"1"},
	}
	var out struct {
		Parse struct {
			Title string `json:"title"`
			Text  string `json:"text"`
		} `json:"parse"`
		Error *struct {
			Code string `json:"code"`
			Info string `json:"info"`
		} `json:"error"`
	}
	if err := c.get(params, &out); err != nil {
		return Page{}, fmt.Errorf("fetch %q: %w", title, err)
	}
	if out.Error != nil {
		return Page{}, fmt.Errorf("fetch %q: api error %s: %s", title, out.Error.Code, out.Error.Info)
	}
	text, err := PlainText(out.Parse.Text)
	if err != nil {
		return Page{}, fmt.Errorf("fetch %q: %w", title, err)
	}
	resolved := out.Parse.Title
	if resolved == "" {
		resolved = title
	}
	return Page{
		Title: resolved,
		Text:  text,
		URL:   fmt.Sprintf("https://%s.wikisource.org/wiki/%s", c.Lang, strings.ReplaceAll(url.PathEscape(resolved), "%2F", "/")),
	}, nil
}
