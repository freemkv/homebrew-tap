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
  # No explicit `version`: Homebrew scans it from the `v0.7.0` in each URL, so a
  # release bump moves the URLs and the version together and the two can never
  # disagree. `brew audit` flags a standalone version here as redundant.

  on_macos do
    on_arm do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.7.0/freemkv-fw-macos-aarch64.tar.gz"
      sha256 "605f88bfc21bcfe77bfa6249aa0eaa4597a1053894c9f4e110b98edcc7e5fcd1"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.7.0/freemkv-fw-macos-x86_64.tar.gz"
      sha256 "40b6b90a18587871df9a5e35e201229aba81cab21f797fc4953ee2dbb773b51b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/freemkv/freemkv-firmware/releases/download/v0.7.0/freemkv-fw-linux-x86_64.tar.gz"
      sha256 "381a9bd48978883c82fd2deb4673251dcc5f9183055f10920a7a2d2b05dce53b"
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
