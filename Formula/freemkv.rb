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
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.7/freemkv-aarch64-macos-v1.6.7"
      sha256 "ee3a612d5fd8e1bdb220d834fd1bb6781e7f709de4d3142746adbc9baf48d9f0"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.7/freemkv-x86_64-macos-v1.6.7"
      sha256 "85f9471c0c6693c0d5214d6d897ed1bf460a3df92dc17c8c385a4b8e4eb4f41b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.7/freemkv-aarch64-linux-v1.6.7"
      sha256 "7ce99687d6dee146b963b050fb294b00c81730cf0061964eb86cc432244370e4"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.7/freemkv-x86_64-linux-v1.6.7"
      sha256 "e5670d2e42775a89c0a6b700a39d40d6dfec061aa7521ba93a43fdb43dca2752"
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
