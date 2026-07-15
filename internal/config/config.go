package config

import (
	"fmt"
	"os"
	"strings"
	"time"
)

const (
	defaultHTTPAddress       = ":8080"
	defaultReadHeaderTimeout = 5 * time.Second
	defaultReadTimeout       = 10 * time.Second
	defaultWriteTimeout      = 30 * time.Second
	defaultIdleTimeout       = 60 * time.Second
)

// Config contains the runtime settings for the HTTP service.
type Config struct {
	HTTPAddress       string
	DatabaseURL       string
	ReadHeaderTimeout time.Duration
	ReadTimeout       time.Duration
	WriteTimeout      time.Duration
	IdleTimeout       time.Duration
}

// FromEnv loads configuration from environment variables and applies safe defaults.
func FromEnv() (Config, error) {
	databaseURL := strings.TrimSpace(os.Getenv("DATABASE_URL"))
	if databaseURL == "" {
		return Config{}, fmt.Errorf("DATABASE_URL is required")
	}

	cfg := Config{
		HTTPAddress:       valueOrDefault("HTTP_ADDRESS", defaultHTTPAddress),
		DatabaseURL:       databaseURL,
		ReadHeaderTimeout: defaultReadHeaderTimeout,
		ReadTimeout:       defaultReadTimeout,
		WriteTimeout:      defaultWriteTimeout,
		IdleTimeout:       defaultIdleTimeout,
	}

	durations := []struct {
		name   string
		target *time.Duration
	}{
		{name: "HTTP_READ_HEADER_TIMEOUT", target: &cfg.ReadHeaderTimeout},
		{name: "HTTP_READ_TIMEOUT", target: &cfg.ReadTimeout},
		{name: "HTTP_WRITE_TIMEOUT", target: &cfg.WriteTimeout},
		{name: "HTTP_IDLE_TIMEOUT", target: &cfg.IdleTimeout},
	}

	for _, duration := range durations {
		value := os.Getenv(duration.name)
		if value == "" {
			continue
		}

		parsed, err := time.ParseDuration(value)
		if err != nil || parsed <= 0 {
			return Config{}, fmt.Errorf("%s must be a positive duration: %q", duration.name, value)
		}
		*duration.target = parsed
	}

	return cfg, nil
}

func valueOrDefault(name, defaultValue string) string {
	if value := os.Getenv(name); value != "" {
		return value
	}
	return defaultValue
}
