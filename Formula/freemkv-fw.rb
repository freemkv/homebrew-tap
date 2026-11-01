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
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.17.1/freemkv-fw-macos-aarch64.tar.gz"
      sha256 "07fa9d64069a2787cd979321435830eb371bb86a1263694f157a9ee0993c64cf"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.17.1/freemkv-fw-macos-x86_64.tar.gz"
      sha256 "fee30a772e2aaf778529b7336c26c22dc2b6966a3bdc516b625e425977351d12"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.17.1/freemkv-fw-linux-x86_64.tar.gz"
      sha256 "413fa35f059d85fbc19dc8b40d413d6e412aa07914a89443a1de3d4a21436004"
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
