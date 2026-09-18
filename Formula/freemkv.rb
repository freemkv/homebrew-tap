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
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.2/freemkv-aarch64-macos-v1.7.2"
      sha256 "fe994c3fca832aaf6b0ced8f22e0bdeed255088b052deeae3ef5b30a033620e0"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.2/freemkv-x86_64-macos-v1.7.2"
      sha256 "c89e6f034cf9d78eefd4c8dca4f7b9405724229d93a16459844089f4d38d49c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.2/freemkv-aarch64-linux-v1.7.2"
      sha256 "39e3cea4ffe4f47af75fbbdc7bc016a234c6f48ef3b477bcf2a52c0f3ecb4fb1"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.2/freemkv-x86_64-linux-v1.7.2"
      sha256 "10cc60568e385f457200f268047f23833cb6dcd1f9cddfd342ab91bab2652859"
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
