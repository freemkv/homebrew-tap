# The freemkv-fw command-line firmware modifier ("modify").
#
# Homebrew downloads with curl, and curl does not set the com.apple.quarantine
# attribute -- only browsers do. So this install is not subject to the Gatekeeper
# prompt a downloaded binary gets, and works whether or not the binary is
# notarized. That is why this formula exists: it is the friction-free way to get
# the CLI on a Mac. The desktop app is a separate cask, freemkv-fw-gui.
#
# freemkv-flash and freemkv-fw are TWO tools in the same repo (freemkv-firmware),
# versioned together; each ships its own formula (CLI) and cask (GUI).
class FreemkvFw < Formula
  desc "Modify MediaTek MT19xx optical-drive firmware (create/verify images)"
  homepage "https://freemkv.org/firmware/modify/"
  license "MIT"
  # No explicit `version`: Homebrew scans it from the version in each URL, so a
  # release bump moves the URLs and the version together and the two can never
  # disagree. `brew audit` flags a standalone version here as redundant.

  on_macos do
    on_arm do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.13.4/freemkv-fw-macos-aarch64.tar.gz"
      sha256 "921ab603a7997ca5360f856f146857e3553080aef84d57da6d9f7a8e920ca149"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.13.4/freemkv-fw-macos-x86_64.tar.gz"
      sha256 "85b78eb4b0cb9e26c3f206a7c6373ffdd44e9ba78d75950ba8609b39078cdfdc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.13.4/freemkv-fw-linux-x86_64.tar.gz"
      sha256 "812229356695d8db2a571045153a7a8923a7c9183c9de0e76d56432a15c44854"
    end
  end

  def install
    # The archive holds the bare executable under its plain name.
    bin.install "freemkv-fw"
  end

  def caveats
    <<~EOS
      freemkv-fw builds and verifies modified drive-firmware images offline; it
      does not touch a drive itself -- pair it with freemkv-flash to write one.

      Guide: https://freemkv.org/firmware/modify/
    EOS
  end

  test do
    # `--version` prints "freemkv-fw <version>"; match the leading version.
    assert_match version.to_s, shell_output("#{bin}/freemkv-fw --version")
  end
end
