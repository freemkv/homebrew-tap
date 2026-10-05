# The freemkv-flash desktop app ("Flash").
#
# WHY the quarantine strip (see Casks/freemkv.rb for the full rationale):
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
# NAMED freemkv-flash-gui, distinct from the freemkv-flash formula: the cask is
# the app plus its CLI, the formula is the CLI alone (like freemkv / freemkv-cli).
cask "freemkv-flash-gui" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.10.5"
  sha256 arm:   "c4caa6f9aeb7a361df8424e76e635436fac2ef3ee72486c3789d93ee9c490438",
         intel: "f2ea2f64b42b980df307ce3f4ebe532adfff362d3f7c318a6267e18113a528b0"

  url "https://github.com/freemkv/freemkv-firmware/releases/download/v#{version}/freemkv-flash-gui-macos-#{arch}.zip"
  name "freemkv Flash"
  desc "Generic MediaTek/Renesas optical-drive firmware flasher and dumper"
  homepage "https://freemkv.org/firmware/flash/"

  depends_on :macos

  app "freemkv-flash-gui.app"
  # The app bundles its CLI, as the freemkv cask does; it and the freemkv-flash
  # formula both provide `freemkv-flash`, so install one or the other.
  binary "#{appdir}/freemkv-flash-gui.app/Contents/MacOS/freemkv-flash"

  # `quarantine false` is not cask DSL; stripping the attribute after the copy is
  # the supported way to make that choice on the user's behalf. Removed once the
  # app is notarized. See Casks/freemkv.rb.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/freemkv-flash-gui.app"]
  end

  zap trash: [
    "~/Library/Preferences/org.freemkv.flash-gui.plist",
    "~/Library/Saved Application State/org.freemkv.flash-gui.savedState",
  ]

  caveats <<~EOS
    freemkv Flash is not notarized by Apple. This cask installs it without the
    quarantine attribute so it opens normally; the top of this cask file
    explains what that means for trust.

    The app also puts the freemkv-flash command on your PATH. It replaces the
    freemkv-flash formula, so uninstall one before installing the other.
  EOS
end
