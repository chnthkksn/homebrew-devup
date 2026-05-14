# Homebrew Tap Release Guide

This guide publishes `devup` via a custom tap.

## 1. Create tap repository

Create GitHub repo:

- `homebrew-devup`

Then clone it locally and add formula path:

```bash
mkdir -p Formula
```

## 2. Tag and push a release in `devup`

From this repository:

```bash
git tag v0.1.0
git push origin v0.1.0
```

## 3. Compute source tarball SHA256

```bash
curl -L -o devup-v0.1.0.tar.gz \
  https://github.com/REPLACE_OWNER/devup/archive/refs/tags/v0.1.0.tar.gz
shasum -a 256 devup-v0.1.0.tar.gz
```

Copy the hash value.

## 4. Add formula to tap repo

Use template from:

- `Formula/devup.rb`

Replace:

- `REPLACE_OWNER`
- `REPLACE_SHA256`

Commit and push in tap repo.

## 5. Validate formula

```bash
brew tap REPLACE_OWNER/devup
brew install devup
brew test devup
```

## 6. User install command

```bash
brew tap REPLACE_OWNER/devup
brew install devup
```
