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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.8/freemkv-aarch64-macos-v1.6.8"
      sha256 "9e85460feda1462ec5719fecb1d4b0e83694eb162d3a8f9a7266cdd67cf72dde"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.8/freemkv-x86_64-macos-v1.6.8"
      sha256 "b08e733856a15a690244beb09fad12eb682f54b29ea53295c56c29c5bd83fac7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.8/freemkv-aarch64-linux-v1.6.8"
      sha256 "4e5150beb6e955f9b26ee9a7126581f95fdd8cb061fa0705a4dbd0de01001880"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.8/freemkv-x86_64-linux-v1.6.8"
      sha256 "9845fa56545a7edeac501effd121329056a8be9ae3e1b19f43938b2f1c4e934e"
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
