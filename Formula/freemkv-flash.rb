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
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.12.0/freemkv-flash-macos-aarch64.tar.gz"
      sha256 "2390ad336c52cb0c78f5228d61a34bbf44ccd4596ab1bbe438007896157ed2ae"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.12.0/freemkv-flash-macos-x86_64.tar.gz"
      sha256 "0df0ce3421d958a6f75b4a8ef4b26fefcf4d82420d53538b8747da03332f8a14"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.12.0/freemkv-flash-linux-x86_64.tar.gz"
      sha256 "ad40de03773c12b595b7d5d2db3db5b926d54af4905eae2aeb33b3dafd97cc74"
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
