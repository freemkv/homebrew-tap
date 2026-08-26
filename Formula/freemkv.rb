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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.11/freemkv-aarch64-macos-v1.6.11"
      sha256 "ce84a0aef8d4591241e7bd6740a5a537733caeff0357d90c6ea9384a5cff178d"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.11/freemkv-x86_64-macos-v1.6.11"
      sha256 "8823bbe5fd6757ab2437658d17e915bf51425c198605b8cb569b023f9bd0ed6c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.11/freemkv-aarch64-linux-v1.6.11"
      sha256 "4d40044378485639ca83a75aca17562f2aad44270d81d48dbbc2a654be22a6ac"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.11/freemkv-x86_64-linux-v1.6.11"
      sha256 "3d85f8acf5001079a047ef964a993ae8ec602e2bb47d15fd17941856ee398593"
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
