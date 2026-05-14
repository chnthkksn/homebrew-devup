# devup

Local-first remote development CLI for VPS workflows.

`devup` creates an ephemeral Mutagen sync, opens SSH port forwards, optionally runs a remote command, and cleans everything up on exit/CTRL+C.

## Features

- Ephemeral Mutagen sync session
- Repeatable `-p/--port` mappings (`3000` or `3000:3001`)
- Optional local path override via `-l/--local`
- Optional remote command via `--cmd`
- Remote target directory auto-create (`mkdir -p`)
- Interactive shell starts in the target remote directory
- Automatic cleanup of Mutagen session on exit or interruption
- Startup dependency checks for `ssh` and `mutagen`

## Requirements

- Go 1.25+
- Mutagen
- OpenSSH client

Install Mutagen:

```bash
brew install mutagen-io/mutagen/mutagen
```

or:

```bash
sudo apt install mutagen openssh-client
```

## Build

```bash
make build
```

## Install (system-wide)

```bash
sudo make install
```

By default this installs to `/usr/local/bin/devup`.

To use a different prefix:

```bash
sudo make install PREFIX=/opt/devup
```

## Uninstall

```bash
sudo make uninstall
```

## Homebrew Tap

Use the tap release guide in [docs/homebrew-tap.md](./docs/homebrew-tap.md).
Formula template is in [Formula/devup.rb](./Formula/devup.rb).

Install via Homebrew tap:

```bash
brew tap mutagen-io/mutagen
brew tap chnthkksn/devup
brew install devup
```

Uninstall:

```bash
brew uninstall devup
brew untap chnthkksn/devup
```

## Usage

```text
devup [user@]host:/remote/path [flags]
```

Flags:

- `-p, --port` Port mapping (repeatable)
- `-l, --local` Local folder override (default: current directory)
- `--cmd` Remote startup command

Examples:

```bash
# Same local/remote port
./devup ubuntu@host:/apps/api -p 3000

# Different local:remote port
./devup ubuntu@host:/apps/api -p 3000:3001

# Multiple ports
./devup ubuntu@host:/apps/api -p 3000 -p 5173:5173 -p 27017

# Local path override
./devup ubuntu@host:/apps/api -l ~/projects/api -p 3000

# Run remote command in remote path
./devup ubuntu@host:/apps/api -p 3000 --cmd "docker compose up"
```

## Development

Run tests:

```bash
make test
```

## License

MIT. See [LICENSE](./LICENSE).
