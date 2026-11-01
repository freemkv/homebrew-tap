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
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.8/freemkv-cli-aarch64-macos"
      sha256 "b84d8ba0898f1d40c22003f9a49d207331dd5f5b942398e90e28c58500f00978"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.8/freemkv-cli-x86_64-macos"
      sha256 "43b0c13ef4a17101139bd19abfc173f6b8aff0f0a56c7b48c329fbe6df12f5cf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.8/freemkv-cli-aarch64-linux"
      sha256 "72b5eed785b7f49d75e9d9480442f2d2dd52de99d6e9116ef6a4fd128a8e1665"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.8/freemkv-cli-x86_64-linux"
      sha256 "09c7f3a4b4602e7ded8eaca4eb2a2b55d4d3181862e022759085e67f904c2253"
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
