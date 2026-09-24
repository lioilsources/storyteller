// Package config loads gateway settings from the environment, with
// defaults sane enough for `go run ./gateway/cmd/server` on a laptop.
package config

import "os"

type Config struct {
	Port           string
	DatabaseURL    string // empty => gateway falls back to the seed in-memory corpus
	LiteLLMBaseURL string
	LiteLLMAPIKey  string
}

func Load() Config {
	return Config{
		Port:           getenv("PORT", "8080"),
		DatabaseURL:    os.Getenv("DATABASE_URL"),
		LiteLLMBaseURL: getenv("LITELLM_BASE_URL", "http://localhost:4000/v1"),
		LiteLLMAPIKey:  os.Getenv("LITELLM_API_KEY"),
	}
}

func getenv(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}
