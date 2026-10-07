# fmv-key: look a disc's AACS unit keys up on the freemkv key service.
#
# Written by fmv-key's release workflow at each release; do not edit by hand.
# The binaries are published as this tap's fmv-key-v<version> release. Homebrew
# downloads with curl, which sets no com.apple.quarantine, so the install is not
# blocked by Gatekeeper and runs as the linker signed it.
class FmvKey < Formula
  desc "Look a disc's AACS unit keys up on the freemkv key service"
  homepage "https://freemkv.org"
  version "0.1.5"
  license "MIT"

  depends_on :macos

  on_arm do
    url "https://github.com/freemkv/homebrew-tap/releases/download/fmv-key-v0.1.5/fmv-key-macos-aarch64.tar.gz"
    sha256 "91c352b4ee84e862d0bed59a64e22b69cb6b9b060de0a673cc6c3adeeaa836b0"
  end
  on_intel do
    url "https://github.com/freemkv/homebrew-tap/releases/download/fmv-key-v0.1.5/fmv-key-macos-x86_64.tar.gz"
    sha256 "3b2131e250fce37878e881cd8a72253afc315c87978b9250f7f9eeb70131e875"
  end

  def install
    # The archive holds the bare executable under its plain name.
    bin.install "fmv-key"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fmv-key --version")
  end
end
