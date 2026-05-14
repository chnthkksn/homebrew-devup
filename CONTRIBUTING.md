# Contributing

## Setup

1. Install Go 1.25+.
2. Install dependencies:
   - `mutagen`
   - `ssh` client
3. Build:

```bash
go build -o devup ./cmd/devup
```

## Before opening a PR

Run:

```bash
go test ./...
```

Keep changes focused and include tests for parser/argument behavior changes.

