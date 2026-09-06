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
  license "MIT"
  # No explicit `version`: Homebrew scans it from the `v1.7.0` in each URL, so a
  # release bump moves the URLs and the version together. `brew audit` flags a
  # standalone version here as redundant.

  on_macos do
    on_arm do
      url "https://github.com/freemkv/autorip/releases/download/v1.7.0/autorip-aarch64-macos"
      sha256 "c5f718ed45c746d175a4d3f161efdceea0ea230b7247306cc5e3aba22b5bafac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/autorip/releases/download/v1.7.0/autorip-aarch64-linux"
      sha256 "cc9f6a49fcc81a5d17750a922e44e151db91c2485fdd58c9e03c968ffbe7f808"
    end
    on_intel do
      url "https://github.com/freemkv/autorip/releases/download/v1.7.0/autorip-x86_64-linux"
      sha256 "c8ffaf094ca518b84f8b75b7675c10a638754d78708bfca6c4a1fcf19a69d683"
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
