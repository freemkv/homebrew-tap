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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.14/freemkv-aarch64-macos-v1.6.14"
      sha256 "5422ffb3f9bf0cefa8bbb43eff79283fa02778c95362656b22b80211cdcf8337"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.14/freemkv-x86_64-macos-v1.6.14"
      sha256 "537625721425856d910b74edeffce66f3f91a4e57fadda0b806d3e603eed82e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.14/freemkv-aarch64-linux-v1.6.14"
      sha256 "5c6c8ece4bede46c61a22e7fcc55c22692c6027531a1a1e889bac116fa07dd96"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.14/freemkv-x86_64-linux-v1.6.14"
      sha256 "b8b0b7b77ae3d9a9e14db6e50e38e718f5773cc1d56fb473bdbf007600772642"
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
