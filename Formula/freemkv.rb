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
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.1/freemkv-aarch64-macos-v1.7.1"
      sha256 "2456b967b9efd316567b99f54d49ead51510aaaf3682ca76816306ef218a8519"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.1/freemkv-x86_64-macos-v1.7.1"
      sha256 "fbc6c707733c16dad677215b2e442b08feb7c1138a956fe6617b2eb2c0962a1f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.1/freemkv-aarch64-linux-v1.7.1"
      sha256 "9124080528a7238d737cc1a83e06faaf13c314374474d01e801a4ec9127fa31c"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.1/freemkv-x86_64-linux-v1.7.1"
      sha256 "5ad30ddc755aba229fc1f4153b20fb903d0bd2e285d0feca1fb219ce53ab16a9"
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
