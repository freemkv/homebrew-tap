# freemkv Homebrew tap

Install [freemkv](https://freemkv.org), which rips and remuxes Blu-ray, UHD,
DVD and HD DVD discs to MKV.

## Desktop app and command line (macOS)

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

Works on macOS and Linux, on Apple Silicon and Intel. It is the same `freemkv`
command without the app. Install one or the other, not both.

Renamed in 1.8.0: the cask was `freemkv-app` and the CLI formula was `freemkv`.
Existing installs follow the rename on the next `brew update` and `brew upgrade`.

## Firmware tools

`freemkv-flash` flashes and dumps drive firmware. `freemkv-fw` builds and
modifies firmware images. Each has a CLI (formula) and a macOS desktop app
(cask):

```sh
# flash: CLI and app
brew install freemkv/tap/freemkv-flash
brew install --cask freemkv/tap/freemkv-flash-gui

# modify: CLI and app
brew install freemkv/tap/freemkv-fw
brew install --cask freemkv/tap/freemkv-fw-gui
```

## Server

autorip has been replaced by the `freemkv-library` Docker image, and its
formula is disabled. See the [library docs](https://freemkv.org/docs/library/).

## Why install this way

A binary downloaded in a browser gets the `com.apple.quarantine` attribute, and
freemkv is not notarized by Apple, so macOS refuses it with "Apple could not
verify freemkv is free of malware". On macOS 15 Sequoia the old right-click and
Open bypass is gone. The only route is System Settings, Privacy & Security,
**Open Anyway**, once per download.

Homebrew fetches with `curl`, which never sets that attribute, so the formulas
install and run with nothing to click through. The cask sets `quarantine false`
for the same reason.

This moves the trust decision from Apple's notary service to this tap. In
return you get a `sha256` pinned in this repository and checked on every
install, against release assets built in public by a workflow you can read. No
freemkv download is notarized yet. A copy from the
[releases page](https://github.com/freemkv/freemkv/releases) has to be allowed
once in System Settings.

## Keys

freemkv ships no key database. Decrypting a Blu-ray or UHD disc needs a
`keydb.cfg`:

```sh
freemkv update-keys --url <keydb-url>
```

## Updating

The freemkv and freemkv-firmware release workflows update this tap
automatically through `update.sh`. Versions and checksums are written when a
release is published, not by hand.
