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
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.13.4/freemkv-flash-macos-aarch64.tar.gz"
      sha256 "013e618bb252208f61de0928e680f4dfad4aed2a8f9a108d65e78058f9997b7c"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.13.4/freemkv-flash-macos-x86_64.tar.gz"
      sha256 "ef68ecacc7485ac2d32a6aa85f13137b865c1ccd1062834f4ed72f7e5ffa658c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.13.4/freemkv-flash-linux-x86_64.tar.gz"
      sha256 "a5a16da9c162ec0d28c4021c370a85cfca881b546f14fd29acec406bbb85902f"
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
