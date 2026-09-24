// Package db wires up the shared Postgres connection pool used by
// /gateway and /corpus/cmd/extract (for the "load" step). Kept tiny on
// purpose: no ORM, callers write their own SQL via pgx.
package db

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

// Open reads DATABASE_URL from the environment and returns a ready pool.
// Callers are responsible for pool.Close().
func Open(ctx context.Context) (*pgxpool.Pool, error) {
	url := os.Getenv("DATABASE_URL")
	if url == "" {
		return nil, fmt.Errorf("db: DATABASE_URL not set (see infra/docker-compose.yml)")
	}
	pool, err := pgxpool.New(ctx, url)
	if err != nil {
		return nil, fmt.Errorf("db: connect: %w", err)
	}
	if err := pool.Ping(ctx); err != nil {
		pool.Close()
		return nil, fmt.Errorf("db: ping: %w", err)
	}
	return pool, nil
}
