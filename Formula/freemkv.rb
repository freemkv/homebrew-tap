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
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.0/freemkv-aarch64-macos-v1.7.0"
      sha256 "2da17eed0a013b98585c4df40a8c5943a17d7d715b567e385593dee270edb914"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.0/freemkv-x86_64-macos-v1.7.0"
      sha256 "ec4abc6a793119c574151688c7265aac4929d9aecae946f0253b022bb4774f87"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.0/freemkv-aarch64-linux-v1.7.0"
      sha256 "dcc45a20d8ebb80a533da086887b07be728f3f09f68394047a8d76229d191200"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.0/freemkv-x86_64-linux-v1.7.0"
      sha256 "7ee8e4cff332b5fd8d32adf0d9df0d1f7ee23f2d7b1779f9a4fdac52413ef0c5"
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
