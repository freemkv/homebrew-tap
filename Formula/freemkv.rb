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
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.2/freemkv-aarch64-macos-v1.7.2"
      sha256 "7460f34dba12ca3bff83cb17e857b946a27e86261874f432f9c96465ee3be3b7"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.2/freemkv-x86_64-macos-v1.7.2"
      sha256 "8758a582484437a3eb4dae20690d409692d8a5e365a871d9c4186943b124a6cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.2/freemkv-aarch64-linux-v1.7.2"
      sha256 "e8a4c2d1d41022436724c75e4f026db596c170b6417b4717aeace1931a213a4c"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.2/freemkv-x86_64-linux-v1.7.2"
      sha256 "95bbbc917c4b0c1d0d6031a90ad98596cf8c6a28ba6371a24c28138efdee7344"
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
