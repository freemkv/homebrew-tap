# fmv-key: look a disc's AACS unit keys up on the freemkv key service.
#
# Written by fmv-key's release workflow at each release; do not edit by hand.
# The binaries are published as this tap's fmv-key-v<version> release. Homebrew
# downloads with curl, which sets no com.apple.quarantine, so the install is not
# blocked by Gatekeeper and runs as the linker signed it.
class FmvKey < Formula
  desc "Look a disc's AACS unit keys up on the freemkv key service"
  homepage "https://freemkv.org"
  version "0.2.0"
  license "MIT"

  depends_on :macos

  on_arm do
    url "https://github.com/freemkv/homebrew-tap/releases/download/fmv-key-v0.2.0/fmv-key-macos-aarch64.tar.gz"
    sha256 "928d7a68bc38c389138f74cbf4fc3637497fa12738e9dadd137005555c80ddf8"
  end
  on_intel do
    url "https://github.com/freemkv/homebrew-tap/releases/download/fmv-key-v0.2.0/fmv-key-macos-x86_64.tar.gz"
    sha256 "40544519158f9d0b8f3603d31599e178346a91159920e5aa6e6856718c8ca346"
  end

  def install
    # The archive holds the bare executable under its plain name.
    bin.install "fmv-key"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fmv-key --version")
  end
end
