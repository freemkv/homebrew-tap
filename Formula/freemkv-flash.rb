# The freemkv-flash command-line drive flasher/dumper.
#
# Homebrew downloads with curl, and curl does not set the com.apple.quarantine
# attribute -- only browsers do. So this install is not subject to the Gatekeeper
# prompt a downloaded binary gets, and works whether or not the binary is
# notarized. That is why this formula exists: it is the friction-free way to get
# the CLI on a Mac. The desktop app is a separate cask, freemkv-flash-gui.
#
# freemkv-flash and freemkv-fw are TWO tools in the same repo (freemkv-firmware),
# versioned together; each ships its own formula (CLI) and cask (GUI).
class FreemkvFlash < Formula
  desc "Generic MediaTek/Renesas optical-drive firmware flasher and dumper"
  homepage "https://freemkv.org/firmware/flash/"
  license "MIT"
  # No explicit `version`: Homebrew scans it from the version in each URL, so a
  # release bump moves the URLs and the version together and the two can never
  # disagree. `brew audit` flags a standalone version here as redundant.

  on_macos do
    on_arm do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.12.5/freemkv-flash-macos-aarch64.tar.gz"
      sha256 "47f88ab0a21301df466bd227f45b7e582e31866adda410c178ff9adfb7472b29"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.12.5/freemkv-flash-macos-x86_64.tar.gz"
      sha256 "02c9a4c9b5feef7b07b12a68fb0b9c669d3ecd28a71999a84b5b214a82583d14"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.12.5/freemkv-flash-linux-x86_64.tar.gz"
      sha256 "a627e2d29e9c158284db6409c84ed859fa133f9495be2574d3b71cdc73922c67"
    end
  end

  def install
    # The archive holds the bare executable under its plain name.
    bin.install "freemkv-flash"
  end

  def caveats
    <<~EOS
      freemkv-flash reads and writes optical-drive firmware. `info` and `dump`
      are read-only and safe; `flash` writes -- it backs up first and reads back
      to verify, but it can brick a drive if given the wrong image. It needs a
      drive it can address directly.

      Guide: https://freemkv.org/firmware/flash/
    EOS
  end

  test do
    # `--version` prints "freemkv-flash <version>"; match the leading version.
    assert_match version.to_s, shell_output("#{bin}/freemkv-flash --version")
  end
end
