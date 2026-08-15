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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.4/freemkv-aarch64-macos-v1.6.4"
      sha256 "2fd6838321484ed42f9f6b6b3042d5440a74ee76e18d273a30ecab8d84216d1c"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.4/freemkv-x86_64-macos-v1.6.4"
      sha256 "ad4fbe96bc6db0d23c8e2ad0fac652fd48bba5818e0ff3f7fc131e5156865513"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.4/freemkv-aarch64-linux-v1.6.4"
      sha256 "2778f6cfbff4601b1d78adccf677969d50765fedc823376798aeaedcf8cd7793"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.4/freemkv-x86_64-linux-v1.6.4"
      sha256 "c7488b3c45d967e3103053ba34c36af9e29e5653df11bf4041025a98b56f6945"
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
