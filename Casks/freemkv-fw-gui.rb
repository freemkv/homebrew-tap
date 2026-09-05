# The freemkv-fw desktop app ("Modify").
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
# NAMED freemkv-fw-gui, distinct from the freemkv-fw formula: a cask and a
# formula of the same name cannot both link, so the CLI (formula) and the app
# (cask) carry different names and coexist -- the same tool delivered two ways.
cask "freemkv-fw-gui" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.7.0"
  sha256 arm:   "9575dd90c338c9e8f0a977a01f07b89b44bba74e0bbad10aa532f19dcb049ac4",
         intel: "bf4d92097eeecf522cbb18b657532c78f6c0830985c2d140ebefb0c398f4db00"

  url "https://github.com/freemkv/freemkv-firmware/releases/download/v#{version}/freemkv-fw-gui-macos-#{arch}.zip"
  name "freemkv Modify"
  desc "Modify MediaTek MT19xx optical-drive firmware (create/verify images)"
  homepage "https://freemkv.org/firmware/modify/"

  depends_on :macos

  app "freemkv-fw-gui.app"

  # `quarantine false` is not cask DSL; stripping the attribute after the copy is
  # the supported way to make that choice on the user's behalf. Removed once the
  # app is notarized. See Casks/freemkv-app.rb.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/freemkv-fw-gui.app"]
  end

  zap trash: [
    "~/Library/Preferences/org.freemkv.fw-gui.plist",
    "~/Library/Saved Application State/org.freemkv.fw-gui.savedState",
  ]

  # No `binary` stanza for the in-bundle CLI: the freemkv-fw formula already owns
  # that command name. Install it on its own with `brew install
  # freemkv/tap/freemkv-fw`, or run it from inside the bundle.
  caveats <<~EOS
    freemkv Modify is not notarized by Apple. This cask installs it without the
    quarantine attribute so it opens normally; the top of this cask file
    explains what that means for trust.

    The command line is inside the app:
      /Applications/freemkv-fw-gui.app/Contents/MacOS/freemkv-fw-gui --version
    or install the CLI on its own with:
      brew install freemkv/tap/freemkv-fw
  EOS
end
