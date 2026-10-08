# The freemkv command-line ripper, without the desktop app.
#
# Homebrew downloads with curl, and curl does not set the com.apple.quarantine
# attribute -- only browsers do. So this install is not subject to the Gatekeeper
# prompt a downloaded binary gets, and works whether or not the binary is
# notarized. That is why this formula exists: it is the friction-free way to get
# the CLI on a Mac, and the way to get it on Linux.
#
# Was `freemkv` before 1.8.0; formula_renames.json carries existing installs
# across. The `freemkv` cask now links the same command from inside the app, so
# install one or the other (see the naming note in Casks/freemkv.rb).
class FreemkvCli < Formula
  desc "Rip and remux Blu-ray, UHD, DVD and HD DVD discs to MKV"
  homepage "https://freemkv.org"
  license "MIT"
  # No explicit `version`: Homebrew scans it from the URL -- from the v1.8.0
  # release-tag path segment, now that the asset names themselves are
  # unversioned -- so bumping the URLs bumps the version and the two can never
  # disagree. `brew audit` flags a standalone version here as redundant.

  on_macos do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.2/freemkv-cli-aarch64-macos"
      sha256 "602cf123203b09fe18392d831a656d70a01b3b728de1750f25b2ff5ff6cacf76"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.2/freemkv-cli-x86_64-macos"
      sha256 "0ab06ea5345e0c3e734d081c9ba2b76ad50efd932db986fe39e2cdb7fe613cbb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.2/freemkv-cli-aarch64-linux"
      sha256 "8311b13bb170e377f6a7a5123426dcc9aea1c88861905717f155b8a81beae8de"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.2/freemkv-cli-x86_64-linux"
      sha256 "285d9bc407c5a5b90870570d867423e3b4ed62f87eb97c05392f88a685789eb8"
    end
  end

  def install
    # The release asset is the bare executable under a per-platform name;
    # install it as plain `freemkv`.
    bin.install Dir["*"].first => "freemkv"
  end

  def caveats
    <<~EOS
      Decrypting a commercial disc needs a key database (keydb.cfg) or a key
      service. Neither ships with freemkv:

        freemkv update-keys

      Reading a disc also needs a drive freemkv can address directly; it
      unmounts the disc first to take exclusive access.
    EOS
  end

  test do
    # `--version` prints "<version> (<commit>)", so match the leading version
    # rather than the whole line.
    assert_match version.to_s, shell_output("#{bin}/freemkv --version")
  end
end
