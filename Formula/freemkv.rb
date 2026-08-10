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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.3/freemkv-aarch64-macos-v1.6.3"
      sha256 "ee0c2071a56588eb397462ddb769a49d213e2ef0acf8a569a0aa274e81a41f99"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.3/freemkv-x86_64-macos-v1.6.3"
      sha256 "c4dadd0c1aafc6c868156285f6b9c8dfb1b057c6748c88e7acfe6597240dcc3a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.3/freemkv-aarch64-linux-v1.6.3"
      sha256 "43ca6b571bcd06d68a92380510f19ae840e4e504ff2ddc5e472a348554ca2451"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.3/freemkv-x86_64-linux-v1.6.3"
      sha256 "fd5bd784e1057c3ce2c4a0f572373b99b8cb09f3ed3b60b973e075094dae5fe1"
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
