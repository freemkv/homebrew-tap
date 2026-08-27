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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.12/freemkv-aarch64-macos-v1.6.12"
      sha256 "b6531b3edad0ac24776e93e8d7adf02d3a3a25f8d906f7ba38699468ec88a16f"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.12/freemkv-x86_64-macos-v1.6.12"
      sha256 "f9528bdaaeb5c184c0024c9b5ba39466d326980e53d4b0fe5537220081bcf0cf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.12/freemkv-aarch64-linux-v1.6.12"
      sha256 "cf4725b1545198bef7d2817ba703db4548edafc18dbe8a2e95f277ab681fe09a"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.12/freemkv-x86_64-linux-v1.6.12"
      sha256 "2a0878890fe5b652de7e3d0501c3f23194b87f50ed99fc08d288093ae3b8b1f4"
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
