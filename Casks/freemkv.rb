# The freemkv desktop app, which also provides the `freemkv` command.
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
# rather have Apple's guarantee, there is none to be had yet: no freemkv asset
# is notarized, and a browser download of the .zip is refused the same way.
#
# WHY the .zip and not a .dmg: the release .dmg was never signed or notarized
# either (codesign: "not signed"), so it bought nothing over the zip, and
# freemkv is dropping it. The zip carries the ad-hoc-signed freemkv.app as-is.
#
# NAMING. This cask was `freemkv-app` and the CLI formula was `freemkv`, because
# Homebrew skips linking whichever of a same-named cask/formula pair comes
# second, and installing both was the documented path. As of 1.8.0 the cask
# itself links the `freemkv` command, so installing both is no longer needed or
# recommended: the cask is now `freemkv` and the bare-binary formula is
# `freemkv-cli` -- install one or the other. cask_renames.json and
# formula_renames.json at the root of this tap carry existing installs across.
#
# There is no `conflicts_with` for this: a cask can only conflict with other
# casks. If both are installed anyway, whichever is second leaves the other's
# `freemkv` link in place (the cask warns "from formula freemkv-cli; skipping
# link", the formula reports `brew link` did not complete) -- one `freemkv` on
# PATH either way, and it is the same program.
cask "freemkv" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.8.0"
  sha256 arm:   "f4d530a4bf5a3f4f3131821928a5e988fbf69f2ec98de74c0b42ad99fc9690ed",
         intel: "7781236952543c92b6ae94c52fa30a1f5bd9da150e34a402819ed88fa7386373"

  url "https://github.com/freemkv/freemkv/releases/download/v#{version}/freemkv-#{arch}-macos.zip"
  name "freemkv"
  desc "Rip and remux Blu-ray, UHD, DVD and HD DVD discs to MKV"
  homepage "https://freemkv.org/"

  depends_on :macos

  app "freemkv.app"
  # The app's own executable is the full CLI when given arguments (`--help`,
  # `info`, `<source> <dest>` ...), so link it as `freemkv`.
  binary "#{appdir}/freemkv.app/Contents/MacOS/freemkv"

  # See the note at the top of this file. `quarantine false` is NOT cask DSL --
  # Homebrew rejects it outright ("undefined method 'quarantine'"), because
  # disabling the attribute is a decision it leaves to the person installing,
  # via `--no-quarantine`. Stripping it after the copy is the supported way for
  # a cask to make that choice on the user's behalf, and it is what lets the app
  # open on first launch instead of being refused.
  #
  # Once the app is notarized this block comes out and nothing else changes.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/freemkv.app"]
  end

  zap trash: [
    "~/Library/Application Support/freemkv",
    "~/Library/Preferences/org.freemkv.gui.plist",
    "~/Library/Saved Application State/org.freemkv.gui.savedState",
  ]

  caveats <<~EOS
    freemkv is not notarized by Apple. This cask installs it without the
    quarantine attribute so it opens normally; the top of this cask file
    explains what that means for trust.

    This cask also links the `freemkv` command. You do not need the
    freemkv-cli formula as well -- that is the same command without the app.

    Decrypting a commercial disc needs a key database or a key service:
      freemkv update-keys
  EOS
end
