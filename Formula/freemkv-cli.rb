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
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.9/freemkv-cli-aarch64-macos"
      sha256 "7b976e2fcb22393e75fe452ae5f0876fd8e28ef92a72776121f1c4b9af55ca9c"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.9/freemkv-cli-x86_64-macos"
      sha256 "bde84fb9199b2b9c97be1421768e20aa5e307952d64a101c56efda1383b2f3e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.9/freemkv-cli-aarch64-linux"
      sha256 "e114ae16423c9f7582b0f881cb1db460f8a60596670ebf7dea2ddddb7894fa1f"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.9/freemkv-cli-x86_64-linux"
      sha256 "f099765720bd15aa5c4c0062d318cc724cce36c766f64e407819de416153050f"
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
