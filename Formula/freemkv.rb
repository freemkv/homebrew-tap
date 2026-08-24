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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.10/freemkv-aarch64-macos-v1.6.10"
      sha256 "8db8c89804638f24f0e02c1ce608c1dd2e3a25c55d3ac8f1910ff2054ae549cb"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.10/freemkv-x86_64-macos-v1.6.10"
      sha256 "2caf1bdd5ab9ab79d3ddd346f66fbaf4b9f386456c3007c7560c6815fd4fef1a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.10/freemkv-aarch64-linux-v1.6.10"
      sha256 "4dcfc99918c09e7802e858228b2677b7c4916999bcb282fbcd53f718bd5b1931"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.10/freemkv-x86_64-linux-v1.6.10"
      sha256 "e5c1a0d8c2a47890eeec23a48a382b6d9deaa74e3cd9c34f76dee7cf769f4225"
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
