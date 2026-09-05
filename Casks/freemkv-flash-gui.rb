# The freemkv-flash desktop app ("Flash").
#
# WHY the quarantine strip (see Casks/freemkv-app.rb for the full rationale):
# the app is signed ad-hoc, not notarized (notarization needs a paid Apple
# Developer account), so macOS refuses a *downloaded* copy that carries
# com.apple.quarantine. Homebrew fetches with curl (which never sets that
# attribute) and this cask strips it after the copy, so the app opens on first
# launch with no "Apple could not verify..." prompt. The trade: trust moves from
# Apple's notary to this tap + a pinned sha256, verified on install, over an
# asset built in public by the freemkv-firmware release workflow. There is no
# .dmg to install by hand: a browser download would be Gatekeeper-blocked, so
# Homebrew is the only macOS path.
#
# NAMED freemkv-flash-gui, distinct from the freemkv-flash formula: a cask and a
# formula of the same name cannot both link, so the CLI (formula) and the app
# (cask) carry different names and coexist -- the same tool delivered two ways.
cask "freemkv-flash-gui" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.7.0"
  sha256 arm:   "aa54e2aae1e52b3569a458d4e550dad8495883755419f6a4ccc7c2c2b4741513",
         intel: "c0e60900a121365cdc19a5348b6b32e641e3793063c59b892787788ba2de43f3"

  url "https://github.com/freemkv/freemkv-firmware/releases/download/v#{version}/freemkv-flash-gui-macos-#{arch}.zip"
  name "freemkv Flash"
  desc "Generic MediaTek/Renesas optical-drive firmware flasher and dumper"
  homepage "https://freemkv.org/firmware/flash/"

  depends_on :macos

  app "freemkv-flash-gui.app"

  # `quarantine false` is not cask DSL; stripping the attribute after the copy is
  # the supported way to make that choice on the user's behalf. Removed once the
  # app is notarized. See Casks/freemkv-app.rb.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/freemkv-flash-gui.app"]
  end

  zap trash: [
    "~/Library/Preferences/org.freemkv.flash-gui.plist",
    "~/Library/Saved Application State/org.freemkv.flash-gui.savedState",
  ]

  # No `binary` stanza for the in-bundle CLI: the freemkv-flash formula already
  # owns that command name. Install it on its own with `brew install
  # freemkv/tap/freemkv-flash`, or run it from inside the bundle.
  caveats <<~EOS
    freemkv Flash is not notarized by Apple. This cask installs it without the
    quarantine attribute so it opens normally; the top of this cask file
    explains what that means for trust.

    The command line is inside the app:
      /Applications/freemkv-flash-gui.app/Contents/MacOS/freemkv-flash-gui --version
    or install the CLI on its own with:
      brew install freemkv/tap/freemkv-flash
  EOS
end
