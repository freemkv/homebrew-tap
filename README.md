# freemkv Homebrew tap

Install [freemkv](https://freemkv.org) — rip and remux Blu-ray, UHD, DVD and
HD DVD discs to MKV.

## Desktop app (macOS)

```sh
brew install --cask freemkv/tap/freemkv
```

Installs `freemkv.app` and the `freemkv` command (the full CLI).

## Command line only

```sh
brew install freemkv/tap/freemkv-cli
freemkv --version
```

macOS, Linux, Apple Silicon and Intel. Installs the same `freemkv` command
without the app.

The two conflict: install one or the other. Existing `freemkv` (formula) and
`freemkv-app` (cask) installs are migrated to `freemkv-cli` and `freemkv` by
`brew update`; if you had both, uninstall one before upgrading.

## autorip

The unattended ripping daemon:

```sh
brew install freemkv/tap/autorip
```

## Firmware tools

`freemkv-flash` (flash/dump drive firmware) and `freemkv-fw` (build/modify
firmware images) — two tools, each shipping a CLI (formula) and a macOS desktop
app (cask):

```sh
# flash — CLI + app
brew install freemkv/tap/freemkv-flash
brew install --cask freemkv/tap/freemkv-flash-gui

# modify — CLI + app
brew install freemkv/tap/freemkv-fw
brew install --cask freemkv/tap/freemkv-fw-gui
```

## Why install this way

A binary downloaded in a browser gets macOS's `com.apple.quarantine`
attribute, and freemkv is not notarized by Apple — so the download is refused
with *"Apple could not verify freemkv is free of malware"*. On macOS 15 Sequoia
the old right-click → **Open** bypass no longer exists; the only route is
System Settings → Privacy & Security → **Open Anyway**, per download.

Homebrew fetches with `curl`, which never sets that attribute, so the formula
installs and runs with nothing to click through. The cask strips the attribute
after install for the same reason.

That is a real trade, not a trick: it moves the trust decision from Apple's
notary service to this tap. What you get instead of a notarization ticket is a
`sha256` pinned in this repository and verified on every install, against
release assets built in public by a workflow you can read. If you would rather
have Apple's guarantee, download the `.dmg` from the
[releases page](https://github.com/freemkv/freemkv/releases) and allow it once
in System Settings.

## Keys

freemkv ships no key database. Decrypting a commercial disc needs one, or a key
service:

```sh
freemkv update-keys
```

## Updating

This tap is updated automatically by the freemkv release workflow — the version
and checksums here are written when a release is published, not by hand.
