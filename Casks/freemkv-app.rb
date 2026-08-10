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
# NAMED freemkv-app, NOT freemkv, and that matters.
#
# Homebrew refuses to symlink a formula when a cask of the same name is
# installed — it says so and moves on: "freemkv cask is installed, skipping
# link." So with both named `freemkv`, installing the app and then the CLI left
# `brew install` reporting success and no `freemkv` command on PATH at all.
# The docs recommend installing both, so that was the normal path, not an edge
# case. Distinct names let the two coexist, which is the whole point: they are
# the same program delivered two ways.
cask "freemkv-app" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.6.3"
  sha256 arm:   "68a23292e73185a5cd445e994c9dfbe7c1cbe8dc4edfcd6a2243b135e3d1e130",
         intel: "bbf8628ebbe42c39ccceee0c715ad7fb444945ea4c3920bb7eefc6dff0794a82"

  url "https://github.com/freemkv/freemkv/releases/download/v#{version}/freemkv-v#{version}-#{arch}-apple-darwin.dmg",
      verified: "github.com/freemkv/freemkv/"
  name "freemkv"
  desc "Rip and remux Blu-ray, UHD, DVD and HD DVD discs to MKV"
  homepage "https://freemkv.org"

  app "freemkv.app"

  # See the note at the top of this file. `quarantine false` is NOT cask DSL --
  # Homebrew rejects it outright ("undefined method 'quarantine'"), because
  # disabling the attribute is a decision it leaves to the person installing,
  # via `--no-quarantine`. Stripping it after the copy is the supported way for
  # a cask to make that choice on the user's behalf, and it is what lets the app
  # open on first launch instead of being refused.
  #
  # Once the app is notarized this block comes out and nothing else changes.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/freemkv.app"],
                   sudo: false
  end

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
