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
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.7/freemkv-aarch64-macos-v1.7.7"
      sha256 "1ffec832cc616d0b38628566f138670d8ec5ade197e0f119ff4e04590d7b22b2"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.7/freemkv-x86_64-macos-v1.7.7"
      sha256 "d1e147270027b3b524d78bd8bc74ffef306af6e4cce2ba3f4918c53a846361f3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.7/freemkv-aarch64-linux-v1.7.7"
      sha256 "01a74f64bd11181e839ed00fee7241907482d9126bb57f3905df29a9abd7953b"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.7/freemkv-x86_64-linux-v1.7.7"
      sha256 "bbc30b5d2d2268e59e86fe5833b109bf85fde07fe588b6be099ec54558b86dc1"
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
