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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.9/freemkv-aarch64-macos-v1.6.9"
      sha256 "0b8debc93e2aa26bb39e101cc87e984c3de0910a2bb98553e51b082390a70fa2"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.9/freemkv-x86_64-macos-v1.6.9"
      sha256 "4d918abcb9822ed19f78d58e0654b557375938af550d78f968a6666ee950e6c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.9/freemkv-aarch64-linux-v1.6.9"
      sha256 "203409e01363d7b8f137a6fa9852efbe16988af4600704f910cd6b5bf2999287"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.9/freemkv-x86_64-linux-v1.6.9"
      sha256 "c7d53e63f07fbc748c139302fa5de7bd682ac04c794d7503eec7aea2c0989b12"
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
