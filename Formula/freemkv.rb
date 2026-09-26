# The freemkv command-line ripper.
#
# Homebrew downloads with curl, and curl does not set the com.apple.quarantine
# attribute -- only browsers do. So this install is not subject to the Gatekeeper
# prompt a downloaded binary gets, and works whether or not the binary is
# notarized. That is why this formula exists: it is the friction-free way to get
# the CLI on a Mac.
class Freemkv < Formula
  desc "Rip and remux Blu-ray, UHD, DVD and HD DVD discs to MKV"
  homepage "https://freemkv.org"
  license "MIT"
  # No explicit `version`: Homebrew scans it from the URL, so bumping the URLs
  # bumps the version and the two can never disagree. `brew audit` flags a
  # standalone version here as redundant, and it is.

  on_macos do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.6/freemkv-aarch64-macos-v1.7.6"
      sha256 "b4b30bc0dd23f3d228ec272e2b71656e1211992ce9d56e47b383bae19e7a93a7"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.6/freemkv-x86_64-macos-v1.7.6"
      sha256 "48e195acc3ba4613face1d56a90cb65d0471bbaa36159daeb74eb5c2d09e82b8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.6/freemkv-aarch64-linux-v1.7.6"
      sha256 "8581868dcbba603e67ee6ae2d6a1f3b2097e7f5bf95a958b2f0d1cbb5aea6c4c"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.6/freemkv-x86_64-linux-v1.7.6"
      sha256 "851686970b87ffa4bc9afb02010eed931c6536bce6b27e8fae5d8f070982ad9e"
    end
  end

  def install
    # The release asset is the bare executable under a versioned name; install
    # it as plain `freemkv`.
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
