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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.5/freemkv-aarch64-macos-v1.6.5"
      sha256 "cc795d1ff07bbbcb12b89f136ffb3c9750a874e18227f5f9e475f44e935eb9d7"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.5/freemkv-x86_64-macos-v1.6.5"
      sha256 "c0c818ece572c251d9ae3a62ec3f2156df744eea96450443cb0a43f10e5ce29b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.5/freemkv-aarch64-linux-v1.6.5"
      sha256 "a946cad8b65adf81f5299955d1fba1292e184cc031d2f51ad274841adbf2d21b"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.5/freemkv-x86_64-linux-v1.6.5"
      sha256 "97a5da4eada992a340e98e34d694dd7f131735c74f0cb037abda786e13d42730"
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
