# The autorip unattended-ripping daemon.
#
# Homebrew downloads with curl, and curl does not set the com.apple.quarantine
# attribute -- only browsers do. So this install is not subject to the Gatekeeper
# prompt a downloaded binary gets, and works whether or not the binary is
# notarized. That is why this formula exists: the friction-free way to get
# autorip on a Mac. autorip ships an Apple Silicon macOS build only; on an Intel
# Mac use the Docker image (see the docs).
class Autorip < Formula
  desc "Unattended Blu-ray, UHD, DVD and HD DVD ripping daemon for freemkv"
  homepage "https://freemkv.org"
  version "1.6.14"
  license "MIT"
  # The release assets are not version-stamped in their filename, so the version
  # can't be scanned from the URL the way freemkv's is -- state it explicitly.

  on_macos do
    on_arm do
      url "https://github.com/freemkv/autorip/releases/download/v1.6.14/autorip-aarch64-macos"
      sha256 "92b3e09e7cfedab6e9eb0e4ad17dd420d823f2694e6a78a3d25d5db6ba44db6f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/autorip/releases/download/v1.6.14/autorip-aarch64-linux"
      sha256 "654068edc71835bb397c2caae627c125132145197ce3c274e76c6f1c6b322c33"
    end
    on_intel do
      url "https://github.com/freemkv/autorip/releases/download/v1.6.14/autorip-x86_64-linux"
      sha256 "56e6357addf8d65ae20ff8e66f540c100cb48bf5165c07610fd812c9693eea2f"
    end
  end

  def install
    # The release asset is the bare executable under a plain name; install it as
    # `autorip`.
    bin.install Dir["*"].first => "autorip"
  end

  def caveats
    <<~EOS
      autorip runs as a daemon with a web UI on port 8080. Like freemkv it needs
      a drive it can address directly and a key database or key service:

        freemkv update-keys

      Setup, keys and drive permissions: https://freemkv.org/docs/autorip/
    EOS
  end

  test do
    # `--version` prints "<version> (<commit>)"; match the leading version.
    assert_match version.to_s, shell_output("#{bin}/autorip --version")
  end
end
