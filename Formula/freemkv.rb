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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.13/freemkv-aarch64-macos-v1.6.13"
      sha256 "3e936f4de551d30db0e5a0c2b04ad3612396b3724df111ffcfa63d1bdeb880e6"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.13/freemkv-x86_64-macos-v1.6.13"
      sha256 "88c7142d5c33aca53b42d8599d69f3ffa91fa03883b0a182a99fe15c892a9322"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.13/freemkv-aarch64-linux-v1.6.13"
      sha256 "e6a92472b4c56b759786ed116fb370219cc462b5d68dbc5d22df774d72aae346"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.13/freemkv-x86_64-linux-v1.6.13"
      sha256 "666c17185cffe32d6f1f40780e83f9c2f9b675b89288da5fb24df88ab167d2bc"
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
