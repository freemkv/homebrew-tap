# The freemkv desktop app. Its executable is also the full CLI, exposed as the
# `freemkv` command; the freemkv-cli formula installs the same command without
# the app, so the two are mutually exclusive.
#
# Quarantine: freemkv is not notarized, so macOS refuses a quarantined copy and
# Sequoia offers no right-click bypass. The postflight strips the attribute so
# the app opens normally. That moves trust from Apple's notary to this tap: a
# pinned sha256 of an asset built by a public workflow. If you want Apple's
# guarantee, install the .dmg from the releases page instead.
cask "freemkv" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.7.7"
  sha256 arm:   "613c10dccfe22e1894d917749a1c37ecb6b4b469993121d26651b07583a5e0f8",
         intel: "bc9e8cbb2559e893137cd5a4526add5d9a93b77e959e50058376ea4851b06453"

  url "https://github.com/freemkv/freemkv/releases/download/v#{version}/freemkv-#{arch}-macos.dmg"
  name "freemkv"
  desc "Rip and remux Blu-ray, UHD, DVD and HD DVD discs to MKV"
  homepage "https://freemkv.org/"

  conflicts_with formula: "freemkv-cli"
  depends_on :macos

  app "freemkv.app"
  binary "#{appdir}/freemkv.app/Contents/MacOS/freemkv"

  # `quarantine false` is not cask DSL; stripping the attribute after the copy
  # is the supported way. Remove once the app is notarized.
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
    freemkv is not notarized; this cask removes the quarantine attribute so it
    opens normally. See the top of the cask file for what that means.

    The `freemkv` command is the full CLI. For the CLI without the app:
      brew uninstall --cask freemkv && brew install freemkv/tap/freemkv-cli

    Decrypting a commercial disc needs a key database or a key service:
      freemkv update-keys
  EOS
end
