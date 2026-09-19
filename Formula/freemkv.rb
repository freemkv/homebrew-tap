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
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.3/freemkv-aarch64-macos-v1.7.3"
      sha256 "167b540031de4e326300408ed4417b435641ae58be226155c1dee5daa75873bf"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.3/freemkv-x86_64-macos-v1.7.3"
      sha256 "30c97bb11fa7d3b2c9f15987242d390fb9d7ef06803352a95757e37775a85018"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.3/freemkv-aarch64-linux-v1.7.3"
      sha256 "f1bb7a6641d219ee0c52c78b19d305e4cb43d16fd921e07d4218f2ee6d720d17"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.3/freemkv-x86_64-linux-v1.7.3"
      sha256 "fa830463193ba548ff04b9c9874b5ee10b0466944aeaf767cf16929c9083eb9b"
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
