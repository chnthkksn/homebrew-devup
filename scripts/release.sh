#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/release.sh <version>

Examples:
  scripts/release.sh v0.2.0
  scripts/release.sh 0.2.0

What it does:
  1) Validates dependencies (git, go, gh)
  2) Ensures you are on a clean git worktree
  3) Runs tests (go test ./...)
  4) Creates an annotated git tag
  5) Pushes the tag to origin
  6) Creates a GitHub release from the tag
EOF
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

VERSION="$1"
if [[ "${VERSION}" != v* ]]; then
  VERSION="v${VERSION}"
fi

if ! [[ "${VERSION}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+([-.][0-9A-Za-z.]+)?$ ]]; then
  echo "[ERROR] Version must look like vX.Y.Z (optionally with suffix)." >&2
  exit 1
fi

for cmd in git go gh; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "[ERROR] Missing dependency: ${cmd}" >&2
    exit 1
  fi
done

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "[ERROR] Must run inside a git repository." >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "[ERROR] Working tree is not clean. Commit or stash changes first." >&2
  exit 1
fi

if git rev-parse "${VERSION}" >/dev/null 2>&1; then
  echo "[ERROR] Tag ${VERSION} already exists locally." >&2
  exit 1
fi

if git ls-remote --tags origin "refs/tags/${VERSION}" | grep -q "${VERSION}$"; then
  echo "[ERROR] Tag ${VERSION} already exists on origin." >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "[ERROR] GitHub CLI is not authenticated. Run: gh auth login" >&2
  exit 1
fi

echo "[INFO] Running tests"
go test ./...

echo "[INFO] Creating tag ${VERSION}"
git tag -a "${VERSION}" -m "Release ${VERSION}"

echo "[INFO] Pushing tag ${VERSION} to origin"
git push origin "${VERSION}"

echo "[INFO] Creating GitHub release ${VERSION}"
gh release create "${VERSION}" \
  --verify-tag \
  --generate-notes \
  --latest

echo "[INFO] Release ${VERSION} created successfully"
