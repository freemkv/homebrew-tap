# The freemkv-fw desktop app ("Modify").
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
# NAMED freemkv-fw-gui, distinct from the freemkv-fw formula: the cask is
# the app plus its CLI, the formula is the CLI alone (like freemkv / freemkv-cli).
cask "freemkv-fw-gui" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.10.5"
  sha256 arm:   "766af068869acca4f3474713975e45e058187d2ce3ac34989da3932cef8cecc5",
         intel: "2e25a0db6f51132e818048f77193b018e34bd5e832126e3bfe2368f9436698bd"

  url "https://github.com/freemkv/freemkv-firmware/releases/download/v#{version}/freemkv-fw-gui-macos-#{arch}.zip"
  name "freemkv Modify"
  desc "Modify MediaTek MT19xx optical-drive firmware (create/verify images)"
  homepage "https://freemkv.org/firmware/modify/"

  depends_on :macos

  app "freemkv-fw-gui.app"
  # The app bundles its CLI, as the freemkv cask does; it and the freemkv-fw
  # formula both provide `freemkv-fw`, so install one or the other.
  binary "#{appdir}/freemkv-fw-gui.app/Contents/MacOS/freemkv-fw"

  # `quarantine false` is not cask DSL; stripping the attribute after the copy is
  # the supported way to make that choice on the user's behalf. Removed once the
  # app is notarized. See Casks/freemkv.rb.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/freemkv-fw-gui.app"]
  end

  zap trash: [
    "~/Library/Preferences/org.freemkv.fw-gui.plist",
    "~/Library/Saved Application State/org.freemkv.fw-gui.savedState",
  ]

  caveats <<~EOS
    freemkv Modify is not notarized by Apple. This cask installs it without the
    quarantine attribute so it opens normally; the top of this cask file
    explains what that means for trust.

    The app also puts the freemkv-fw command on your PATH. It replaces the
    freemkv-fw formula, so uninstall one before installing the other.
  EOS
end
