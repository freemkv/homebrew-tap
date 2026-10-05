# freemkv Homebrew tap

Install [freemkv](https://freemkv.org) — rip and remux Blu-ray, UHD, DVD and
HD DVD discs to MKV.

## Desktop app + command line (macOS)

```sh
brew install --cask freemkv/tap/freemkv
freemkv --version
```

Installs freemkv.app and links the `freemkv` command from inside it.

## Command line only

```sh
brew install freemkv/tap/freemkv-cli
freemkv --version
```

macOS, Linux, Apple Silicon and Intel. Same `freemkv` command, no app. Install
one or the other, not both.

Renamed in 1.8.0: the cask was `freemkv-app` and the CLI formula was `freemkv`.
Existing installs follow the rename on the next `brew update` / `brew upgrade`.

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
installs and runs with nothing to click through. The cask sets
`quarantine false` for the same reason.

That is a real trade, not a trick: it moves the trust decision from Apple's
notary service to this tap. What you get instead of a notarization ticket is a
`sha256` pinned in this repository and verified on every install, against
release assets built in public by a workflow you can read. If you would rather
have Apple's guarantee, there is none to be had yet: no freemkv download is
notarized, and a copy from the
[releases page](https://github.com/freemkv/freemkv/releases) has to be allowed
once in System Settings.

## Keys

freemkv ships no key database. Decrypting a commercial disc needs one, or a key
service:

```sh
freemkv update-keys
```

## Updating

This tap is updated automatically by the freemkv and freemkv-firmware release
workflows (`update.sh`) — the versions and checksums here are written when a
release is published, not by hand.
