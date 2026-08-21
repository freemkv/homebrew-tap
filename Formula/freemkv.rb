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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.6/freemkv-aarch64-macos-v1.6.6"
      sha256 "53b7ebaafb9b61af5dd2904552f6991989490ba5237c9893a458bd380ca36c36"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.6/freemkv-x86_64-macos-v1.6.6"
      sha256 "dbbd1a4bf5ea455cf04459541fdf1d47cb05ab82b8e6c2f3aaca875e94ad7837"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.6/freemkv-aarch64-linux-v1.6.6"
      sha256 "dd96a57f2d2ffb419ba83431556cb628ebb40bd359cb583714e2032ea540165a"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.6/freemkv-x86_64-linux-v1.6.6"
      sha256 "36b7bec565650e81ae77fae68f06a337ad2cfa8fbec384f4a38f7970ab2e02c6"
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
