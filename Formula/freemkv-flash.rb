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
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.12.3/freemkv-flash-macos-aarch64.tar.gz"
      sha256 "653d005c54cad7251bfaa896e6569c653b37e0915ce4354a2cc42c24a417bfdc"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.12.3/freemkv-flash-macos-x86_64.tar.gz"
      sha256 "08998ac13b08043d2e4ebc01be70bfe641f23221c9e349f736e38e86ef1a1957"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.12.3/freemkv-flash-linux-x86_64.tar.gz"
      sha256 "b06e243e8444468ed73a024413f83d57e295144110ae98f695a8495b8d986073"
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
