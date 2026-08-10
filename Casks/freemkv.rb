# The freemkv desktop app.
#
# WHY `quarantine false`:
#
# freemkv is signed ad-hoc, not with an Apple Developer ID, because notarization
# requires a paid Apple Developer Program membership. An ad-hoc signature
# identifies nobody, so macOS refuses anything downloaded that carries the
# com.apple.quarantine attribute -- the "Apple could not verify freemkv is free
# of malware" dialog. On macOS 15 Sequoia the old right-click -> Open bypass is
# gone, and the only remaining route is System Settings > Privacy & Security >
# Open Anyway.
#
# Homebrew normally sets that attribute on cask downloads. Turning it off here
# means the app opens on first launch like any other program.
#
# Be clear about the trade: this moves the trust decision from Apple's notary
# service to this tap and the release it points at. What you get instead of a
# notarization ticket is a pinned sha256, verified on every install, against an
# asset built in public by a GitHub Actions workflow you can read. If you would
# rather have Apple's guarantee, install the .dmg from the releases page and
# allow it once in System Settings -- do not use this cask.
cask "freemkv" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.6.2"
  sha256 arm:   "205d04f9771a43e0ac0686854dbb38da8c891cbc5f0904d9c9d559c60c952a23",
         intel: "bb1c243b744cd590fd62d014ab4415457ee8a90365342c295ff572d062ad1070"

  url "https://github.com/freemkv/freemkv/releases/download/v#{version}/freemkv-v#{version}-#{arch}-apple-darwin.dmg",
      verified: "github.com/freemkv/freemkv/"
  name "freemkv"
  desc "Rip and remux Blu-ray, UHD, DVD and HD DVD discs to MKV"
  homepage "https://freemkv.org"

  # See the note above. Once the app is notarized this line comes out, and
  # nothing else about this cask changes.
  quarantine false

  app "freemkv.app"

  # Deliberately NO `binary` stanza for the CLI inside the bundle. The formula
  # in this tap already installs a `freemkv` executable, and both would own that
  # name -- installing the pair would collide. Anyone who wants the command line
  # should `brew install freemkv`; the caveat below gives the in-bundle path for
  # anyone who would rather not.
  caveats <<~EOS
    freemkv is not notarized by Apple. This cask installs it without the
    quarantine attribute so it opens normally; the top of this cask file
    explains what that means for trust.

    The command line is inside the app:
      /Applications/freemkv.app/Contents/MacOS/freemkv --version
    or install it on its own with:
      brew install freemkv/tap/freemkv

    Decrypting a commercial disc needs a key database or a key service:
      freemkv update-keys
  EOS

  zap trash: [
    "~/Library/Application Support/freemkv",
    "~/Library/Preferences/org.freemkv.gui.plist",
    "~/Library/Saved Application State/org.freemkv.gui.savedState",
  ]
end
